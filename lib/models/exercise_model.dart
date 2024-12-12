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
  final int id;
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

  // Progress tracking
  int _completedCount;
  int _cancelledCount;
  int _skippedCount;

  Exercise({
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
    int completedCount = 0,
    int cancelledCount = 0,
    int skippedCount = 0,
  })  : _completedCount = completedCount,
        _cancelledCount = cancelledCount,
        _skippedCount = skippedCount;

  // Getters and setters for progress tracking
  int get completedCount => _completedCount;
  set completedCount(int value) => _completedCount = value;

  int get cancelledCount => _cancelledCount;
  set cancelledCount(int value) => _cancelledCount = value;

  int get skippedCount => _skippedCount;
  set skippedCount(int value) => _skippedCount = value;

  Exercise copyWith({
    int? id,
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
    int? completedCount,
    int? cancelledCount,
    int? skippedCount,
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
      completedCount: completedCount ?? this.completedCount,
      cancelledCount: cancelledCount ?? this.cancelledCount,
      skippedCount: skippedCount ?? this.skippedCount,
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
      'completedCount': completedCount,
      'cancelledCount': cancelledCount,
      'skippedCount': skippedCount,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['execution'] as String? ?? '', 
      videoUrl: map['video_id'] as String? ?? '',
      targetMuscleGroup: MuscleGroups.fromGermanName(map['muscle_group'] as String),
      type: map['category'] == 'Kraft' ? ExerciseType.strength : ExerciseType.mobilization,
      position: (map['is_sitting'] as int? ?? 0) == 1 ? ExercisePosition.sitting : ExercisePosition.standing,
      equipment: (map['is_theraband'] as int? ?? 0) == 1 ? ExerciseEquipment.theraband : ExerciseEquipment.bodyweight,
      movement: (map['is_dynamic'] as int? ?? 0) == 1 ? ExerciseMovement.dynamic : ExerciseMovement.static,
      side: (map['is_one_sided'] as int? ?? 0) == 1 ? ExerciseSide.alternating : ExerciseSide.both,
      duration: const Duration(minutes: 3), 
      completedCount: map['completed_count'] as int? ?? 0,
      cancelledCount: map['cancelled_count'] as int? ?? 0,
      skippedCount: map['skipped_count'] as int? ?? 0,
    );
  }
}
