import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../models/muscle_group_model.dart';

class HexagonalGridPainter extends CustomPainter {
  static const Map<String, List<Offset>> decorativeElements = {
    'head': [Offset(0.5, 0.05)], // Single hexagon for head
  };

  // Front view muscle positions
  static const Map<MuscleGroups, List<Offset>> muscleGridPositions = {
    MuscleGroups.neck: [
      Offset(0.5, 0.12),  // Center of neck
      Offset(0.45, 0.13), // Left side
      Offset(0.55, 0.13), // Right side
    ],
    MuscleGroups.shoulders: [
      Offset(0.35, 0.15),
      Offset(0.65, 0.15),
    ],
    MuscleGroups.chest: [
      Offset(0.4, 0.22),
      Offset(0.5, 0.22),
      Offset(0.6, 0.22),
    ],
    MuscleGroups.arms: [
      // Biceps
      Offset(0.3, 0.25),
      Offset(0.7, 0.25),
      // Triceps
      Offset(0.25, 0.3),
      Offset(0.75, 0.3),
    ],
    MuscleGroups.core: [
      // Upper abs
      Offset(0.5, 0.35),
      // Mid abs
      Offset(0.5, 0.45),
      // Lower abs
      Offset(0.5, 0.55),
    ],
    MuscleGroups.legs: [
      // Quads
      Offset(0.4, 0.65),
      Offset(0.6, 0.65),
      Offset(0.4, 0.75),
      Offset(0.6, 0.75),
      // Calves
      Offset(0.4, 0.85),
      Offset(0.6, 0.85),
    ],
  };

  // Back view muscle positions
  static const Map<MuscleGroups, List<Offset>> backMuscleGridPositions = {
    MuscleGroups.neck: [
      Offset(0.5, 0.12),  // Center of neck
      Offset(0.45, 0.13), // Left side
      Offset(0.55, 0.13), // Right side
    ],
    MuscleGroups.shoulders: [
      Offset(0.35, 0.15),
      Offset(0.65, 0.15),
    ],
    MuscleGroups.back: [
      // Upper back (traps)
      Offset(0.4, 0.22),
      Offset(0.5, 0.22),
      Offset(0.6, 0.22),
      // Mid back (lats)
      Offset(0.35, 0.32),
      Offset(0.5, 0.32),
      Offset(0.65, 0.32),
      // Lower back
      Offset(0.4, 0.42),
      Offset(0.5, 0.42),
      Offset(0.6, 0.42),
    ],
    MuscleGroups.arms: [
      // Triceps (visible from back)
      Offset(0.25, 0.25),
      Offset(0.75, 0.25),
      // Biceps (slightly visible)
      Offset(0.3, 0.3),
      Offset(0.7, 0.3),
    ],
    MuscleGroups.legs: [
      // Hamstrings
      Offset(0.4, 0.65),
      Offset(0.6, 0.65),
      Offset(0.4, 0.75),
      Offset(0.6, 0.75),
      // Calves
      Offset(0.4, 0.85),
      Offset(0.6, 0.85),
    ],
  };

  static const Map<MuscleGroups, Color> muscleColors = {
    MuscleGroups.neck: Colors.cyan,
    MuscleGroups.shoulders: Colors.purple,
    MuscleGroups.chest: Colors.blue,
    MuscleGroups.back: Colors.indigo,
    MuscleGroups.arms: Colors.green,
    MuscleGroups.core: Colors.orange,
    MuscleGroups.legs: Colors.red,
  };

  final MuscleGroups? hoveredMuscle;
  final MuscleGroups? selectedMuscle;
  final double animationValue;
  final double pulseValue;
  final bool isBackView;
  final Set<MuscleGroups> completedMuscles;

  HexagonalGridPainter({
    this.hoveredMuscle,
    this.selectedMuscle,
    required this.animationValue,
    required this.pulseValue,
    this.isBackView = false,
    required this.completedMuscles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final hexagonRadius = size.width * 0.05;
    
    // Draw scanning line effect
    final scanLineY = size.height * animationValue;
    final scanLinePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF009688).withOpacity(0.0), // Teal fade in
          const Color(0xFF009688).withOpacity(0.5), // Teal peak
          const Color(0xFF009688).withOpacity(0.0), // Teal fade out
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, scanLineY - 10, size.width, 20))
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    
    canvas.drawLine(
      Offset(0, scanLineY),
      Offset(size.width, scanLineY),
      scanLinePaint,
    );

    // Draw grid with enhanced effects
    void drawHexagon(Offset center, MuscleGroups? muscleGroup, {bool isDecorative = false}) {
      final path = _createHexagonPath(center, hexagonRadius);
      
      // Determine the fill color and effects
      final Paint fillPaint = Paint();
      final Paint strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      if (isDecorative) {
        // Decorative elements (like head) get a subtle professional look
        fillPaint.color = const Color(0xFF1A237E).withOpacity(0.3);
        strokePaint.color = const Color(0xFF009688).withOpacity(0.2);
      } else if (muscleGroup != null) {
        final bool isHovered = muscleGroup == hoveredMuscle;
        final bool isSelected = muscleGroup == selectedMuscle;
        final bool isCompleted = completedMuscles.contains(muscleGroup);
        
        // Base color with professional effects
        fillPaint.color = muscleGroup.getDisplayColor(
          isCompleted: isCompleted,
          isHovered: isHovered,
          opacity: isSelected ? 0.8 : 0.6,
        );

        // Glow effect for interactive states
        if (isHovered || isSelected) {
          canvas.drawPath(
            path,
            Paint()
              ..color = const Color(0xFF009688).withOpacity(0.3)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
          );
        }

        // Pulse effect for completed muscles
        if (isCompleted) {
          canvas.drawPath(
            path,
            Paint()
              ..color = const Color(0xFF2E7D32).withOpacity(0.2 * pulseValue)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
          );
        }

        strokePaint.color = isHovered 
            ? const Color(0xFF009688).withOpacity(0.8)
            : const Color(0xFF009688).withOpacity(0.3);
      }

      // Draw the hexagon with professional effects
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    }

    // Draw all hexagons
    if (!isBackView) {
      // Draw front view
      decorativeElements.forEach((element, positions) {
        for (final position in positions) {
          drawHexagon(
            Offset(position.dx * size.width, position.dy * size.height),
            null,
            isDecorative: true,
          );
        }
      });

      muscleGridPositions.forEach((muscle, positions) {
        for (final position in positions) {
          drawHexagon(
            Offset(position.dx * size.width, position.dy * size.height),
            muscle,
          );
        }
      });
    } else {
      // Draw back view with similar effects
      backMuscleGridPositions.forEach((muscle, positions) {
        for (final position in positions) {
          drawHexagon(
            Offset(position.dx * size.width, position.dy * size.height),
            muscle,
          );
        }
      });
    }
  }

  Path _createHexagonPath(Offset center, double radius) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (60 * i - 30) * math.pi / 180;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
