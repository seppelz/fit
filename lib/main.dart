import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'providers/user_provider.dart';
import 'services/user_service.dart';
import 'services/auth_service.dart';
import 'providers/exercise_progress_provider.dart';
import 'providers/muscle_group_provider.dart';
import 'providers/muscle_development_provider.dart';
import 'screens/body_model/enhanced_body_model_screen.dart';
import 'models/user_model.dart';
import 'firebase_options.dart';
import 'models/database/database_helper.dart'; // Import DatabaseHelper

// Set to true to skip login and use a development user
const bool kDevMode = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase first
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
  }
  
  // Initialize database
  try {
    final dbHelper = DatabaseHelper();
    await dbHelper.database; // This will create and initialize the database
    
    // Verify database initialization
    final exerciseCount = await dbHelper.getExerciseCount();
    debugPrint('Database initialized successfully with $exerciseCount exercises');
  } catch (e) {
    debugPrint('Failed to initialize database: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          final provider = UserProvider();
          if (kDevMode) {
            provider.setDevelopmentUser(); // Set development user if in dev mode
          }
          return provider;
        }),
        ChangeNotifierProvider(create: (_) => ExerciseProgressProvider()),
        ChangeNotifierProvider(create: (_) => MuscleGroupProvider()),
        ChangeNotifierProvider(
          create: (_) => MuscleDevelopmentProvider()..initializeDevelopmentData(),
        ),
      ],
      child: MaterialApp(
        title: 'Fit at Work',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF041E2C),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00A3FF),
            secondary: Color(0xFF00FFB2),
            surface: Color(0xFF0A2A3C),
            background: Color(0xFF041E2C),
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            headlineMedium: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
            bodyLarge: TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 16,
              letterSpacing: 0.2,
            ),
          ),
          useMaterial3: true,
        ),
        home: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            final user = userProvider.user;
            
            if (user == null) {
              return const LoginScreen();
            }

            if (!user.hasCompletedOnboarding) {
              return const OnboardingScreen();
            }

            return const EnhancedBodyModelScreen();
          },
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Fit at Work',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white.withOpacity(0.8)),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: const EnhancedBodyModelScreen(),
    );
  }
}
