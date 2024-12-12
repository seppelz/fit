import 'package:flutter/material.dart';

enum MuscleGroups {
  neck(
    displayName: 'Neck',
    description: 'Neck muscles including trapezius and levator scapulae',
    baseColor: Color(0xFF8D6E63), // Brown[600]
  ),
  shoulders(
    displayName: 'Shoulders',
    description: 'Deltoids and rotator cuff muscles',
    baseColor: Color(0xFF1E88E5), // Blue[600]
  ),
  arms(
    displayName: 'Arms',
    description: 'Biceps, triceps, and forearm muscles',
    baseColor: Color(0xFF546E7A), // BlueGrey[600]
  ),
  chest(
    displayName: 'Chest',
    description: 'Pectoralis major and minor',
    baseColor: Color(0xFFE53935), // Red[600]
  ),
  core(
    displayName: 'Core',
    description: 'Abdominal and lower back muscles',
    baseColor: Color(0xFF43A047), // Green[600]
  ),
  back(
    displayName: 'Back',
    description: 'Latissimus dorsi, rhomboids, and trapezius muscles',
    baseColor: Color(0xFF3949AB), // Indigo[600]
  ),
  legs(
    displayName: 'Legs',
    description: 'Quadriceps, hamstrings, calves, and glutes',
    baseColor: Color(0xFF616161), // Grey[700]
  );

  final String displayName;
  final String description;
  final Color baseColor;

  const MuscleGroups({
    required this.displayName,
    required this.description,
    required this.baseColor,
  });

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
