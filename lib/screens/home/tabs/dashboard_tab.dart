import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/recommendation_provider.dart';
import '../widgets/daily_progress_card.dart';
import '../widgets/next_exercise_card.dart';
import '../widgets/stats_grid.dart';
import '../widgets/recommendations_section.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final user = context.read<UserProvider>().user;
          if (user != null) {
            await context.read<RecommendationProvider>().loadRecommendations(user);
          }
        },
        child: ListView(
          children: [
            // Welcome message
            Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  final user = userProvider.user;
                  return Text(
                    'Welcome back, ${user?.name ?? 'there'}!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  );
                },
              ),
            ),

            // Daily progress
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DailyProgressCard(),
            ),
            const SizedBox(height: 24),

            // Next exercise
            Consumer<RecommendationProvider>(
              builder: (context, provider, child) {
                if (provider.nextExercise == null) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: NextExerciseCard(
                    exercise: provider.nextExercise!,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Recommendations
            const RecommendationsSection(),
            const SizedBox(height: 24),

            // Stats grid
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: StatsGrid(),
            ),
            const SizedBox(height: 16),

            // Recent activity
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3, // Show last 3 activities
                  itemBuilder: (context, index) {
                    return const ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.fitness_center),
                      ),
                      title: Text('Desk Stretches'),
                      subtitle: Text('Completed • 2h ago'),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
