import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/muscle_group_model.dart';
import '../../../providers/muscle_group_provider.dart';
import '../painters/hexagonal_grid_painter.dart';
import 'dart:math' as math;

class HolographicBodyModel extends StatefulWidget {
  final Function(MuscleGroups)? onMuscleSelected;
  final Function(MuscleGroups)? onMuscleHover;
  final Set<MuscleGroups> completedMuscles;

  const HolographicBodyModel({
    super.key,
    this.onMuscleSelected,
    this.onMuscleHover,
    this.completedMuscles = const {},
  });

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
  double _rotationAngle = 0;

  @override
  void initState() {
    super.initState();
    
    // Scanning line animation
    _scanLineController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Pulse animation with easing
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Smooth rotation animation
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _rotationAnimation = CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOutCubic,
    );

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

  void _handleHover(PointerEvent details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final position = box.globalToLocal(details.position);
    final Size size = box.size;
    
    final MuscleGroups? muscle = _getMuscleAtPosition(position, size);
    
    if (muscle != null) {
      // Show tooltip with muscle name and exercise count
      final Offset tooltipPosition = details.position;
      OverlayEntry? overlayEntry;
      
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: tooltipPosition.dy - 60,
          left: tooltipPosition.dx,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                overlayEntry?.remove();
                if (widget.onMuscleSelected != null) {
                  widget.onMuscleSelected!(muscle);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      muscle.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.completedMuscles.contains(muscle)
                          ? 'Completed for today'
                          : 'Tap to start exercise',
                      style: TextStyle(
                        color: widget.completedMuscles.contains(muscle)
                            ? Colors.green[300]
                            : Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      Overlay.of(context).insert(overlayEntry);
      Future.delayed(const Duration(milliseconds: 1500), () {
        overlayEntry?.remove();
      });
      
      // Since we're inside the null check, muscle is guaranteed to be non-null here
      if (widget.onMuscleHover != null) {
        widget.onMuscleHover!(muscle); // Now muscle is treated as non-null
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MuscleGroupProvider>(
      builder: (context, muscleProvider, child) {
        return Stack(
          children: [
            GestureDetector(
              onDoubleTap: _rotateModel,
              child: MouseRegion(
                onHover: _handleHover,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: HexagonalGridPainter(
                    hoveredMuscle: _hoveredMuscle,
                    selectedMuscle: muscleProvider.selectedGroup,
                    animationValue: _scanLineController.value,
                    pulseValue: _pulseController.value,
                    isBackView: _isBackView,
                    completedMuscles: widget.completedMuscles,
                  ),
                ),
              ),
            ),
            // Rotation instruction tooltip with frosted glass effect
            Positioned(
              top: 16,
              right: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A237E).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF009688).withOpacity(0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF009688).withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: const Color(0xFF009688).withOpacity(0.8),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Double tap to rotate',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
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
