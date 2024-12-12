import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/muscle_group_model.dart';
import '../../providers/muscle_group_provider.dart';
import 'widgets/muscle_info_card.dart';
import 'widgets/interactive_body_model.dart';

class BodyModelScreen extends StatelessWidget {
  const BodyModelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MuscleGroupProvider>(
        builder: (context, provider, child) {
          final selectedMuscle = provider.selectedGroup;

          return Column(
            children: [
              // Compact header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Body Progress',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        // Show info dialog
                      },
                    ),
                  ],
                ),
              ),
              
              // Main content with body model
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate the maximum size that maintains the SVG's aspect ratio
                    final maxWidth = constraints.maxWidth;
                    final maxHeight = constraints.maxHeight;
                    final aspectRatio = 206.326 / 206.326; // SVG aspect ratio
                    
                    // Use the larger dimension to maximize space usage
                    final width = maxWidth;
                    final height = width / aspectRatio;
                    
                    return Center(
                      child: SizedBox(
                        width: width,
                        height: height,
                        child: InteractiveBodyModel(),
                      ),
                    );
                  },
                ),
              ),
              if (selectedMuscle != null)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MuscleInfoCard(
                      muscleGroup: selectedMuscle,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
