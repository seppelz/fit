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

  void setDevelopmentUser() {
    _user = UserModel(
      id: 'dev_user',
      email: 'dev@example.com',
      name: 'Development User',
      companyId: 'dev_company',
      workStartTime: '09:00',
      workEndTime: '17:00',
      createdAt: DateTime.now(),
      optOutRanking: false,
      exercisePreferences: {
        'difficulty': 'Medium',
        'duration': 10,
        'categories': ['Desk', 'Standing', 'Stretching'],
      },
      workDays: [true, true, true, true, true, false, false], // Mon-Fri
    );
    notifyListeners();
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
