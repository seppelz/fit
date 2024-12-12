import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'reset',
          onPressed: () {
            // TODO: Implement reset view
          },
          child: const Icon(Icons.refresh),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'zoom_in',
          onPressed: () {
            // TODO: Implement zoom in
          },
          child: const Icon(Icons.zoom_in),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'zoom_out',
          onPressed: () {
            // TODO: Implement zoom out
          },
          child: const Icon(Icons.zoom_out),
        ),
      ],
    );
  }
}
