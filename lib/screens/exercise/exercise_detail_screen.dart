import 'package:flutter/material.dart';
import '../../models/exercise_model.dart';
import '../../services/exercise_service.dart';
import 'package:provider/provider.dart';
import '../../providers/exercise_progress_provider.dart';
import 'dart:async';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  bool _isPlaying = false;
  late Timer _timer;
  int _secondsRemaining = 0;
  int _currentStep = 0;

  final List<String> _steps = [
    'Get ready',
    'Start exercise',
    'Cool down',
    'Complete',
  ];

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.exercise.duration.inSeconds;
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
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            if (_secondsRemaining > 0) {
              _secondsRemaining--;
            } else {
              _timer.cancel();
              _isPlaying = false;
              if (_currentStep < _steps.length - 1) {
                _currentStep++;
              }
            }
          });
        });
      } else {
        _timer.cancel();
      }
    });
  }

  String get _formattedTime {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF041E2C),
      body: CustomScrollView(
        slivers: [
          // App bar with video placeholder
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF00FF88)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.black45,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Video placeholder
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF00FF88).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    // Play/Pause button
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause_circle : Icons.play_circle,
                        size: 64,
                        color: const Color(0xFF00FF88),
                      ),
                      onPressed: _toggleTimer,
                    ),
                    // Timer overlay
                    Positioned(
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _formattedTime,
                          style: const TextStyle(
                            color: Color(0xFF00FF88),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Exercise content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and current step
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.exercise.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00FF88).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF00FF88),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _steps[_currentStep],
                          style: const TextStyle(
                            color: Color(0xFF00FF88),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Exercise details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF00FF88).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Target Muscle', widget.exercise.targetMuscleGroup.toString()),
                        _buildDetailRow('Type', widget.exercise.type.toString()),
                        _buildDetailRow('Position', widget.exercise.position.toString()),
                        _buildDetailRow('Equipment', widget.exercise.equipment.toString()),
                        _buildDetailRow('Movement', widget.exercise.movement.toString()),
                        _buildDetailRow('Side', widget.exercise.side.toString()),
                        _buildDetailRow('Duration', '${widget.exercise.duration.inMinutes} minutes'),
                        const SizedBox(height: 16),
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00FF88),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.exercise.description,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Action Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border(
            top: BorderSide(
              color: const Color(0xFF00FF88).withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              icon: Icons.check_circle,
              label: 'Complete',
              onPressed: () => _completeExercise(context, completed: true),
            ),
            _buildActionButton(
              icon: Icons.cancel,
              label: 'Cancel',
              onPressed: () => _completeExercise(context, cancelled: true),
            ),
            _buildActionButton(
              icon: Icons.skip_next,
              label: 'Skip',
              onPressed: () => _completeExercise(context, skipped: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF00FF88),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00FF88),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
    );
  }

  Future<void> _completeExercise(
    BuildContext context, {
    bool completed = false,
    bool cancelled = false,
    bool skipped = false,
  }) async {
    if (_isPlaying) {
      _timer.cancel();
      _isPlaying = false;
    }

    final exerciseProgress = Provider.of<ExerciseProgressProvider>(context, listen: false);
    
    try {
      await exerciseProgress.recordExerciseCompletion(
        userId: 'dev_user', // Use actual user ID in production
        exercise: widget.exercise,
        completed: completed,
        cancelled: cancelled,
        skipped: skipped,
      );

      if (!mounted) return;
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            completed ? 'Exercise completed!' :
            cancelled ? 'Exercise cancelled' :
            'Exercise skipped',
          ),
          backgroundColor: completed ? Colors.green :
                          cancelled ? Colors.red :
                          Colors.orange,
        ),
      );

      // Pop back to previous screen
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
