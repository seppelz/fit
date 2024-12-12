import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'providers/user_provider.dart';
import 'services/user_service.dart';
import 'providers/exercise_progress_provider.dart';
import 'providers/muscle_group_provider.dart';
import 'providers/muscle_development_provider.dart';
import 'screens/body_model/enhanced_body_model_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              return FutureBuilder<UserModel?>(
                future: UserService().getUser(snapshot.data!.uid),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (userSnapshot.hasData) {
                    if (!userSnapshot.data!.hasCompletedOnboarding) {
                      return const OnboardingScreen();
                    }
                    return const EnhancedBodyModelScreen();
                  }
                  return const LoginScreen();
                },
              );
            }

            return const LoginScreen();
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
