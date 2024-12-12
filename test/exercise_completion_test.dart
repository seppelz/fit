import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_at_work/models/exercise_model.dart';
import 'package:fit_at_work/providers/exercise_progress_provider.dart';
import 'package:fit_at_work/providers/user_provider.dart';
import 'package:fit_at_work/screens/exercise/exercise_player_screen.dart';
import 'mocks/mock_user_service.dart';
import 'mocks/mock_exercise_service.dart';
import 'firebase_mock.dart';

void main() {
  late MockExerciseService mockExerciseService;
  late UserProvider userProvider;
  late ExerciseProgressProvider exerciseProgressProvider;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  setUp(() async {
    mockExerciseService = MockExerciseService();
    userProvider = UserProvider(service: MockUserService());
    await userProvider.loadUser('test_user');
    exerciseProgressProvider = ExerciseProgressProvider(exerciseService: mockExerciseService);
  });

  testWidgets('Exercise completion flow test', (WidgetTester tester) async {
    // Create test exercise
    final exercise = Exercise(
      id: 'test_exercise',
      name: 'Test Exercise',
      description: 'Test Description',
      duration: 1,
      caloriesBurn: 10,
      category: 'Test Category',
      difficulty: 'Easy',
      imageUrl: 'test_url',
    );

    // Build widget tree
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: userProvider),
            ChangeNotifierProvider.value(value: exerciseProgressProvider),
          ],
          child: ExercisePlayerScreen(exercise: exercise),
        ),
      ),
    );

    // Wait for widget to settle
    await tester.pumpAndSettle();

    // Debug: Print all text widgets
    print('\nAll Text widgets:');
    for (final widget in tester.allWidgets) {
      if (widget is Text) {
        print('Text: "${widget.data}" - Style: ${widget.style}');
      }
    }

    // Verify initial state
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && 
                    widget.data == 'Get ready' && 
                    widget.style?.fontSize == 24.0,
      ),
      findsOneWidget,
    );
    expect(find.text('01:00'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && 
                    widget.data == 'Calories burned: 10' && 
                    widget.style?.fontSize == 16.0,
      ),
      findsOneWidget,
    );

    // Start exercise
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();

    // Verify exercise is running
    expect(find.byIcon(Icons.pause), findsOneWidget);

    // Fast forward 1 minute
    await tester.pump(const Duration(minutes: 1));

    // Complete exercise
    await tester.tap(find.byIcon(Icons.stop));
    await tester.pumpAndSettle();

    // Verify completion dialog
    expect(find.text('Exercise Complete! 🎉'), findsOneWidget);
    expect(find.text('Great job completing Test Exercise!'), findsOneWidget);

    // Verify data was saved
    final completions = mockExerciseService.getCompletions();
    expect(completions.length, 1);
    expect(completions.first['exerciseId'], 'test_exercise');
    expect(completions.first['duration'], 1);
    expect(completions.first['caloriesBurned'], 10);
  });
}
