import 'package:flutter/material.dart';
import '../../../models/muscle_group_model.dart';
import '../../../models/exercise_model.dart';

class MuscleInfoCard extends StatelessWidget {
  final MuscleGroups? selectedMuscle;
  final List<Exercise> availableExercises;
  final VoidCallback onStartExercise;
  final bool isCompleted;

  const MuscleInfoCard({
    super.key,
    required this.selectedMuscle,
    required this.availableExercises,
    required this.onStartExercise,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedMuscle == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedMuscle!.displayName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${availableExercises.length} exercises available',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (availableExercises.isNotEmpty) ...[
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: availableExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = availableExercises[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Tooltip(
                        message: exercise.name,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: Icon(
                            _getExerciseIcon(exercise.type),
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              onPressed: isCompleted ? null : onStartExercise,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: isCompleted ? Colors.grey[300] : Theme.of(context).primaryColor,
              ),
              icon: Icon(
                isCompleted ? Icons.check : Icons.fitness_center,
                color: isCompleted ? Colors.grey[600] : Colors.white,
              ),
              label: Text(
                isCompleted ? 'Completed for Today' : 'Start Exercise',
                style: TextStyle(
                  color: isCompleted ? Colors.grey[600] : Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getExerciseIcon(ExerciseType type) {
    switch (type) {
      case ExerciseType.stretching:
        return Icons.accessibility_new;
      case ExerciseType.strength:
        return Icons.fitness_center;
      case ExerciseType.cardio:
        return Icons.directions_run;
      default:
        return Icons.sports_gymnastics;
    }
  }
}
