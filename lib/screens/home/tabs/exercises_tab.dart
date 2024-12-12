import 'package:flutter/material.dart';
import '../widgets/exercise_card.dart';
import '../../../models/exercise_model.dart';
import '../../body_model/body_model_screen.dart';

class ExercisesTab extends StatefulWidget {
  const ExercisesTab({super.key});

  @override
  State<ExercisesTab> createState() => _ExercisesTabState();
}

class _ExercisesTabState extends State<ExercisesTab> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Desk',
    'Standing',
    'Floor',
    'Stretching'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement exercise search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Categories horizontal list
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(category),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Exercise list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _getDummyExercises().length,
              itemBuilder: (context, index) {
                final exercise = _getDummyExercises()[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ExerciseCard(exercise: exercise),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'body_model',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BodyModelScreen(),
                ),
              );
            },
            child: const Icon(Icons.accessibility_new),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'quick_start',
            onPressed: () {
              // TODO: Start quick exercise
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Quick Start'),
          ),
        ],
      ),
    );
  }

  // Temporary dummy data
  List<Exercise> _getDummyExercises() {
    return [
      Exercise(
        id: '1',
        name: 'Desk Stretches',
        description: 'Simple stretches you can do at your desk',
        duration: 5,
        difficulty: 'Easy',
        category: 'Desk',
        imageUrl: '',
        caloriesBurn: 20,
      ),
      Exercise(
        id: '2',
        name: 'Standing Exercises',
        description: 'Quick exercises while standing',
        duration: 10,
        difficulty: 'Medium',
        category: 'Standing',
        imageUrl: '',
        caloriesBurn: 45,
      ),
      Exercise(
        id: '3',
        name: 'Floor Workout',
        description: 'Comprehensive floor exercises',
        duration: 15,
        difficulty: 'Hard',
        category: 'Floor',
        imageUrl: '',
        caloriesBurn: 100,
      ),
    ];
  }
}
