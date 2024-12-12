import 'package:flutter/material.dart';
import '../../models/muscle_group_model.dart';

class MuscleHighlightPainter extends CustomPainter {
  final MuscleGroups? hoveredMuscle;
  final MuscleGroups? selectedMuscle;
  final ThemeData theme;

  MuscleHighlightPainter({
    this.hoveredMuscle,
    this.selectedMuscle,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (hoveredMuscle == null && selectedMuscle == null) return;

    // Create highlight effects
    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader = LinearGradient(
        colors: [
          theme.primaryColor.withOpacity(0.8),
          theme.primaryColor.withOpacity(0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 5);

    // Draw data points and connection lines
    final dataPoints = _generateDataPoints(size);
    final connectionPaint = Paint()
      ..color = theme.primaryColor.withOpacity(0.2)
      ..strokeWidth = 0.5;

    for (var i = 0; i < dataPoints.length - 1; i++) {
      canvas.drawLine(dataPoints[i], dataPoints[i + 1], connectionPaint);
    }

    // Draw highlight circles at data points
    final circlePaint = Paint()
      ..color = theme.primaryColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (var point in dataPoints) {
      canvas.drawCircle(point, 2, circlePaint);
    }

    // Add scanning effect
    final scanPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.primaryColor.withOpacity(0),
          theme.primaryColor.withOpacity(0.2),
          theme.primaryColor.withOpacity(0),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      scanPaint,
    );
  }

  List<Offset> _generateDataPoints(Size size) {
    final points = <Offset>[];
    final random = DateTime.now().millisecondsSinceEpoch;
    
    for (var i = 0; i < 10; i++) {
      points.add(
        Offset(
          (random + i * 50) % size.width,
          (random + i * 70) % size.height,
        ),
      );
    }
    
    return points;
  }

  @override
  bool shouldRepaint(MuscleHighlightPainter oldDelegate) {
    return oldDelegate.hoveredMuscle != hoveredMuscle ||
           oldDelegate.selectedMuscle != selectedMuscle ||
           oldDelegate.theme != theme;
  }
}
