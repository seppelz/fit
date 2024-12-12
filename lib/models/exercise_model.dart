import 'package:fit_at_work/models/muscle_group_model.dart';

enum ExerciseType {
  strength,
  mobilization
}

enum ExercisePosition {
  sitting,
  standing
}

enum ExerciseEquipment {
  bodyweight,
  theraband
}

enum ExerciseMovement {
  static,
  dynamic
}

enum ExerciseSide {
  both,
  alternating
}

class Exercise {
  final String id;
  final String name;
  final String description;
  final String videoUrl;
  final MuscleGroups targetMuscleGroup;
  final ExerciseType type;
  final ExercisePosition position;
  final ExerciseEquipment equipment;
  final ExerciseMovement movement;
  final ExerciseSide side;
  final Duration duration;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.videoUrl,
    required this.targetMuscleGroup,
    required this.type,
    required this.position,
    required this.equipment,
    required this.movement,
    required this.side,
    required this.duration,
  });

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? videoUrl,
    MuscleGroups? targetMuscleGroup,
    ExerciseType? type,
    ExercisePosition? position,
    ExerciseEquipment? equipment,
    ExerciseMovement? movement,
    ExerciseSide? side,
    Duration? duration,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      targetMuscleGroup: targetMuscleGroup ?? this.targetMuscleGroup,
      type: type ?? this.type,
      position: position ?? this.position,
      equipment: equipment ?? this.equipment,
      movement: movement ?? this.movement,
      side: side ?? this.side,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'videoUrl': videoUrl,
      'targetMuscleGroup': targetMuscleGroup.toString(),
      'type': type.toString(),
      'position': position.toString(),
      'equipment': equipment.toString(),
      'movement': movement.toString(),
      'side': side.toString(),
      'duration': duration.inMinutes,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      videoUrl: map['videoUrl'] as String,
      targetMuscleGroup: MuscleGroups.values.firstWhere((element) => element.toString() == map['targetMuscleGroup']),
      type: ExerciseType.values.firstWhere((element) => element.toString() == map['type']),
      position: ExercisePosition.values.firstWhere((element) => element.toString() == map['position']),
      equipment: ExerciseEquipment.values.firstWhere((element) => element.toString() == map['equipment']),
      movement: ExerciseMovement.values.firstWhere((element) => element.toString() == map['movement']),
      side: ExerciseSide.values.firstWhere((element) => element.toString() == map['side']),
      duration: Duration(minutes: map['duration'] as int),
    );
  }
}
