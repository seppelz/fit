import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/exercise_model.dart';

class ExerciseService {
  final FirebaseFirestore? _firestore;

  ExerciseService({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get all exercises
  Stream<List<Exercise>> getExercises() {
    if (_firestore == null) {
      return Stream.value([]);
    }

    return _firestore!
        .collection('exercises')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Exercise.fromMap({
          'id': doc.id,
          ...data,
        });
      }).toList();
    });
  }

  // Get exercises by category
  Stream<List<Exercise>> getExercisesByCategory(String category) {
    if (_firestore == null) {
      return Stream.value([]);
    }

    return _firestore!
        .collection('exercises')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Exercise.fromMap({
          'id': doc.id,
          ...data,
        });
      }).toList();
    });
  }

  // Get exercise by ID
  Future<Exercise?> getExerciseById(String id) async {
    if (_firestore == null) {
      return null;
    }

    final doc = await _firestore!.collection('exercises').doc(id).get();
    if (doc.exists) {
      return Exercise.fromMap({
        'id': doc.id,
        ...doc.data()!,
      });
    }
    return null;
  }

  // Record exercise completion
  Future<void> recordExerciseCompletion({
    required String userId,
    required String exerciseId,
    required DateTime completedAt,
    required int duration,
    required int caloriesBurned,
  }) async {
    if (_firestore == null) return;

    try {
      final completionRef = _firestore!
          .collection('users')
          .doc(userId)
          .collection('exercise_completions')
          .doc();

      await completionRef.set({
        'id': completionRef.id,
        'exerciseId': exerciseId,
        'completedAt': completedAt.toIso8601String(),
        'duration': duration,
        'caloriesBurned': caloriesBurned,
      });
    } catch (e) {
      debugPrint('Error recording exercise completion: $e');
      rethrow;
    }
  }

  // Get user's exercise history
  Stream<List<Map<String, dynamic>>> getUserExerciseHistory(String userId) async* {
    if (_firestore == null) {
      yield [];
      return;
    }

    yield* _firestore!
        .collection('users')
        .doc(userId)
        .collection('exercise_completions')
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'exerciseId': doc['exerciseId'],
                  'completedAt': doc['completedAt'],
                  'duration': doc['duration'],
                  'caloriesBurned': doc['caloriesBurned'],
                })
            .toList());
  }

  // Get user's exercise stats for today
  Future<Map<String, dynamic>> getUserExerciseStats(String userId) async {
    if (_firestore == null) {
      return {
        'totalExercises': 0,
        'totalMinutes': 0,
        'totalCalories': 0,
      };
    }

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final querySnapshot = await _firestore!
          .collection('users')
          .doc(userId)
          .collection('exercise_completions')
          .where('completedAt',
              isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('completedAt', isLessThan: endOfDay.toIso8601String())
          .get();

      int totalExercises = querySnapshot.docs.length;
      int totalMinutes = 0;
      int totalCalories = 0;

      for (var doc in querySnapshot.docs) {
        totalMinutes += doc['duration'] as int;
        totalCalories += doc['caloriesBurned'] as int;
      }

      return {
        'totalExercises': totalExercises,
        'totalMinutes': totalMinutes,
        'totalCalories': totalCalories,
      };
    } catch (e) {
      debugPrint('Error getting user exercise stats: $e');
      return {
        'totalExercises': 0,
        'totalMinutes': 0,
        'totalCalories': 0,
      };
    }
  }

  // Schedule an exercise
  Future<void> scheduleExercise({
    required String userId,
    required String exerciseId,
    required DateTime scheduledFor,
  }) async {
    if (_firestore == null) return;

    await _firestore!.collection('scheduled_exercises').add({
      'userId': userId,
      'exerciseId': exerciseId,
      'scheduledFor': scheduledFor.toIso8601String(),
      'completed': false,
    });
  }

  // Get user's scheduled exercises
  Stream<List<Map<String, dynamic>>> getScheduledExercises(String userId) {
    if (_firestore == null) {
      return Stream.value([]);
    }

    return _firestore!
        .collection('scheduled_exercises')
        .where('userId', isEqualTo: userId)
        .where('scheduledFor',
            isGreaterThanOrEqualTo: DateTime.now().toIso8601String())
        .orderBy('scheduledFor')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => {
            'id': doc.id,
            ...doc.data(),
          }).toList();
    });
  }
}
