import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../services/exercise_service.dart';

class ExerciseProgress {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final String muscleGroup;
  final String category;
  final DateTime date;
  final bool completed;
  final bool cancelled;
  final bool skipped;

  ExerciseProgress({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.muscleGroup,
    required this.category,
    required this.date,
    required this.completed,
    required this.cancelled,
    required this.skipped,
  });

  factory ExerciseProgress.fromMap(Map<String, dynamic> map) {
    return ExerciseProgress(
      id: map['id'].toString(),
      exerciseId: map['exercise_id'].toString(),
      exerciseName: map['exercise_name'] as String,
      muscleGroup: map['muscle_group'] as String,
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      completed: map['completed'] == 1,
      cancelled: map['cancelled'] == 1,
      skipped: map['skipped'] == 1,
    );
  }
}

class DailyProgress {
  final int totalExercises;
  final int completedExercises;
  final int cancelledExercises;
  final int skippedExercises;
  final DateTime date;

  DailyProgress({
    required this.totalExercises,
    required this.completedExercises,
    required this.cancelledExercises,
    required this.skippedExercises,
    required this.date,
  });
}

class ExerciseProgressProvider extends ChangeNotifier {
  final ExerciseService _exerciseService;
  List<ExerciseProgress> _recentProgress = [];
  DailyProgress? _todayProgress;
  bool _loading = false;

  ExerciseProgressProvider({ExerciseService? exerciseService}) 
      : _exerciseService = exerciseService ?? ExerciseService();

  List<ExerciseProgress> get recentProgress => _recentProgress;
  DailyProgress? get todayProgress => _todayProgress;
  bool get loading => _loading;

  Future<void> loadUserProgress(String userId) async {
    _loading = true;
    notifyListeners();

    try {
      // Load recent exercise completions
      final progressData = await _exerciseService.getUserExerciseHistory(userId);
      _recentProgress = progressData
          .map((p) => ExerciseProgress.fromMap(p))
          .take(10) // Get last 10 exercises
          .toList();

      // Load today's stats
      final stats = await _exerciseService.getUserExerciseStats(userId);
      _todayProgress = DailyProgress(
        totalExercises: stats['total_exercises'] as int,
        completedExercises: stats['completed'] as int,
        cancelledExercises: stats['cancelled'] as int,
        skippedExercises: stats['skipped'] as int,
        date: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error loading exercise progress: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> recordExerciseCompletion({
    required String userId,
    required Exercise exercise,
    required bool completed,
    required bool cancelled,
    required bool skipped,
  }) async {
    try {
      await _exerciseService.recordExerciseCompletion(
        userId: userId,
        exerciseId: exercise.id,
        completed: completed,
        cancelled: cancelled,
        skipped: skipped,
      );

      // Reload progress after recording
      await loadUserProgress(userId);
    } catch (e) {
      debugPrint('Error recording exercise completion: $e');
      rethrow;
    }
  }
}
