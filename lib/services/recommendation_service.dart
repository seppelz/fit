import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_model.dart';
import '../models/user_model.dart';
import '../models/muscle_group_model.dart';

class RecommendationService {
  final FirebaseFirestore? _firestore;

  RecommendationService({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const int _maxScore = 100;

  // Calculate a score for each exercise based on user preferences
  Map<Exercise, int> _calculateExerciseScores(
    List<Exercise> exercises,
    Map<String, dynamic> preferences,
  ) {
    final scores = <Exercise, int>{};
    final preferredDuration = preferences['duration'] as Duration;
    final hasTheraband = preferences['hasTheraband'] as bool;
    final activeTypes = preferences['activeTypes'] as Set<ExerciseType>;
    final activePositions = preferences['activePositions'] as Set<ExercisePosition>;
    final activeMovements = preferences['activeMovements'] as Set<ExerciseMovement>;
    final activeSides = preferences['activeSides'] as Set<ExerciseSide>;

    for (final exercise in exercises) {
      var score = _maxScore;

      // Equipment check - if exercise needs theraband but user doesn't have it, skip
      if (exercise.equipment == ExerciseEquipment.theraband && !hasTheraband) {
        continue;
      }

      // Type check
      if (!activeTypes.contains(exercise.type)) {
        continue;
      }

      // Position check
      if (!activePositions.contains(exercise.position)) {
        continue;
      }

      // Movement check
      if (!activeMovements.contains(exercise.movement)) {
        continue;
      }

      // Side check
      if (!activeSides.contains(exercise.side)) {
        continue;
      }

      // Duration preference scoring
      final durationDiff = (exercise.duration.inMinutes - preferredDuration.inMinutes).abs();
      if (durationDiff <= 1) {
        // Perfect duration match
        score -= 0;
      } else if (durationDiff <= 2) {
        // Close duration match
        score -= 10;
      } else {
        // Duration mismatch
        score -= 20;
      }

      scores[exercise] = score;
    }

    return scores;
  }

  Future<List<Exercise>> getRecommendedExercises(UserModel user) async {
    if (_firestore == null) {
      return _getDummyExercises();
    }

    // Get user's exercise preferences
    final preferences = user.exercisePreferences;
    if (preferences == null) return [];

    // Get all exercises
    final exercisesSnapshot = await _firestore!.collection('exercises').get();
    final allExercises = exercisesSnapshot.docs
        .map((doc) => Exercise.fromMap({'id': doc.id, ...doc.data()}))
        .toList();

    // Get user's completed exercises for today
    final completedExercises = await _getCompletedExercisesToday(user.id);

    // Calculate scores for each exercise
    final scores = _calculateExerciseScores(allExercises, preferences);

    // Sort exercises by score
    final sortedExercises = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Return exercises with scores above 50
    return sortedExercises
        .where((entry) => entry.value >= 50)
        .map((entry) => entry.key)
        .toList();
  }

  Future<Exercise?> getPersonalizedExercise(UserModel user) async {
    if (_firestore == null) {
      return _getDummyExercises().first;
    }

    final recommendations = await getRecommendedExercises(user);
    if (recommendations.isEmpty) return null;
    return recommendations.first;
  }

  Future<List<Exercise>> getExercisesForWorkday(UserModel user) async {
    if (_firestore == null) {
      return _getDummyExercises();
    }

    final recommendations = await getRecommendedExercises(user);
    return recommendations;
  }

  Future<List<String>> _getCompletedExercisesToday(String userId) async {
    if (_firestore == null) return [];

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final completionsSnapshot = await _firestore!
        .collection('users')
        .doc(userId)
        .collection('exercise_completions')
        .where('completedAt', isGreaterThanOrEqualTo: startOfDay)
        .where('completedAt', isLessThan: endOfDay)
        .get();

    return completionsSnapshot.docs.map((doc) => doc['exerciseId'] as String).toList();
  }

  List<Exercise> _getDummyExercises() {
    return [
      Exercise(
        id: '1',
        name: 'Morning Desk Stretches',
        description: 'Start your day with these energizing desk stretches',
        videoUrl: 'https://example.com/desk-stretches',
        targetMuscleGroup: MuscleGroups.shoulders,
        type: ExerciseType.mobilization,
        position: ExercisePosition.sitting,
        equipment: ExerciseEquipment.bodyweight,
        movement: ExerciseMovement.dynamic,
        side: ExerciseSide.both,
        duration: Duration(minutes: 5),
      ),
      Exercise(
        id: '2',
        name: 'Standing Break Exercises',
        description: 'Quick exercises to do during your break',
        videoUrl: 'https://example.com/break-exercises',
        targetMuscleGroup: MuscleGroups.legs,
        type: ExerciseType.strength,
        position: ExercisePosition.standing,
        equipment: ExerciseEquipment.bodyweight,
        movement: ExerciseMovement.dynamic,
        side: ExerciseSide.alternating,
        duration: Duration(minutes: 10),
      ),
      Exercise(
        id: '3',
        name: 'Core Stabilization',
        description: 'Build core strength with these office-friendly exercises',
        videoUrl: 'https://example.com/core-exercises',
        targetMuscleGroup: MuscleGroups.core,
        type: ExerciseType.strength,
        position: ExercisePosition.sitting,
        equipment: ExerciseEquipment.bodyweight,
        movement: ExerciseMovement.static,
        side: ExerciseSide.both,
        duration: Duration(minutes: 15),
      ),
      Exercise(
        id: '4',
        name: 'Neck Relief',
        description: 'Relieve tension in your neck and shoulders',
        videoUrl: 'https://example.com/neck-relief',
        targetMuscleGroup: MuscleGroups.neck,
        type: ExerciseType.mobilization,
        position: ExercisePosition.sitting,
        equipment: ExerciseEquipment.bodyweight,
        movement: ExerciseMovement.dynamic,
        side: ExerciseSide.both,
        duration: Duration(minutes: 5),
      ),
      Exercise(
        id: '5',
        name: 'Full Body Energizer',
        description: 'Get your energy levels up during lunch',
        videoUrl: 'https://example.com/energizer',
        targetMuscleGroup: MuscleGroups.legs,
        type: ExerciseType.strength,
        position: ExercisePosition.standing,
        equipment: ExerciseEquipment.bodyweight,
        movement: ExerciseMovement.dynamic,
        side: ExerciseSide.alternating,
        duration: Duration(minutes: 20),
      ),
    ];
  }
}
