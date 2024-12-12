import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/user_service.dart';

class ExercisePreferencesScreen extends StatefulWidget {
  const ExercisePreferencesScreen({super.key});

  @override
  State<ExercisePreferencesScreen> createState() =>
      _ExercisePreferencesScreenState();
}

class _ExercisePreferencesScreenState extends State<ExercisePreferencesScreen> {
  String _selectedDifficulty = 'Medium';
  int _exerciseDuration = 10;
  List<String> _selectedCategories = [];
  bool _enableReminders = true;
  int _remindersPerDay = 3;
  bool _isLoading = false;

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];
  final List<String> _categories = [
    'Desk',
    'Standing',
    'Floor',
    'Stretching',
    'Cardio',
    'Strength',
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    _selectedDifficulty = user?.exercisePreferences?['difficulty'] ?? 'Medium';
    _exerciseDuration = user?.exercisePreferences?['duration'] ?? 10;
    _selectedCategories =
        List<String>.from(user?.exercisePreferences?['categories'] ?? []);
    _enableReminders = user?.exercisePreferences?['enableReminders'] ?? true;
    _remindersPerDay = user?.exercisePreferences?['remindersPerDay'] ?? 3;
  }

  Future<void> _savePreferences() async {
    setState(() => _isLoading = true);

    try {
      final userProvider = context.read<UserProvider>();
      final userService = UserService();

      await userService.updateUser(userProvider.user!.id, {
        'exercisePreferences': {
          'difficulty': _selectedDifficulty,
          'duration': _exerciseDuration,
          'categories': _selectedCategories,
          'enableReminders': _enableReminders,
          'remindersPerDay': _remindersPerDay,
        },
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercise preferences updated')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating preferences: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Preferences'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Difficulty
          const Text(
            'Preferred Difficulty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: _difficulties
                .map((d) => ButtonSegment(value: d, label: Text(d)))
                .toList(),
            selected: {_selectedDifficulty},
            onSelectionChanged: (Set<String> selected) {
              setState(() {
                _selectedDifficulty = selected.first;
              });
            },
          ),
          const SizedBox(height: 24),

          // Exercise Duration
          const Text(
            'Exercise Duration',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _exerciseDuration.toDouble(),
                  min: 5,
                  max: 30,
                  divisions: 5,
                  label: '$_exerciseDuration minutes',
                  onChanged: (value) {
                    setState(() {
                      _exerciseDuration = value.round();
                    });
                  },
                ),
              ),
              Text(
                '$_exerciseDuration min',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Exercise Categories
          const Text(
            'Preferred Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _categories.map((category) {
              return FilterChip(
                selected: _selectedCategories.contains(category),
                label: Text(category),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedCategories.add(category);
                    } else {
                      _selectedCategories.remove(category);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Reminders
          const Text(
            'Exercise Reminders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Enable Reminders'),
            value: _enableReminders,
            onChanged: (value) {
              setState(() {
                _enableReminders = value;
              });
            },
          ),
          if (_enableReminders) ...[
            ListTile(
              title: const Text('Reminders per Day'),
              trailing: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 2, label: Text('2')),
                  ButtonSegment(value: 3, label: Text('3')),
                  ButtonSegment(value: 4, label: Text('4')),
                  ButtonSegment(value: 5, label: Text('5')),
                ],
                selected: {_remindersPerDay},
                onSelectionChanged: (Set<int> selected) {
                  setState(() {
                    _remindersPerDay = selected.first;
                  });
                },
              ),
            ),
          ],
          const SizedBox(height: 32),

          FilledButton(
            onPressed: _isLoading ? null : _savePreferences,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Save Preferences'),
          ),
        ],
      ),
    );
  }
}
