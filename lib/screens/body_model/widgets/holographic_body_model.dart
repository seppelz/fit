import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../../models/muscle_group_model.dart';
import '../../../providers/muscle_group_provider.dart';
import '../../../providers/user_provider.dart';
import '../painters/hexagonal_grid_painter.dart';
import 'dart:math' as math;
import '../../../services/exercise_service.dart';
import '../../../screens/exercise/exercise_detail_screen.dart';

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
                _handleTap(context, muscle);
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

  void _handleTap(BuildContext context, MuscleGroups muscle) async {
    // Get exercise service instance
    final exerciseService = ExerciseService();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // First get all exercises to see what's available
      final allExercises = await exerciseService.getExercises();
      debugPrint('All exercises: ${allExercises.map((e) => '${e.name} (${e.targetMuscleGroup})').toList()}');

      // Get exercises for selected muscle group
      final exercises = await exerciseService.getLeastShownExercises(
        userId: user.id,
        muscleGroup: muscle.germanName,
        limit: 1, // Get just one exercise
      );

      if (!context.mounted) return;

      if (exercises.isNotEmpty) {
        // Navigate to exercise detail screen with the selected exercise
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseDetailScreen(
              exercise: exercises.first,
            ),
          ),
        );
      } else {
        // Show error if no exercises found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No exercises found for this muscle group'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MuscleGroupProvider>(
      builder: (context, muscleGroupProvider, child) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final position = box.globalToLocal(details.globalPosition);
            final Size size = box.size;
            
            final MuscleGroups? muscle = _getMuscleAtPosition(position, size);
            if (muscle != null) {
              _handleTap(context, muscle);
            }
          },
          child: MouseRegion(
            onHover: _handleHover,
            child: CustomPaint(
              painter: HexagonalGridPainter(
                hoveredMuscle: _hoveredMuscle,
                selectedMuscle: muscleGroupProvider.selectedGroup,
                animationValue: _scanLineController.value,
                pulseValue: _pulseController.value,
                isBackView: _isBackView,
                completedMuscles: widget.completedMuscles,
              ),
              child: Stack(
                children: [
                  // Rotate button
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      onPressed: _rotateModel,
                      backgroundColor: Colors.black87,
                      child: const Icon(Icons.rotate_right, color: Color(0xFF00FF88)),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
