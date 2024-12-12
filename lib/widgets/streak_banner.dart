import 'package:flutter/material.dart';

class StreakBanner extends StatelessWidget {
  final int streakDays;
  final int points;

  const StreakBanner({
    Key? key,
    required this.streakDays,
    required this.points,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Streak Icon and Count
          Icon(
            Icons.local_fire_department,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          SizedBox(width: 8),
          Text(
            '$streakDays Day Streak!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          Spacer(),
          // Points
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.stars,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 4),
              Text(
                '$points pts',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
