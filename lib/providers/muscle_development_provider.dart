import 'package:flutter/foundation.dart';
import '../models/muscle_group_model.dart';

class MuscleDevelopmentProvider with ChangeNotifier {
  final Map<MuscleGroups, double> _developmentLevels = {};

  Map<MuscleGroups, double> get developmentLevels => _developmentLevels;

  double getDevelopment(MuscleGroups group) => _developmentLevels[group] ?? 0.0;

  void initializeDevelopmentData() {
    // Initialize with some sample development data
    _developmentLevels.addAll({
      MuscleGroups.neck: 0.3,
      MuscleGroups.shoulders: 0.5,
      MuscleGroups.chest: 0.4,
      MuscleGroups.arms: 0.6,
      MuscleGroups.core: 0.7,
      MuscleGroups.legs: 0.4,
    });
    notifyListeners();
  }

  void updateDevelopment(MuscleGroups group, double level) {
    if (level < 0.0) level = 0.0;
    if (level > 1.0) level = 1.0;
    
    _developmentLevels[group] = level;
    notifyListeners();
  }

  void incrementDevelopment(MuscleGroups group, double amount) {
    final currentLevel = getDevelopment(group);
    updateDevelopment(group, currentLevel + amount);
  }
}
