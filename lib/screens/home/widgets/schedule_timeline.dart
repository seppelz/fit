import 'package:flutter/material.dart';
import '../../../models/exercise_model.dart';

class ScheduleTimeline extends StatelessWidget {
  final DateTime date;
  final List<Map<String, dynamic>> schedules;

  const ScheduleTimeline({
    super.key,
    required this.date,
    required this.schedules,
  });

  @override
  Widget build(BuildContext context) {
    // Sort schedules by time
    final sortedSchedules = List<Map<String, dynamic>>.from(schedules)
      ..sort((a, b) {
        final TimeOfDay timeA = a['time'] as TimeOfDay;
        final TimeOfDay timeB = b['time'] as TimeOfDay;
        return timeA.hour * 60 + timeA.minute - (timeB.hour * 60 + timeB.minute);
      });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedSchedules.length,
      itemBuilder: (context, index) {
        final schedule = sortedSchedules[index];
        final TimeOfDay time = schedule['time'] as TimeOfDay;
        final Exercise exercise = schedule['exercise'] as Exercise;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Time column
              SizedBox(
                width: 56,
                child: Column(
                  children: [
                    Text(
                      _formatTime(time),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Timeline
              Column(
                children: [
                  Container(
                    width: 2,
                    height: 140,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                ],
              ),

              // Exercise card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        // TODO: Show exercise details or edit schedule
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.fitness_center,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    exercise.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _buildDifficultyChip(context, exercise.difficulty),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              exercise.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildStat(
                                  context,
                                  Icons.timer_outlined,
                                  '${exercise.duration} min',
                                ),
                                const SizedBox(width: 16),
                                _buildStat(
                                  context,
                                  Icons.local_fire_department_outlined,
                                  '${exercise.caloriesBurn} cal',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildDifficultyChip(BuildContext context, String difficulty) {
    Color color;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        color = Colors.green;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'hard':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
