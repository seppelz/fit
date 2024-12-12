enum MuscleGroups {
    neck(
    displayName: 'Neck',
    description: 'Neck muscles including trapezius and levator scapulae',
  ),
  shoulders(
    displayName: 'Shoulders',
    description: 'Deltoids and rotator cuff muscles',
  ),
  arms(
    displayName: 'Arms',
    description: 'Biceps, triceps, and forearm muscles',
  ),
  chest(
    displayName: 'Chest',
    description: 'Pectoralis major and minor',
  ),
  core(
    displayName: 'Core',
    description: 'Abdominal and lower back muscles',
  ),
  back(
  displayName: 'Back',
  description: 'Latissimus dorsi, rhomboids, and trapezius muscles',
),
  legs(
    displayName: 'Legs',
    description: 'Quadriceps, hamstrings, calves, and glutes',
  );

  final String displayName;
  final String description;

  const MuscleGroups({
    required this.displayName,
    required this.description,
  });
}
