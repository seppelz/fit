import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/exercise_model.dart';
import '../../providers/exercise_progress_provider.dart';
import '../../providers/user_provider.dart';

class ExercisePlayerScreen extends StatefulWidget {
  final Exercise exercise;

  const ExercisePlayerScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<ExercisePlayerScreen> createState() => _ExercisePlayerScreenState();
}

class _ExercisePlayerScreenState extends State<ExercisePlayerScreen> {
  late Timer _timer;
  int _secondsRemaining = 0;
  bool _isPlaying = false;
  int _currentStep = 0;
  int _caloriesBurned = 0;

  final List<String> _steps = [
    'Get ready',
    'Start exercise',
    'Cool down',
    'Complete',
  ];

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.exercise.duration * 60;
    _caloriesBurned = widget.exercise.caloriesBurn;
  }

  @override
  void dispose() {
    if (_isPlaying) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startTimer();
      } else {
        _timer.cancel();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          // Update calories burned based on progress
          _caloriesBurned = (widget.exercise.caloriesBurn *
                  (1 - _secondsRemaining / (widget.exercise.duration * 60)))
              .round();
          // Update step based on progress
          _currentStep = (_steps.length - 1) -
              (_secondsRemaining / (widget.exercise.duration * 60) *
                      (_steps.length - 1))
                  .floor();
        } else {
          _timer.cancel();
          _isPlaying = false;
          _completeExercise();
        }
      });
    });
  }

  Future<void> _completeExercise() async {
    final user = context.read<UserProvider>().user;
    if (user == null) return;

    try {
      await context.read<ExerciseProgressProvider>().recordExerciseCompletion(
            userId: user.id,
            exercise: widget.exercise,
            actualDuration: widget.exercise.duration,
            actualCalories: _caloriesBurned,
          );

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exercise Complete! 🎉'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Great job completing ${widget.exercise.name}!'),
                const SizedBox(height: 16),
                _buildStatRow(
                  Icons.timer_outlined,
                  'Duration',
                  '${widget.exercise.duration} min',
                ),
                const SizedBox(height: 8),
                _buildStatRow(
                  Icons.local_fire_department_outlined,
                  'Calories Burned',
                  '$_caloriesBurned cal',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error recording completion: $e')),
        );
      }
    }
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(label),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
      ),
      body: Column(
        children: [
          // Progress steps
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: List.generate(
                _steps.length * 2 - 1,
                (index) {
                  if (index % 2 == 0) {
                    final stepIndex = index ~/ 2;
                    return Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: stepIndex <= _currentStep
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _steps[stepIndex],
                          style: TextStyle(
                            color: stepIndex <= _currentStep
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox(width: 8);
                  }
                },
              ),
            ),
          ),

          // Timer display
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(_secondsRemaining),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 32),
                  CircularProgressIndicator(
                    value: _secondsRemaining / (widget.exercise.duration * 60),
                    strokeWidth: 8,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _steps[_currentStep],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Calories burned: $_caloriesBurned',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),

          // Controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.filled(
                  onPressed: () {
                    // Reset timer
                    setState(() {
                      if (_isPlaying) {
                        _timer.cancel();
                      }
                      _isPlaying = false;
                      _secondsRemaining = widget.exercise.duration * 60;
                      _currentStep = 0;
                      _caloriesBurned = 0;
                    });
                  },
                  icon: const Icon(Icons.restart_alt),
                ),
                FloatingActionButton.large(
                  onPressed: _toggleTimer,
                  child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                ),
                IconButton.filled(
                  onPressed: () {
                    if (_isPlaying) {
                      _timer.cancel();
                    }
                    _completeExercise();
                  },
                  icon: const Icon(Icons.stop),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
