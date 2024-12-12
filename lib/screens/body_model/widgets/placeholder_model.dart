import 'package:flutter/material.dart';

class PlaceholderModel extends StatelessWidget {
  final bool isAutoRotating;
  final VoidCallback? onTap;

  const PlaceholderModel({
    super.key,
    this.isAutoRotating = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: HumanOutlinePainter(
          color: Theme.of(context).colorScheme.primary,
        ),
        size: const Size(300, 400),
      ),
    );
  }
}

class HumanOutlinePainter extends CustomPainter {
  final Color color;

  HumanOutlinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final width = size.width;
    final height = size.height;

    // Head
    canvas.drawCircle(
      Offset(width / 2, height * 0.1),
      width * 0.1,
      paint,
    );

    // Body
    final bodyPath = Path()
      ..moveTo(width * 0.4, height * 0.2)
      ..lineTo(width * 0.6, height * 0.2)
      ..lineTo(width * 0.6, height * 0.5)
      ..lineTo(width * 0.4, height * 0.5)
      ..close();
    canvas.drawPath(bodyPath, paint);

    // Arms
    canvas.drawLine(
      Offset(width * 0.2, height * 0.3),
      Offset(width * 0.4, height * 0.25),
      paint,
    );
    canvas.drawLine(
      Offset(width * 0.6, height * 0.25),
      Offset(width * 0.8, height * 0.3),
      paint,
    );

    // Legs
    canvas.drawLine(
      Offset(width * 0.4, height * 0.5),
      Offset(width * 0.3, height * 0.9),
      paint,
    );
    canvas.drawLine(
      Offset(width * 0.6, height * 0.5),
      Offset(width * 0.7, height * 0.9),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
