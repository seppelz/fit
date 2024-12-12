import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../models/muscle_group_model.dart';
import '../../providers/muscle_development_provider.dart';

const String humanBodyPath = "M104.265,117.959c-0.304,3.58,2.126,22.529,3.38,29.959c0.597,3.52,2.234,9.255,1.645,12.3 c-0.841,4.244-1.084,9.736-0.621,12.934c0.292,1.942,1.211,10.899-0.104,14.175c-0.688,1.718-1.949,10.522-1.949,10.522 c-3.285,8.294-1.431,7.886-1.431,7.886c1.017,1.248,2.759,0.098,2.759,0.098c1.327,0.846,2.246-0.201,2.246-0.201 c1.139,0.943,2.467-0.116,2.467-0.116c1.431,0.743,2.758-0.627,2.758-0.627c0.822,0.414,1.023-0.109,1.023-0.109 c2.466-0.158-1.376-8.05-1.376-8.05c-0.92-7.088,0.913-11.033,0.913-11.033c6.004-17.805,6.309-22.53,3.909-29.24 c-0.676-1.937-0.847-2.704-0.536-3.545c0.719-1.941,0.195-9.748,1.072-12.848c1.692-5.979,3.361-21.142,4.231-28.217 c1.169-9.53-4.141-22.308-4.141-22.308c-1.163-5.2,0.542-23.727,0.542-23.727c2.381,3.705,2.29,10.245,2.29,10.245 c-0.378,6.859,5.541,17.342,5.541,17.342c2.844,4.332,3.921,8.442,3.921,8.747c0,1.248-0.273,4.269-0.273,4.269l0.109,2.631 c0.049,0.67,0.426,2.977,0.365,4.092c-0.444,6.862,0.646,5.571,0.646,5.571c0.92,0,1.931-5.522,1.931-5.522 c0,1.424-0.348,5.687,0.42,7.295c0.919,1.918,1.595-0.329,1.607-0.78c0.243-8.737,0.768-6.448,0.768-6.448 c0.511,7.088,1.139,8.689,2.265,8.135c0.853-0.407,0.073-8.506,0.073-8.506c1.461,4.811,2.569,5.577,2.569,5.577 c2.411,1.693,0.92-2.983,0.585-3.909c-1.784-4.92-1.839-6.625-1.839-6.625c2.229,4.421,3.909,4.257,3.909,4.257 c2.174-0.694-1.9-6.954-4.287-9.953c-1.218-1.528-2.789-3.574-3.245-4.789c-0.743-2.058-1.304-8.674-1.304-8.674 c-0.225-7.807-2.155-11.198-2.155-11.198c-3.3-5.282-3.921-15.135-3.921-15.135l-0.146-16.635 c-1.157-11.347-9.518-11.429-9.518-11.429c-8.451-1.258-9.627-3.988-9.627-3.988c-1.79-2.576-0.767-7.514-0.767-7.514 c1.485-1.208,2.058-4.415,2.058-4.415c2.466-1.891,2.345-4.658,1.206-4.628c-0.914,0.024-0.707-0.733-0.707-0.733 C115.068,0.636,104.01,0,104.01,0h-1.688c0,0-11.063,0.636-9.523,13.089c0,0,0.207,0.758-0.715,0.733 c-1.136-0.03-1.242,2.737,1.215,4.628c0,0,0.572,3.206,2.058,4.415c0,0,1.023,4.938-0.767,7.514c0,0-1.172,2.73-9.627,3.988 c0,0-8.375,0.082-9.514,11.429l-0.158,16.635c0,0-0.609,9.853-3.922,15.135c0,0-1.921,3.392-2.143,11.198 c0,0-0.563,6.616-1.303,8.674c-0.451,1.209-2.021,3.255-3.249,4.789c-2.408,2.993-6.455,9.24-4.29,9.953 c0,0,1.689,0.164,3.909-4.257c0,0-0.046,1.693-1.827,6.625c-0.35,0.914-1.839,5.59,0.573,3.909c0,0,1.117,0.767,2.569-5.577 c0,0-0.779,8.099,0.088,8.506c1.133,0.555,1.751-1.047,2.262-8.135c0,0,0.524-2.289,0.767,6.448 c0.012,0.451,0.673,2.698,1.596,0.78c0.779-1.608,0.429-5.864,0.429-7.295c0,0,0.999,5.522,1.933,5.522 c0,0,1.099,1.291,0.648-5.571c-0.073-1.121,0.32-3.422,0.369-4.092l0.106-2.631c0,0-0.274-3.014-0.274-4.269 c0-0.311,1.078-4.415,3.921-8.747c0,0,5.913-10.488,5.532-17.342c0,0-0.082-6.54,2.299-10.245c0,0,1.69,18.526,0.545,23.727 c0,0-5.319,12.778-4.146,22.308c0.864,7.094,2.53,22.237,4.226,28.217c0.886,3.094,0.362,10.899,1.072,12.848 c0.32,0.847,0.152,1.627-0.536,3.545c-2.387,6.71-2.083,11.436,3.921,29.24c0,0,1.848,3.945,0.914,11.033 c0,0-3.836,7.892-1.379,8.05c0,0,0.192,0.523,1.023,0.109c0,0,1.327,1.37,2.761,0.627c0,0,1.328,1.06,2.463,0.116 c0,0,0.91,1.047,2.237,0.201c0,0,1.742,1.175,2.777-0.098c0,0,1.839,0.408-1.435-7.886c0,0-1.254-8.793-1.945-10.522 c-1.318-3.275-0.387-12.251-0.106-14.175c0.453-3.216,0.21-8.695-0.618-12.934c-0.606-3.038,1.035-8.774,1.641-12.3 c1.245-7.423,3.685-26.373,3.38-29.959l1.008,0.354C103.809,118.312,104.265,117.959,104.265,117.959z";

