class Exercise {
  final int id;
  final String videoId;
  final String name;
  final String preparation;
  final String execution;
  final String goal;
  final String? tips;
  final String muscleGroup;
  final String category;
  final bool isSitting;
  final bool isTheraband;
  final bool isDynamic;
  final bool isOneSided;

  Exercise({
    required this.id,
    required this.videoId,
    required this.name,
    required this.preparation,
    required this.execution,
    required this.goal,
    this.tips,
    required this.muscleGroup,
    required this.category,
    required this.isSitting,
    required this.isTheraband,
    required this.isDynamic,
    required this.isOneSided,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as int,
      videoId: map['video_id'] as String,
      name: map['name'] as String,
      preparation: map['preparation'] as String,
      execution: map['execution'] as String,
      goal: map['goal'] as String,
      tips: map['tips'] as String?,
      muscleGroup: map['muscle_group'] as String,
      category: map['category'] as String,
      isSitting: map['is_sitting'] == 1,
      isTheraband: map['is_theraband'] == 1,
      isDynamic: map['is_dynamic'] == 1,
      isOneSided: map['is_one_sided'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'video_id': videoId,
      'name': name,
      'preparation': preparation,
      'execution': execution,
      'goal': goal,
      'tips': tips,
      'muscle_group': muscleGroup,
      'category': category,
      'is_sitting': isSitting ? 1 : 0,
      'is_theraband': isTheraband ? 1 : 0,
      'is_dynamic': isDynamic ? 1 : 0,
      'is_one_sided': isOneSided ? 1 : 0,
    };
  }

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$videoId';
}
