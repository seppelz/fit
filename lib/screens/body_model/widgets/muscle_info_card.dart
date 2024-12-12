import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/muscle_group_model.dart';
import '../../../providers/muscle_group_provider.dart';

class MuscleInfoCard extends StatelessWidget {
  final MuscleGroups muscleGroup;

  const MuscleInfoCard({
    Key? key,
    required this.muscleGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  muscleGroup.displayName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Provider.of<MuscleGroupProvider>(context, listen: false)
                        .clearSelection();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              muscleGroup.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Related Exercises:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: muscleGroup.relatedExercises
                  .map((exercise) => Chip(label: Text(exercise)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
