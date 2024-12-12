import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/muscle_group_model.dart';
import '../../../providers/muscle_group_provider.dart';
import '../../../providers/muscle_development_provider.dart';
import '../painters/hexagonal_grid_painter.dart';

class InteractiveBodyModel extends StatefulWidget {
  const InteractiveBodyModel({Key? key}) : super(key: key);

  @override
  State<InteractiveBodyModel> createState() => _InteractiveBodyModelState();
}

class _InteractiveBodyModelState extends State<InteractiveBodyModel>
    with TickerProviderStateMixin {
  MuscleGroups? _hoveredMuscle;
  MuscleGroups? _selectedMuscle;
  late AnimationController _scanLineController;
  late AnimationController _pulseController;

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
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  MuscleGroups? _getMuscleAtPosition(Offset position, Size size) {
    final relativePosition = Offset(
      position.dx / size.width,
      position.dy / size.height,
    );

    // Find the closest muscle group based on the hexagon positions
    double minDistance = double.infinity;
    MuscleGroups? closestMuscle;

    for (var entry in HexagonalGridPainter.muscleGridPositions.entries) {
      for (var hexCenter in entry.value) {
        final distance = (hexCenter - relativePosition).distance;
        if (distance < minDistance && distance < 0.1) {  // Adjust threshold as needed
          minDistance = distance;
          closestMuscle = entry.key;
        }
      }
    }

    return closestMuscle;
  }

  void _handleMuscleHover(MuscleGroups? muscle) {
    setState(() {
      _hoveredMuscle = muscle;
    });
  }

  void _handleMuscleSelect(MuscleGroups? muscle) {
    setState(() {
      _selectedMuscle = muscle;
    });
    if (muscle != null) {
      Provider.of<MuscleGroupProvider>(context, listen: false)
          .setSelectedGroup(muscle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MuscleDevelopmentProvider, MuscleGroupProvider>(
      builder: (context, muscleDevelopment, muscleProvider, child) {
        return MouseRegion(
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
            child: AnimatedBuilder(
              animation: Listenable.merge([_scanLineController, _pulseController]),
              builder: (context, child) {
                return Stack(
                  children: [
                    CustomPaint(
                      painter: HexagonalGridPainter(
                        hoveredMuscle: _hoveredMuscle,
                        selectedMuscle: muscleProvider.selectedGroup,
                        animationValue: _scanLineController.value,
                        pulseValue: _pulseController.value,
                      ),
                      child: Container(),
                    ),
                    if (_hoveredMuscle != null || _selectedMuscle != null)
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.cyan.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_selectedMuscle != null)
                                Text(
                                  'Selected: ${_selectedMuscle.toString().split('.').last}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              if (_hoveredMuscle != null)
                                Text(
                                  'Hovered: ${_hoveredMuscle.toString().split('.').last}',
                                  style: const TextStyle(
                                    color: Colors.white70,
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
            ),
          ),
        );
      },
    );
  }
}
