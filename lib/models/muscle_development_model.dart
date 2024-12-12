import 'package:flutter/material.dart';
import 'muscle_group_model.dart';

enum MuscleDevelopmentLevel {
  standard(1),
  defined(2),
  athletic(3),
  developed(4);

  final int level;
  const MuscleDevelopmentLevel(this.level);
}

class MuscleDevelopment {
  final MuscleGroup muscleGroup;
  final MuscleDevelopmentLevel level;
  final double progress; // 0.0 to 1.0 progress to next level

  const MuscleDevelopment({
    required this.muscleGroup,
    this.level = MuscleDevelopmentLevel.standard,
    this.progress = 0.0,
  });

  // Get the actual development factor (1.0 - 4.0)
  double get developmentFactor {
    return level.level + progress;
  }

  // Get muscle size multiplier based on development
  double get sizeMultiplier {
    return 1.0 + (developmentFactor - 1) * 0.15; // Max 45% bigger
  }

  // Get definition multiplier based on development
  double get definitionMultiplier {
    return 1.0 + (developmentFactor - 1) * 0.25; // Max 75% more defined
  }

  // Get the color opacity for shading
  double get shadingOpacity {
    return 0.1 + (developmentFactor - 1) * 0.15; // 0.1 to 0.55
  }

  // Get the highlight opacity for muscle definition
  double get highlightOpacity {
    return 0.05 + (developmentFactor - 1) * 0.15; // 0.05 to 0.5
  }

  MuscleDevelopment copyWith({
    MuscleDevelopmentLevel? level,
    double? progress,
  }) {
    return MuscleDevelopment(
      muscleGroup: muscleGroup,
      level: level ?? this.level,
      progress: progress ?? this.progress,
    );
  }
}
