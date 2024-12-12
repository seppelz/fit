import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/exercise_model.dart';
import '../../models/muscle_group_model.dart';
import '../../services/auth_service.dart';
import '../../services/exercise_service.dart';
import 'exercise_details_screen.dart';

class ExercisesByMuscleScreen extends StatefulWidget {
  final MuscleGroups muscleGroup;

  const ExercisesByMuscleScreen({
    super.key,
    required this.muscleGroup,
  });

  @override
  State<ExercisesByMuscleScreen> createState() => _ExercisesByMuscleScreenState();
}

class _ExercisesByMuscleScreenState extends State<ExercisesByMuscleScreen> {
  final _exerciseService = ExerciseService();
  List<Exercise> _exercises = [];
  bool _isLoading = true;
  String? _error;

  // Filter states
  bool _isSitting = true;
  bool _isTheraband = false;
  bool _isDynamic = true;
  bool _isOneSided = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = Provider.of<AuthService>(context, listen: false).currentUser?.id;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final exercises = await _exerciseService.getLeastShownExercises(
        userId: userId,
        muscleGroup: widget.muscleGroup.displayName,
        isSitting: _isSitting,
        isTheraband: _isTheraband,
        isDynamic: _isDynamic,
        isOneSided: _isOneSided,
      );

      setState(() {
        _exercises = exercises;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load exercises: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _onExerciseSelected(Exercise exercise) async {
    // Navigate to exercise details
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExerciseDetailsScreen(
          exercise: exercise,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.muscleGroup.displayName} Exercises'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadExercises,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_exercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No exercises found with current filters'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showFilterDialog(context),
              child: const Text('Change Filters'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _exercises.length,
      itemBuilder: (context, index) {
        final exercise = _exercises[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: widget.muscleGroup.baseColor.withOpacity(0.2),
              child: Icon(
                Icons.fitness_center,
                color: widget.muscleGroup.baseColor,
              ),
            ),
            title: Text(exercise.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${exercise.duration.inMinutes} min • ${exercise.type.name}',
                ),
                if (exercise.completedCount > 0 || exercise.cancelledCount > 0 || exercise.skippedCount > 0)
                  Text(
                    'Progress: ${exercise.completedCount} completed • ${exercise.cancelledCount} cancelled • ${exercise.skippedCount} skipped',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            isThreeLine: true,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _onExerciseSelected(exercise),
          ),
        );
      },
    );
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter Exercises'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Sitting Exercises'),
                    subtitle: const Text('Show exercises you can do while sitting'),
                    value: _isSitting,
                    onChanged: (value) {
                      setState(() => _isSitting = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Theraband Exercises'),
                    subtitle: const Text('Show exercises that use a theraband'),
                    value: _isTheraband,
                    onChanged: (value) {
                      setState(() => _isTheraband = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Dynamic Exercises'),
                    subtitle: const Text('Show exercises with movement'),
                    value: _isDynamic,
                    onChanged: (value) {
                      setState(() => _isDynamic = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('One-sided Exercises'),
                    subtitle: const Text('Show exercises for one side at a time'),
                    value: _isOneSided,
                    onChanged: (value) {
                      setState(() => _isOneSided = value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _loadExercises();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
