import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

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
    // Read and execute schema.sql
    String schemaPath = join(Directory.current.path, 'lib', 'models', 'database', 'schema.sql');
    String schema = await File(schemaPath).readAsString();
    List<String> statements = schema.split(';');
    
    for (String statement in statements) {
      if (statement.trim().isNotEmpty) {
        await db.execute(statement);
      }
    }

    // Read and execute seed_exercises.sql
    String seedPath = join(Directory.current.path, 'lib', 'models', 'database', 'seed_exercises.sql');
    String seed = await File(seedPath).readAsString();
    statements = seed.split(';');
    
    for (String statement in statements) {
      if (statement.trim().isNotEmpty) {
        await db.execute(statement);
      }
    }
  }

  // Exercise related methods
  Future<List<Map<String, dynamic>>> getExercisesByMuscleGroup(String muscleGroup) async {
    final db = await database;
    return await db.query(
      'exercises',
      where: 'muscle_group = ?',
      whereArgs: [muscleGroup],
    );
  }

  Future<List<Map<String, dynamic>>> getFilteredExercises({
    required String muscleGroup,
    required bool allowStanding,
    required bool allowSitting,
    required bool allowTheraband,
    required bool allowStrengthening,
    required bool allowMobilisation,
  }) async {
    final db = await database;
    return await db.query(
      'exercises',
      where: '''
        muscle_group = ? AND
        ((is_sitting = ? AND ?) OR (is_sitting = ? AND ?)) AND
        (is_theraband = ? OR is_theraband = ?) AND
        (category = ? OR category = ?)
      ''',
      whereArgs: [
        muscleGroup,
        true, allowSitting,
        false, allowStanding,
        allowTheraband, false,
        allowStrengthening ? 'Kraft' : '',
        allowMobilisation ? 'Mobilisation' : '',
      ],
    );
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
}
