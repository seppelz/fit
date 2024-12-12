import 'package:flutter/foundation.dart';
import '../models/exercise_model.dart';
import '../models/database/database_helper.dart';

class ExerciseService {
  final DatabaseHelper _dbHelper;

  ExerciseService({DatabaseHelper? dbHelper}) 
      : _dbHelper = dbHelper ?? DatabaseHelper();

  // Get all exercises
  Future<List<Exercise>> getExercises() async {
    final exercises = await _dbHelper.getAllExercises();
    return exercises.map((data) => Exercise.fromMap(data)).toList();
  }

  // Get exercises by muscle group with filters
  Future<List<Exercise>> getExercisesByMuscleGroup({
    required String muscleGroup,
    bool? isSitting,
    bool? isTheraband,
    bool? isDynamic,
    bool? isOneSided,
  }) async {
    final exercises = await _dbHelper.getExercisesByMuscleGroup(
      muscleGroup: muscleGroup,
      isSitting: isSitting,
      isTheraband: isTheraband,
      isDynamic: isDynamic,
      isOneSided: isOneSided,
    );
    return exercises.map((data) => Exercise.fromMap(data)).toList();
  }

  // Get available muscle groups
  Future<List<String>> getAvailableMuscleGroups() async {
    return await _dbHelper.getAvailableMuscleGroups();
  }

  // Get exercise categories for a muscle group
  Future<List<String>> getCategoriesForMuscleGroup(String muscleGroup) async {
    return await _dbHelper.getCategoriesForMuscleGroup(muscleGroup);
  }

  // Record exercise completion
  Future<void> recordExerciseCompletion({
    required String userId,
    required int exerciseId,
    required bool completed,
    required bool cancelled,
    required bool skipped,
  }) async {
    try {
      await _dbHelper.logExercise(
        userId: userId,
        exerciseId: exerciseId,
        completed: completed,
        cancelled: cancelled,
        skipped: skipped,
      );
    } catch (e) {
      debugPrint('Error recording exercise completion: $e');
      rethrow;
    }
  }

  // Get exercise by ID
  Future<Exercise?> getExerciseById(int id) async {
    final dbHelper = DatabaseHelper();
    final exerciseMap = await dbHelper.getExerciseById(id);
    
    if (exerciseMap != null) {
      return Exercise.fromMap(exerciseMap);
    }
    return null;
  }

  // Get user's exercise history
  Future<List<Map<String, dynamic>>> getUserExerciseHistory(String userId) async {
    return await _dbHelper.getUserExerciseHistory(userId);
  }

  // Get user's exercise stats for today
  Future<Map<String, dynamic>> getUserExerciseStats(String userId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final history = await _dbHelper.getUserExerciseHistory(userId);
      int totalExercises = 0;
      int totalCompleted = 0;
      int totalCancelled = 0;
      int totalSkipped = 0;

      for (var entry in history) {
        final completedAt = DateTime.parse(entry['date'] as String);
        if (completedAt.isAfter(startOfDay) && completedAt.isBefore(endOfDay)) {
          totalExercises++;
          if (entry['completed'] == 1) totalCompleted++;
          if (entry['cancelled'] == 1) totalCancelled++;
          if (entry['skipped'] == 1) totalSkipped++;
        }
      }

      return {
        'total_exercises': totalExercises,
        'completed': totalCompleted,
        'cancelled': totalCancelled,
        'skipped': totalSkipped,
      };
    } catch (e) {
      debugPrint('Error getting user exercise stats: $e');
      rethrow;
    }
  }

  // Schedule an exercise
  Future<void> scheduleExercise({
    required String userId,
    required int exerciseId,
    required DateTime scheduledFor,
  }) async {
    await _dbHelper.scheduleExercise(userId, exerciseId);
  }

  // Get user's scheduled exercises
  Future<List<Map<String, dynamic>>> getScheduledExercises(String userId) async {
    final scheduledExercises = await _dbHelper.getScheduledExercises(userId);
    return scheduledExercises;
  }

  // Get least shown exercises for a user
  Future<List<Exercise>> getLeastShownExercises({
    required String userId,
    required String muscleGroup,
    bool? isSitting,
    bool? isTheraband,
    bool? isDynamic,
    bool? isOneSided,
    int limit = 5,
  }) async {
    final exercises = await _dbHelper.getLeastShownExercises(
      userId: userId,
      muscleGroup: muscleGroup,
      isSitting: isSitting,
      isTheraband: isTheraband,
      isDynamic: isDynamic,
      isOneSided: isOneSided,
      limit: limit,
    );
    return exercises.map((data) {
      final exercise = Exercise.fromMap(data);
      // Add progress stats to exercise object
      exercise.completedCount = data['completed_count'] as int;
      exercise.cancelledCount = data['cancelled_count'] as int;
      exercise.skippedCount = data['skipped_count'] as int;
      return exercise;
    }).toList();
  }

  // Record that an exercise was shown to a user
  Future<void> recordExerciseShown({
    required String userId,
    required int exerciseId,
  }) async {
    await _dbHelper.recordExerciseShown(userId, exerciseId);
  }
}
