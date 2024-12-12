import 'package:flutter/material.dart';
import '../body_model/enhanced_body_model_screen.dart';
import '../../models/exercise_model.dart';
import '../../models/progress_model.dart';
import '../../widgets/progress_circle.dart';
import '../../widgets/streak_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF041E2C),
      body: SafeArea(
        child: Column(
          children: [
            // Top Progress Section
            _buildProgressHeader(context),
            
            // Enhanced Body Model Section
            const Expanded(
              child: EnhancedBodyModelScreen(),
            ),
            
            // Bottom Stats Section
            _buildStatsFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF00FF88).withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Main Progress Circle
          Expanded(
            flex: 2,
            child: ProgressCircle(
              progress: 0.6,
              size: 80,
              centerText: '6/10',
              subtitle: 'Today\'s\nExercises',
              progressColor: const Color(0xFF00FF88),
            ),
          ),
          
          // Weekly Progress
          Expanded(
            child: Column(
              children: [
                Icon(Icons.calendar_today, color: const Color(0xFF00FF88)),
                Text('This Week',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    )),
                Text('85%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF00FF88),
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          
          // Monthly Progress
          Expanded(
            child: Column(
              children: [
                Icon(Icons.calendar_month, color: const Color(0xFF00FF88)),
                Text('This Month',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    )),
                Text('78%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF00FF88),
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border(
          top: BorderSide(
            color: const Color(0xFF00FF88).withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            Icons.local_fire_department,
            '5 Days',
            'Streak',
          ),
          _buildStatItem(
            context,
            Icons.stars,
            '2,500',
            'Points',
          ),
          _buildStatItem(
            context,
            Icons.emoji_events,
            'Gold',
            'Next Rank',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF00FF88)),
        const SizedBox(height: 4),
        Text(value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            )),
      ],
    );
  }
}
