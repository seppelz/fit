# AI Assistant Prompt for Fit at Work

Use this prompt when working with an AI assistant to ensure they understand the project context and can provide relevant help.

## Project Context Prompt

"I'm working on the 'Fit at Work' Flutter application, a workplace wellness app designed to combat sedentary lifestyle through office-friendly exercises. The app uses Flutter 3.16.3 with Firebase backend and features an interactive body model for muscle group visualization and exercise targeting.

Key technical aspects:
- Flutter/Dart for cross-platform development
- Firebase Firestore for exercise database and user data
- Provider for state management
- SVG-based interactive body model
- MuscleGroups enum for standardized muscle tracking
- Comprehensive exercise model with categorization

The codebase follows a feature-first architecture with separate services for authentication, exercise management, muscle development tracking, and user progress tracking. The app includes an interactive SVG-based body model for muscle visualization and supports both development and production modes.

The exercise system is fully implemented with:
- Structured exercise model (type, position, equipment, movement, side)
- Firebase Firestore integration for exercise data
- Development mode with mock exercises
- Exercise filtering by muscle groups and categories
- Progress tracking for completed exercises

Please help me maintain consistent code style, follow the established architecture patterns, and ensure all new features align with our workplace wellness focus."

## Common Tasks Prompt

When working on specific tasks, append one of these contexts:

### For UI Work
"I'm working on the UI components, which should follow our established design system using reusable widgets from lib/widgets/. All UI should be responsive, support both light and dark themes, and maintain smooth transitions for interactive elements."

### For Backend Integration
"I'm working with Firebase integration. All data operations should follow our established patterns in lib/services/, include proper error handling, and support development mode through mock services."

### For Exercise Content
"I'm working with the exercise system in lib/models/. The exercise model is fully implemented with categorization by type (strength, mobilization), position (sitting, standing), equipment (bodyweight, theraband), movement (static, dynamic), and side (both, alternating). Changes should maintain compatibility with the existing Firestore schema and mock services."

### For Body Model
"I'm working with the interactive body model in lib/screens/body_model/. Changes should maintain SVG path accuracy, support proper muscle group visualization, and ensure smooth state transitions for hover and selection effects."

### For Testing
"I'm working on tests in the test/ directory. We maintain unit tests for services, widget tests for UI components, and integration tests for user flows, including body model interactions and exercise completion flow."

## Important Considerations

Always remind the AI assistant to:
1. Follow Flutter best practices and our established patterns
2. Maintain backwards compatibility with existing features
3. Consider performance implications, especially for SVG rendering
4. Include proper error handling and loading states
5. Update documentation for significant changes
6. Consider accessibility in all UI changes
7. Maintain GDPR compliance in data handling
8. Use the MuscleGroups enum for muscle-related features
9. Support both development and production modes
10. Keep exercise durations appropriate for office settings (1-2 minutes)
11. Maintain compatibility with the Firestore exercise schema
12. Consider both online and development mode when making changes
