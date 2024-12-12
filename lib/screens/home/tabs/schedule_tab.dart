import 'package:flutter/material.dart';
import '../widgets/schedule_timeline.dart';
import '../../../models/exercise_model.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({super.key});

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Week view
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final isSelected = date.day == _selectedDate.day;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildDateCard(date, isSelected),
                );
              },
            ),
          ),

          // Schedule timeline
          Expanded(
            child: ScheduleTimeline(
              date: _selectedDate,
              schedules: _getDummySchedules(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new scheduled exercise
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDateCard(DateTime date, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        width: 56,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getWeekdayShort(date.weekday),
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekdayShort(int weekday) {
    switch (weekday) {
      case 1:
        return 'MON';
      case 2:
        return 'TUE';
      case 3:
        return 'WED';
      case 4:
        return 'THU';
      case 5:
        return 'FRI';
      case 6:
        return 'SAT';
      case 7:
        return 'SUN';
      default:
        return '';
    }
  }

  // Temporary dummy data
  List<Map<String, dynamic>> _getDummySchedules() {
    return [
      {
        'time': const TimeOfDay(hour: 9, minute: 0),
        'exercise': Exercise(
          id: '1',
          name: 'Morning Stretches',
          description: 'Start your day with simple stretches',
          duration: 5,
          difficulty: 'Easy',
          category: 'Stretching',
          imageUrl: '',
          caloriesBurn: 20,
        ),
      },
      {
        'time': const TimeOfDay(hour: 12, minute: 30),
        'exercise': Exercise(
          id: '2',
          name: 'Lunch Break Workout',
          description: 'Quick workout during lunch',
          duration: 10,
          difficulty: 'Medium',
          category: 'Standing',
          imageUrl: '',
          caloriesBurn: 45,
        ),
      },
      {
        'time': const TimeOfDay(hour: 15, minute: 0),
        'exercise': Exercise(
          id: '3',
          name: 'Afternoon Energizer',
          description: 'Combat afternoon slump with exercises',
          duration: 5,
          difficulty: 'Easy',
          category: 'Desk',
          imageUrl: '',
          caloriesBurn: 25,
        ),
      },
    ];
  }
}