class BodyModelSvg extends StatefulWidget {
  final MuscleGroups? selectedMuscle;
  final MuscleGroups? hoveredMuscle;
  final MuscleDevelopmentProvider muscleDevelopment;
  final Function(MuscleGroups?) onMuscleSelected;
  final Function(MuscleGroups?) onMuscleHover;

  const BodyModelSvg({
    Key? key,
    required this.selectedMuscle,
    required this.hoveredMuscle,
    required this.muscleDevelopment,
    required this.onMuscleSelected,
    required this.onMuscleHover,
  }) : super(key: key);

  @override
  State<BodyModelSvg> createState() => _BodyModelSvgState();
}

class _BodyModelSvgState extends State<BodyModelSvg> {
  final Map<String, MuscleGroups> _muscleIdMap = {
    'neck': MuscleGroups.neck,
    'shoulders': MuscleGroups.shoulders,
    'arms': MuscleGroups.arms,
    'chest': MuscleGroups.chest,
    'core': MuscleGroups.core,
    'legs': MuscleGroups.legs,
  };

  void _handleTapUp(TapUpDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final position = box.globalToLocal(details.globalPosition);
    final Size size = box.size;
    
    final muscle = _getMuscleAtPoint(position, size);
    widget.onMuscleSelected(muscle);
  }

  void _handleHover(PointerEvent details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final position = box.globalToLocal(details.position);
    final Size size = box.size;
    
    final muscle = _getMuscleAtPoint(position, size);
    widget.onMuscleHover(muscle);
  }

  MuscleGroups? _getMuscleAtPoint(Offset position, Size size) {
    final x = position.dx / size.width;
    final y = position.dy / size.height;

    if (y < 0.15) return MuscleGroups.neck;
    if (y < 0.25) return MuscleGroups.shoulders;
    if (y < 0.4) {
      if (x < 0.4 || x > 0.6) return MuscleGroups.arms;
      return MuscleGroups.chest;
    }
    if (y < 0.6) return MuscleGroups.core;
    return MuscleGroups.legs;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _handleHover,
      onExit: (_) => widget.onMuscleHover(null),
      child: GestureDetector(
        onTapUp: _handleTapUp,
        child: CustomPaint(
          painter: BodyModelPainter(
            selectedMuscle: widget.selectedMuscle,
            hoveredMuscle: widget.hoveredMuscle,
            muscleDevelopment: widget.muscleDevelopment,
          ),
          child: Container(),
        ),
      ),
    );
  }
}

class BodyModelPainter extends CustomPainter {
  final MuscleGroups? selectedMuscle;
  final MuscleGroups? hoveredMuscle;
  final MuscleDevelopmentProvider muscleDevelopment;

