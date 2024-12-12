import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/muscle_group_model.dart';
import '../../../providers/muscle_group_provider.dart';
import '../painters/hexagonal_grid_painter.dart';
import 'dart:math' as math;

class HolographicBodyModel extends StatefulWidget {
  const HolographicBodyModel({Key? key}) : super(key: key);

  @override
  State<HolographicBodyModel> createState() => _HolographicBodyModelState();
}

class _HolographicBodyModelState extends State<HolographicBodyModel>
    with TickerProviderStateMixin {
  MuscleGroups? _hoveredMuscle;
  bool _isBackView = false;
  late AnimationController _scanLineController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOutBack,
    ));

    _rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isBackView = !_isBackView;
          _rotationController.reset();
        });
      }
    });
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _rotateModel() {
    _rotationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MuscleGroupProvider>(
      builder: (context, muscleProvider, child) {
        return Stack(
          children: [
            // Main body model with rotation
            GestureDetector(
              onDoubleTap: _rotateModel,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _scanLineController,
                  _pulseController,
                  _rotationController,
                ]),
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // perspective
                      ..rotateY(_rotationAnimation.value),
                    child: MouseRegion(
                      onHover: (event) {
                        final RenderBox box = context.findRenderObject() as RenderBox;
                        final position = box.globalToLocal(event.position);
                        final muscle = _getMuscleAtPosition(position, box.size);
                        setState(() => _hoveredMuscle = muscle);
                      },
                      onExit: (_) => setState(() => _hoveredMuscle = null),
                      child: GestureDetector(
                        onTapUp: (details) {
                          final RenderBox box = context.findRenderObject() as RenderBox;
                          final position = box.globalToLocal(details.globalPosition);
                          final muscle = _getMuscleAtPosition(position, box.size);
                          if (muscle != null) {
                            muscleProvider.setSelectedGroup(muscle);
                          }
                        },
                        child: CustomPaint(
                          painter: HexagonalGridPainter(
                            hoveredMuscle: _hoveredMuscle,
                            selectedMuscle: muscleProvider.selectedGroup,
                            animationValue: _scanLineController.value,
                            pulseValue: _pulseController.value,
                            isBackView: _isBackView,
                          ),
                          child: Container(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Rotation instruction tooltip
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.cyan.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Colors.cyan.withOpacity(0.8),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Double tap to rotate',
                      style: TextStyle(
                        color: Colors.cyan.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  MuscleGroups? _getMuscleAtPosition(Offset position, Size size) {
    final relativePosition = Offset(
      position.dx / size.width,
      position.dy / size.height,
    );

    final positions = _isBackView
        ? HexagonalGridPainter.backMuscleGridPositions
        : HexagonalGridPainter.muscleGridPositions;

    // Find the closest muscle group based on the hexagon positions
    double minDistance = double.infinity;
    MuscleGroups? closestMuscle;

    for (var entry in positions.entries) {
      for (var hexCenter in entry.value) {
        final distance = (hexCenter - relativePosition).distance;
        if (distance < minDistance && distance < 0.1) {
          minDistance = distance;
          closestMuscle = entry.key;
        }
      }
    }

    return closestMuscle;
  }
}
