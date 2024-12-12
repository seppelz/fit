import 'package:fit_at_work/services/exercise_service.dart';

class MockExerciseService extends ExerciseService {
  final List<Map<String, dynamic>> _completions = [];

  MockExerciseService() : super(firestore: null);

  @override
  Future<void> recordExerciseCompletion({
    required String userId,
    required String exerciseId,
    required DateTime completedAt,
    required int duration,
    required int caloriesBurned,
  }) async {
    _completions.add({
      'userId': userId,
      'exerciseId': exerciseId,
      'completedAt': completedAt.toIso8601String(),
      'duration': duration,
      'caloriesBurned': caloriesBurned,
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> getUserExerciseHistory(String userId) async* {
    yield _completions;
  }

  @override
  Future<Map<String, int>> getUserExerciseStats(String userId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    
    final todayCompletions = _completions.where((c) {
      final completedAt = DateTime.parse(c['completedAt']);
      return completedAt.isAfter(startOfDay);
    }).toList();

    return {
      'totalExercises': todayCompletions.length,
      'totalMinutes': todayCompletions.fold(0, (sum, c) => sum + (c['duration'] as int)),
      'totalCalories': todayCompletions.fold(0, (sum, c) => sum + (c['caloriesBurned'] as int)),
    };
  }

  List<Map<String, dynamic>> getCompletions() {
    return _completions;
  }
}