  BodyModelPainter({
    required this.selectedMuscle,
    required this.hoveredMuscle,
    required this.muscleDevelopment,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Base paint for the body outline
    final basePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.cyan.withOpacity(0.1);

    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.cyan.withOpacity(0.8);

    // Draw holographic effect
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4.0)
      ..color = Colors.cyan.withOpacity(0.3);

    // Parse and scale the SVG path
    final path = parseSvgPath(humanBodyPath);
    final bounds = path.getBounds();
    final scaleX = size.width / bounds.width;
    final scaleY = size.height / bounds.height;
    final scale = scaleX < scaleY ? scaleX * 0.8 : scaleY * 0.8;
    
    final matrix = Matrix4.identity()
      ..translate(size.width / 2, size.height / 2)
      ..scale(scale, scale)
      ..translate(-bounds.center.dx, -bounds.center.dy);
    
    final transformedPath = path.transform(matrix.storage);

    // Draw base body with fill
    canvas.drawPath(transformedPath, basePaint);
    
    // Draw outline with glow
    canvas.drawPath(transformedPath, glowPaint);
    canvas.drawPath(transformedPath, outlinePaint);

    // Draw scan lines
    final scanLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.cyan.withOpacity(0.1);

    for (var i = 0; i < size.height; i += 10) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        scanLinePaint,
      );
    }

    // Highlight selected and hovered muscles
    if (selectedMuscle != null || hoveredMuscle != null) {
      if (selectedMuscle != null) {
        final selectedPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.cyan.withOpacity(0.4);
        _drawMuscleHighlight(canvas, size, selectedMuscle!, selectedPaint);
      }

      if (hoveredMuscle != null && hoveredMuscle != selectedMuscle) {
        final hoverPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.cyan.withOpacity(0.2);
        _drawMuscleHighlight(canvas, size, hoveredMuscle!, hoverPaint);
      }
    }
  }

  void _drawMuscleHighlight(Canvas canvas, Size size, MuscleGroups muscle, Paint paint) {
    final path = Path();
    final highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = paint.color
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    switch (muscle) {
      case MuscleGroups.neck:
        path.addOval(Rect.fromLTWH(
          size.width * 0.4,
          size.height * 0.05,
          size.width * 0.2,
          size.height * 0.1,
        ));
        break;
      case MuscleGroups.shoulders:
        path.addOval(Rect.fromLTWH(
          size.width * 0.2,
          size.height * 0.15,
          size.width * 0.6,
          size.height * 0.1,
        ));
        break;
      case MuscleGroups.arms:
        // Left arm
        path.addOval(Rect.fromLTWH(
          size.width * 0.1,
          size.height * 0.25,
          size.width * 0.2,
          size.height * 0.3,
        ));
        // Right arm
        path.addOval(Rect.fromLTWH(
          size.width * 0.7,
          size.height * 0.25,
          size.width * 0.2,
          size.height * 0.3,
        ));
        break;
      case MuscleGroups.chest:
        path.addOval(Rect.fromLTWH(
          size.width * 0.3,
          size.height * 0.25,
          size.width * 0.4,
          size.height * 0.15,
        ));
        break;
      case MuscleGroups.core:
        path.addOval(Rect.fromLTWH(
          size.width * 0.3,
          size.height * 0.4,
          size.width * 0.4,
          size.height * 0.2,
        ));
        break;
      case MuscleGroups.legs:
        // Left leg
        path.addOval(Rect.fromLTWH(
          size.width * 0.25,
          size.height * 0.6,
          size.width * 0.2,
          size.height * 0.35,
        ));
        // Right leg
        path.addOval(Rect.fromLTWH(
          size.width * 0.55,
          size.height * 0.6,
          size.width * 0.2,
          size.height * 0.35,
        ));
        break;
    }
    canvas.drawPath(path, highlightPaint);
  }

  Path parseSvgPath(String svgPath) {
    final path = Path();
    final pathCommands = svgPath.split(RegExp(r'(?=[MmLlHhVvCcSsQqTtAaZz])'));
    
    double x = 0;
    double y = 0;
    
    for (final command in pathCommands) {
      if (command.isEmpty) continue;
      
      final type = command[0];
      final points = command.substring(1).trim().split(RegExp(r'[\s,]+'));
      
      switch (type) {
        case 'M':
          x = double.parse(points[0]);
          y = double.parse(points[1]);
          path.moveTo(x, y);
          break;
        case 'L':
          x = double.parse(points[0]);
          y = double.parse(points[1]);
          path.lineTo(x, y);
          break;
        case 'C':
          final x1 = double.parse(points[0]);
          final y1 = double.parse(points[1]);
          final x2 = double.parse(points[2]);
          final y2 = double.parse(points[3]);
          x = double.parse(points[4]);
          y = double.parse(points[5]);
          path.cubicTo(x1, y1, x2, y2, x, y);
          break;
        case 'Z':
          path.close();
          break;
      }
    }
    
    return path;
  }

  @override
  bool shouldRepaint(BodyModelPainter oldDelegate) {
    return oldDelegate.selectedMuscle != selectedMuscle ||
           oldDelegate.hoveredMuscle != hoveredMuscle;
  }
}
