import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart' show debugPrint;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fit_at_work.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      // Read and execute schema.sql
      String schema = await rootBundle.loadString('lib/models/database/schema.sql');
      List<String> statements = schema.split(';');
      
      for (String statement in statements) {
        if (statement.trim().isNotEmpty) {
          await db.execute(statement);
        }
      }

      // Read and execute seed_exercises.sql
      String seed = await rootBundle.loadString('lib/models/database/seed_exercises.sql');
      statements = seed.split(';');
      
      for (String statement in statements) {
        if (statement.trim().isNotEmpty) {
          await db.execute(statement);
        }
      }
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }

  // Exercise related methods
  Future<List<Map<String, dynamic>>> getExercisesByMuscleGroup({
    required String muscleGroup,
    bool? isSitting,
    bool? isTheraband,
    bool? isDynamic,
    bool? isOneSided,
  }) async {
    final db = await database;
    String query = '''
      SELECT * FROM exercises 
      WHERE muscle_group = ?
    ''';
    List<dynamic> args = [muscleGroup];

    if (isSitting != null) {
      query += ' AND is_sitting = ?';
      args.add(isSitting ? 1 : 0);
    }
    if (isTheraband != null) {
      query += ' AND is_theraband = ?';
      args.add(isTheraband ? 1 : 0);
    }
    if (isDynamic != null) {
      query += ' AND is_dynamic = ?';
      args.add(isDynamic ? 1 : 0);
    }
    if (isOneSided != null) {
      query += ' AND is_one_sided = ?';
      args.add(isOneSided ? 1 : 0);
    }

    return await db.rawQuery(query, args);
  }

  // Get exercise by ID
  Future<Map<String, dynamic>?> getExerciseById(int id) async {
    final db = await database;
    final results = await db.query(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  // Get all exercises
  Future<List<Map<String, dynamic>>> getAllExercises() async {
    final db = await database;
    final exercises = await db.query('exercises');
    debugPrint('Total exercises in database: ${exercises.length}');
    debugPrint('Exercise muscle groups: ${exercises.map((e) => e['muscle_group']).toSet()}');
    return exercises;
  }

  // Get exercise count
  Future<int> getExerciseCount() async {
    final db = await database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM exercises')) ?? 0;
  }

  // Get available muscle groups
  Future<List<String>> getAvailableMuscleGroups() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT DISTINCT muscle_group 
      FROM exercises 
      ORDER BY muscle_group
    ''');
    return result.map((row) => row['muscle_group'] as String).toList();
  }

  // Get exercise categories for a muscle group
  Future<List<String>> getCategoriesForMuscleGroup(String muscleGroup) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT DISTINCT category 
      FROM exercises 
      WHERE muscle_group = ?
      ORDER BY category
    ''', [muscleGroup]);
    return result.map((row) => row['category'] as String).toList();
  }

  // User Progress methods
  Future<void> logExercise({
    required String userId,
    required int exerciseId,
    required bool completed,
    required bool cancelled,
    required bool skipped,
  }) async {
    final db = await database;
    await db.insert('user_progress', {
      'user_id': userId,
      'exercise_id': exerciseId,
      'completed': completed ? 1 : 0,
      'cancelled': cancelled ? 1 : 0,
      'skipped': skipped ? 1 : 0,
    });
  }

  Future<List<Map<String, dynamic>>> getUserExerciseHistory(String userId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        up.*,
        e.name as exercise_name,
        e.muscle_group,
        e.category
      FROM user_progress up
      JOIN exercises e ON up.exercise_id = e.id
      WHERE up.user_id = ?
      ORDER BY up.date DESC
    ''', [userId]);
  }

  Future<Map<String, int>> getDailyProgress(String userId, DateTime date) async {
    final db = await database;
    final dateStr = date.toIso8601String().split('T')[0];
    
    final result = await db.rawQuery('''
      SELECT 
        COUNT(DISTINCT muscle_group) as muscle_groups,
        COUNT(*) as total_exercises
      FROM user_progress up
      JOIN exercises e ON up.exercise_id = e.id
      WHERE up.user_id = ? 
      AND date(up.date) = ?
      AND up.completed = 1
    ''', [userId, dateStr]);

    return {
      'muscle_groups': result.first['muscle_groups'] as int,
      'total_exercises': result.first['total_exercises'] as int,
    };
  }

  // Exercise frequency methods
  Future<void> recordExerciseShown(String userId, int exerciseId) async {
    final db = await database;
    await db.rawInsert('''
      INSERT INTO exercise_frequency (user_id, exercise_id, shown_count, last_shown)
      VALUES (?, ?, 1, CURRENT_TIMESTAMP)
      ON CONFLICT(user_id, exercise_id) DO UPDATE SET
        shown_count = shown_count + 1,
        last_shown = CURRENT_TIMESTAMP
    ''', [userId, exerciseId]);
  }

  Future<List<Map<String, dynamic>>> getLeastShownExercises({
    required String userId,
    required String muscleGroup,
    bool? isSitting,
    bool? isTheraband,
    bool? isDynamic,
    bool? isOneSided,
    int limit = 5,
  }) async {
    final db = await database;
    String query = '''
      SELECT 
        e.*,
        COALESCE(up.completed_count, 0) as completed_count,
        COALESCE(up.cancelled_count, 0) as cancelled_count,
        COALESCE(up.skipped_count, 0) as skipped_count,
        COALESCE(up.last_interaction, 0) as last_interaction
      FROM exercises e
      LEFT JOIN (
        SELECT 
          exercise_id,
          SUM(CASE WHEN completed = 1 THEN 1 ELSE 0 END) as completed_count,
          SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) as cancelled_count,
          SUM(CASE WHEN skipped = 1 THEN 1 ELSE 0 END) as skipped_count,
          MAX(date) as last_interaction
        FROM user_progress
        WHERE user_id = ?
        GROUP BY exercise_id
      ) up ON e.id = up.exercise_id
      WHERE e.muscle_group = ?
      ORDER BY RANDOM()
      LIMIT ?
    ''';
    List<dynamic> args = [userId, muscleGroup, limit];

    debugPrint('Running query with args: $args');
    final results = await db.rawQuery(query, args);
    debugPrint('Found ${results.length} exercises for muscle group $muscleGroup');
    debugPrint('Query results: $results');
    
    return results;
  }

  // Get scheduled exercises for a user
  Future<List<Map<String, dynamic>>> getScheduledExercises(String userId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT e.*, 
             COALESCE(p.completed_count, 0) as completed_count,
             COALESCE(p.cancelled_count, 0) as cancelled_count,
             COALESCE(p.skipped_count, 0) as skipped_count
      FROM exercises e
      LEFT JOIN exercise_progress p ON e.id = p.exercise_id AND p.user_id = ?
      ORDER BY e.id
    ''', [userId]);
  }

  // Schedule an exercise for a user
  Future<void> scheduleExercise(String userId, int exerciseId) async {
    final db = await database;
    await db.insert(
      'scheduled_exercises',
      {
        'user_id': userId,
        'exercise_id': exerciseId,
        'scheduled_for': DateTime.now().toIso8601String(),
      },
    );
  }
}
