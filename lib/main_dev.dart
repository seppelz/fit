import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';
import 'providers/user_provider.dart';
import 'providers/exercise_progress_provider.dart';
import 'providers/recommendation_provider.dart';
import 'providers/muscle_group_provider.dart';
import 'providers/muscle_development_provider.dart';
import 'screens/body_model/enhanced_body_model_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/exercise_service.dart';
import 'services/recommendation_service.dart';
import 'services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider()..setDevelopmentUser(),
        ),
        ChangeNotifierProvider(
          create: (context) {
            final provider = MuscleDevelopmentProvider();
            provider.initializeDevelopmentData();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) => MuscleGroupProvider(),
        ),
        ChangeNotifierProxyProvider<UserProvider, ExerciseProgressProvider>(
          create: (context) => ExerciseProgressProvider(
            exerciseService: ExerciseService(firestore: null),
          ),
          update: (context, userProvider, previous) => previous!,
        ),
        ChangeNotifierProxyProvider<UserProvider, RecommendationProvider>(
          create: (context) => RecommendationProvider(
            recommendationService: RecommendationService(firestore: null),
          ),
          update: (context, userProvider, previous) {
            if (userProvider.user != null) {
              previous?.loadRecommendations(userProvider.user!);
            }
            return previous!;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Fit at Work',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00FF88),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF041E2C),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
