import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/exercise_model.dart';
import '../../../providers/recommendation_provider.dart';
import '../../../providers/user_provider.dart';
import '../../exercise/exercise_details_screen.dart';

class RecommendationsSection extends StatefulWidget {
  const RecommendationsSection({super.key});

  @override
  State<RecommendationsSection> createState() => _RecommendationsSectionState();
}

class _RecommendationsSectionState extends State<RecommendationsSection> {
  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    final user = context.read<UserProvider>().user;
    if (user != null) {
      await context.read<RecommendationProvider>().loadRecommendations(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recommended for You',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _loadRecommendations,
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: Consumer<RecommendationProvider>(
            builder: (context, provider, child) {
              if (provider.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.recommendedExercises.isEmpty) {
                return const Center(
                  child: Text('No recommendations available'),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: provider.recommendedExercises.length,
                itemBuilder: (context, index) {
                  final exercise = provider.recommendedExercises[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _RecommendationCard(exercise: exercise),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final Exercise exercise;

  const _RecommendationCard({
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExerciseDetailsScreen(
                  exercise: exercise,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: exercise.imageUrl.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.fitness_center,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    : Image.network(
                        exercise.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${exercise.duration} min • ${exercise.difficulty}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        exercise.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
