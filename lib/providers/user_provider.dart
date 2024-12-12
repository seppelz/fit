import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService;
  UserModel? _user;
  bool _isLoading = false;

  UserProvider({UserService? service}) : _userService = service ?? UserService();

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadUser(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _userService.getUser(userId);
    } catch (e) {
      debugPrint('Error loading user: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setDevelopmentUser() async {
    _user = UserModel(
      id: 'dev_user',
      email: 'dev@example.com',
      name: 'Development User',
      companyId: 'dev_company',
      workStartTime: '09:00',
      workEndTime: '17:00',
      createdAt: DateTime.now(),
      optOutRanking: false,
      hasCompletedOnboarding: true,  // Set this to true to skip onboarding
      exercisePreferences: {
        'difficulty': 'Medium',
        'duration': 10,
        'categories': ['Desk', 'Standing', 'Stretching'],
        'hasTheraband': true,
        'allowStandingExercises': true,
        'allowSittingExercises': true,
        'allowStrengthening': true,
        'allowMobilisation': true,
        'notificationsEnabled': true,
      },
      workDays: [true, true, true, true, true, false, false], // Mon-Fri
    );
    notifyListeners();

    // Update user settings in database
    try {
      await _userService.updateUserSettings(_user!.id, {
        'has_theraband': true,
        'allow_standing_exercises': true,
        'allow_sitting_exercises': true,
        'allow_strengthening': true,
        'allow_mobilisation': true,
        'notification_enabled': true,
      });
    } catch (e) {
      debugPrint('Error updating user settings: $e');
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userService.updateUser(updatedUser);
      _user = updatedUser;
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
