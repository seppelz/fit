import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_model.dart';
import '../services/exercise_service.dart';

class ExerciseProgress {
  final String id;
  final String exerciseId;
  final DateTime completedAt;
  final int duration;
  final int caloriesBurned;

  ExerciseProgress({
    required this.id,
    required this.exerciseId,
    required this.completedAt,
    required this.duration,
    required this.caloriesBurned,
  });

  factory ExerciseProgress.fromMap(Map<String, dynamic> map) {
    return ExerciseProgress(
      id: map['id'] as String,
      exerciseId: map['exerciseId'] as String,
      completedAt: DateTime.parse(map['completedAt'] as String),
      duration: map['duration'] as int,
      caloriesBurned: map['caloriesBurned'] as int,
    );
  }
}

class DailyProgress {
  final int totalExercises;
  final int totalMinutes;
  final int totalCalories;
  final DateTime date;

  DailyProgress({
    required this.totalExercises,
    required this.totalMinutes,
    required this.totalCalories,
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
      final progressStream = _exerciseService.getUserExerciseHistory(userId);
      await for (final progress in progressStream) {
        _recentProgress = progress
            .map((p) => ExerciseProgress.fromMap(p))
            .take(10) // Get last 10 exercises
            .toList();
        break; // Only get the first emission
      }

      // Load today's stats
      final stats = await _exerciseService.getUserExerciseStats(userId);
      _todayProgress = DailyProgress(
        totalExercises: stats['totalExercises'] as int,
        totalMinutes: stats['totalMinutes'] as int,
        totalCalories: stats['totalCalories'] as int,
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
    required int actualDuration,
    required int actualCalories,
  }) async {
    try {
      await _exerciseService.recordExerciseCompletion(
        userId: userId,
        exerciseId: exercise.id,
        completedAt: DateTime.now(),
        duration: actualDuration,
        caloriesBurned: actualCalories,
      );

      // Refresh progress after recording completion
      await loadUserProgress(userId);
    } catch (e) {
      debugPrint('Error recording exercise completion: $e');
      rethrow;
    }
  }

  double get dailyProgressPercentage {
    if (_todayProgress == null) return 0.0;
    // Assuming a daily goal of 30 minutes
    return (_todayProgress!.totalMinutes / 30).clamp(0.0, 1.0);
  }

  bool get dailyGoalAchieved {
    return dailyProgressPercentage >= 1.0;
  }

  String get dailyProgressMessage {
    if (_todayProgress == null) return 'Start your first exercise!';
    
    final remaining = 30 - _todayProgress!.totalMinutes;
    if (remaining <= 0) {
      return 'Daily goal achieved! 🎉';
    } else {
      return '$remaining minutes left to reach your daily goal';
    }
  }

  List<MapEntry<String, int>> getWeeklyProgress() {
    final weekProgress = List.generate(7, (index) {
      final date = DateTime.now().subtract(Duration(days: 6 - index));
      final progress = _recentProgress.where((p) {
        return p.completedAt.year == date.year &&
            p.completedAt.month == date.month &&
            p.completedAt.day == date.day;
      });
      
      return MapEntry(
        '${date.month}/${date.day}',
        progress.fold(0, (sum, p) => sum + p.duration),
      );
    });

    return weekProgress;
  }

  Map<String, int> getCategoryBreakdown() {
    final categories = <String, int>{};
    for (final progress in _recentProgress) {
      categories.update(
        progress.exerciseId,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return categories;
  }
}
