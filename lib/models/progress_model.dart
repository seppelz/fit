import 'package:flutter/foundation.dart';
import 'package:fit_at_work/models/exercise_model.dart';
import 'package:fit_at_work/models/muscle_group_model.dart';

class ProgressModel extends ChangeNotifier {
  final Map<DateTime, Map<MuscleGroups, List<Exercise>>> _exerciseHistory = {};
  final Set<String> _favoriteExercises = {};
  
  // Points System Constants
  static const int basePointsPerExercise = 100;
  static const int dailyCompletionBonus = 500;
  static const int streakBonus3Days = 300;
  static const int streakBonus5Days = 500;
  static const int streakBonus7Days = 1000;

  // Get total number of muscle groups
  int get _totalMuscleGroups => MuscleGroups.values.length;

  // Today's Progress
  Map<MuscleGroups, List<Exercise>> get todayExercises {
    final today = DateTime.now();
    return _exerciseHistory[today] ?? {};
  }

  // Progress Getters
  double get todayProgress {
    final completed = todayExercises.keys.length;
    return completed / _totalMuscleGroups;
  }

  int get todayPoints {
    int points = 0;
    
    // Base points for each exercise
    for (var exercises in todayExercises.values) {
      points += basePointsPerExercise;
      
      // Bonus points for extra exercises
      if (exercises.length > 1) {
        for (int i = 1; i < exercises.length; i++) {
          points += 150 + (50 * (i - 1));
        }
      }
    }
    
    // Daily completion bonus
    if (todayProgress == 1.0) {
      points += dailyCompletionBonus;
    }
    
    // Streak bonus
    final streak = currentStreak;
    if (streak >= 7) points += streakBonus7Days;
    else if (streak >= 5) points += streakBonus5Days;
    else if (streak >= 3) points += streakBonus3Days;
    
    return points;
  }

  int get currentStreak {
    int streak = 0;
    var date = DateTime.now();
    
    while (_exerciseHistory.containsKey(date) &&
           _exerciseHistory[date]!.length == _totalMuscleGroups) {
      streak++;
      date = date.subtract(Duration(days: 1));
    }
    
    return streak;
  }

  // Weekly and Monthly Progress
  double getWeeklyProgress() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    int completedDays = 0;
    int totalDays = 0;
    
    for (var i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      if (_exerciseHistory.containsKey(date)) {
        if (_exerciseHistory[date]!.length == _totalMuscleGroups) {
          completedDays++;
        }
        totalDays++;
      }
    }
    
    return totalDays > 0 ? completedDays / totalDays : 0;
  }

  double getMonthlyProgress() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    
    int completedDays = 0;
    int totalDays = 0;
    
    for (var i = 0; i < daysInMonth; i++) {
      final date = startOfMonth.add(Duration(days: i));
      if (date.isBefore(now) || date.isAtSameMomentAs(now)) {
        if (_exerciseHistory.containsKey(date)) {
          if (_exerciseHistory[date]!.length == _totalMuscleGroups) {
            completedDays++;
          }
        }
        totalDays++;
      }
    }
    
    return totalDays > 0 ? completedDays / totalDays : 0;
  }

  // Exercise Management
  void completeExercise(Exercise exercise) {
    final today = DateTime.now();
    _exerciseHistory.putIfAbsent(today, () => {});
    _exerciseHistory[today]!.putIfAbsent(exercise.targetMuscleGroup, () => []);
    _exerciseHistory[today]![exercise.targetMuscleGroup]!.add(exercise);
    notifyListeners();
  }

  // Favorites Management
  bool isFavorite(String exerciseId) => _favoriteExercises.contains(exerciseId);

  void toggleFavorite(String exerciseId) {
    if (isFavorite(exerciseId)) {
      _favoriteExercises.remove(exerciseId);
    } else {
      _favoriteExercises.add(exerciseId);
    }
    notifyListeners();
  }

  List<String> get favoriteExercises => _favoriteExercises.toList();
}
