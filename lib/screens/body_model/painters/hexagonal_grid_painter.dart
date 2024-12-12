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

  HexagonalGridPainter({
    this.hoveredMuscle,
    this.selectedMuscle,
    required this.animationValue,
    required this.pulseValue,
    this.isBackView = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final hexagonRadius = size.width * 0.03;
    
    // Draw background gradient
    final backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black,
        Colors.blue.withOpacity(0.2),
        Colors.black,
      ],
    );
    
    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = backgroundGradient.createShader(Offset.zero & size),
    );

    // Draw scanning line effect
    final scanLineY = size.height * animationValue;
    canvas.drawLine(
      Offset(0, scanLineY),
      Offset(size.width, scanLineY),
      Paint()
        ..color = Colors.cyan.withOpacity(0.5)
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Draw decorative elements (head hexagon) in both views
    decorativeElements.forEach((element, positions) {
      for (final position in positions) {
        final center = Offset(
          position.dx * size.width,
          position.dy * size.height,
        );

        // Draw head hexagon with a dimmer color
        final hexagonPath = _createHexagonPath(center, hexagonRadius);
        final hexagonPaint = Paint()
          ..color = Colors.grey.withOpacity(0.3)
          ..style = PaintingStyle.fill;

        canvas.drawPath(hexagonPath, hexagonPaint);

        // Draw border
        final borderPaint = Paint()
          ..color = Colors.grey.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

        canvas.drawPath(hexagonPath, borderPaint);
      }
    });

    // Draw muscle groups based on view
    final musclePositions = isBackView ? backMuscleGridPositions : muscleGridPositions;
    musclePositions.forEach((muscle, positions) {
      final isHovered = hoveredMuscle == muscle;
      final isSelected = selectedMuscle == muscle;
      final baseColor = muscleColors[muscle] ?? Colors.blue;
      
      for (final position in positions) {
        final center = Offset(
          position.dx * size.width,
          position.dy * size.height,
        );

        // Draw glow effect for hovered/selected hexagons
        if (isHovered || isSelected) {
          final glowPaint = Paint()
            ..color = baseColor.withOpacity(0.3 + 0.2 * pulseValue)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
          
          canvas.drawCircle(center, hexagonRadius * 1.5, glowPaint);
        }

        // Draw hexagon
        final hexagonPath = _createHexagonPath(center, hexagonRadius);
        final hexagonPaint = Paint()
          ..color = baseColor.withOpacity(isHovered || isSelected ? 0.8 : 0.5)
          ..style = PaintingStyle.fill;

        canvas.drawPath(hexagonPath, hexagonPaint);

        // Draw hexagon border
        final borderPaint = Paint()
          ..color = baseColor.withOpacity(0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

        canvas.drawPath(hexagonPath, borderPaint);
      }
    });
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
