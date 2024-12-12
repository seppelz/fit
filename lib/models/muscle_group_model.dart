import 'package:flutter/material.dart';

enum MuscleGroups {
  neck(
    displayName: 'Neck',
    germanName: 'Nacken',
    description: 'Neck muscles including trapezius and levator scapulae',
    baseColor: Color(0xFF8D6E63), // Brown[600]
  ),
  shoulders(
    displayName: 'Shoulders',
    germanName: 'Schulter',
    description: 'Deltoids and rotator cuff muscles',
    baseColor: Color(0xFF1E88E5), // Blue[600]
  ),
  arms(
    displayName: 'Arms',
    germanName: 'Arme',
    description: 'Biceps, triceps, and forearm muscles',
    baseColor: Color(0xFF546E7A), // BlueGrey[600]
  ),
  chest(
    displayName: 'Chest',
    germanName: 'Brust',
    description: 'Pectoralis major and minor',
    baseColor: Color(0xFFE53935), // Red[600]
  ),
  core(
    displayName: 'Core',
    germanName: 'Bauch',
    description: 'Abdominal and lower back muscles',
    baseColor: Color(0xFF43A047), // Green[600]
  ),
  back(
    displayName: 'Back',
    germanName: 'Rücken',
    description: 'Latissimus dorsi, rhomboids, and trapezius muscles',
    baseColor: Color(0xFF3949AB), // Indigo[600]
  ),
  glutes(
    displayName: 'Glutes',
    germanName: 'Po',
    description: 'Gluteus muscles',
    baseColor: Color(0xFF616161), // Grey[700]
  ),
  legs(
    displayName: 'Legs',
    germanName: 'Beine',
    description: 'Quadriceps, hamstrings, calves',
    baseColor: Color(0xFF616161), // Grey[700]
  );

  final String displayName;
  final String germanName;
  final String description;
  final Color baseColor;

  const MuscleGroups({
    required this.displayName,
    required this.germanName,
    required this.description,
    required this.baseColor,
  });

  static MuscleGroups fromGermanName(String name) {
    return MuscleGroups.values.firstWhere(
      (muscle) => muscle.germanName.toLowerCase() == name.toLowerCase(),
      orElse: () => MuscleGroups.core,
    );
  }

  Color getDisplayColor({required bool isCompleted, required bool isHovered, double opacity = 1.0}) {
    if (isHovered) {
      return baseColor.withOpacity(0.8);
    }
    
    if (isCompleted) {
      // Light green glow for completed exercises
      return const Color(0xFF8BC34A).withOpacity(opacity); // Light green
    }
    
    // Light red for uncompleted exercises
    return const Color(0xFFFF5252).withOpacity(opacity); // Light red
  }
}
