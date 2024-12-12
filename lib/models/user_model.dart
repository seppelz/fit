class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? companyId;
  final String? workStartTime;
  final String? workEndTime;
  final DateTime createdAt;
  final bool optOutRanking;
  final DateTime? lastStrengthTestDate;
  final Map<String, dynamic>? exercisePreferences;
  final List<bool>? workDays;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.companyId,
    this.workStartTime,
    this.workEndTime,
    DateTime? createdAt,
    this.optOutRanking = false,
    this.lastStrengthTestDate,
    this.exercisePreferences,
    this.workDays,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'company_id': companyId,
      'work_start_time': workStartTime,
      'work_end_time': workEndTime,
      'created_at': createdAt.toIso8601String(),
      'opt_out_ranking': optOutRanking,
      'last_strength_test_date': lastStrengthTestDate?.toIso8601String(),
      'exercise_preferences': exercisePreferences,
      'work_days': workDays,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      companyId: map['company_id'],
      workStartTime: map['work_start_time'],
      workEndTime: map['work_end_time'],
      createdAt: DateTime.parse(map['created_at']),
      optOutRanking: map['opt_out_ranking'] ?? false,
      lastStrengthTestDate: map['last_strength_test_date'] != null
          ? DateTime.parse(map['last_strength_test_date'])
          : null,
      exercisePreferences: map['exercise_preferences'],
      workDays: map['work_days'] != null ? List<bool>.from(map['work_days']) : null,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? companyId,
    String? workStartTime,
    String? workEndTime,
    DateTime? createdAt,
    bool? optOutRanking,
    DateTime? lastStrengthTestDate,
    Map<String, dynamic>? exercisePreferences,
    List<bool>? workDays,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      workStartTime: workStartTime ?? this.workStartTime,
      workEndTime: workEndTime ?? this.workEndTime,
      createdAt: createdAt ?? this.createdAt,
      optOutRanking: optOutRanking ?? this.optOutRanking,
      lastStrengthTestDate: lastStrengthTestDate ?? this.lastStrengthTestDate,
      exercisePreferences: exercisePreferences ?? this.exercisePreferences,
      workDays: workDays ?? this.workDays,
    );
  }
}
