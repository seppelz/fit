import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../models/user_model.dart';
import '../services/recommendation_service.dart';

class RecommendationProvider extends ChangeNotifier {
  final RecommendationService _recommendationService;
  List<Exercise> _recommendedExercises = [];
  Exercise? _nextExercise;
  bool _loading = false;

  RecommendationProvider({RecommendationService? recommendationService}) 
      : _recommendationService = recommendationService ?? RecommendationService();

  List<Exercise> get recommendedExercises => _recommendedExercises;
  Exercise? get nextExercise => _nextExercise;
  bool get loading => _loading;

  Future<void> loadRecommendations(UserModel user) async {
    _loading = true;
    notifyListeners();

    try {
      _recommendedExercises = await _recommendationService.getRecommendedExercises(user);
      _nextExercise = await _recommendationService.getPersonalizedExercise(user);
    } catch (e) {
      debugPrint('Error loading recommendations: $e');
      _recommendedExercises = [];
      _nextExercise = null;
    }

    _loading = false;
    notifyListeners();
  }

  Future<List<Exercise>> getWorkdaySchedule(UserModel user) async {
    return _recommendationService.getExercisesForWorkday(user);
  }
}
