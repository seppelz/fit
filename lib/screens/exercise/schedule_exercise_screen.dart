import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/exercise_model.dart';
import '../../providers/user_provider.dart';
import '../../services/exercise_service.dart';

class ScheduleExerciseScreen extends StatefulWidget {
  final Exercise exercise;

  const ScheduleExerciseScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<ScheduleExerciseScreen> createState() => _ScheduleExerciseScreenState();
}

class _ScheduleExerciseScreenState extends State<ScheduleExerciseScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Exercise'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Exercise info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.exercise.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.exercise.duration} minutes • ${widget.exercise.difficulty}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Date selection
          const Text(
            'Select Date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
              ),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 24),

          // Time selection
          const Text(
            'Select Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(
                '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
              ),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (picked != null) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 24),

          // Quick time suggestions
          Wrap(
            spacing: 8,
            children: [
              _buildQuickTimeChip('In 30m', Duration(minutes: 30)),
              _buildQuickTimeChip('In 1h', Duration(hours: 1)),
              _buildQuickTimeChip('In 2h', Duration(hours: 2)),
              _buildQuickTimeChip('After lunch', Duration(hours: 4)),
              _buildQuickTimeChip('End of day', Duration(hours: 8)),
            ],
          ),
          const SizedBox(height: 32),

          // Schedule button
          FilledButton(
            onPressed: _isLoading ? null : _scheduleExercise,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Schedule Exercise'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTimeChip(String label, Duration duration) {
    final suggestedTime = TimeOfDay.fromDateTime(
      DateTime.now().add(duration),
    );

    return ActionChip(
      label: Text(label),
      onPressed: () {
        setState(() {
          _selectedTime = suggestedTime;
          _selectedDate = DateTime.now();
        });
      },
    );
  }

  Future<void> _scheduleExercise() async {
    setState(() => _isLoading = true);

    try {
      final user = context.read<UserProvider>().user;
      if (user == null) throw Exception('User not found');

      final exerciseService = ExerciseService();
      final scheduledDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await exerciseService.scheduleExercise(
        userId: user.id,
        exerciseId: widget.exercise.id,
        scheduledFor: scheduledDateTime,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercise scheduled successfully')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scheduling exercise: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
