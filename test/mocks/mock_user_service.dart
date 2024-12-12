import 'package:fit_at_work/models/user_model.dart';
import 'package:fit_at_work/services/user_service.dart';

class MockUserService extends UserService {
  final UserModel _mockUser = UserModel(
    id: 'test_user',
    email: 'test@example.com',
    name: 'Test User',
    companyId: 'test_company',
    workStartTime: '09:00',
    workEndTime: '17:00',
  );

  MockUserService() : super(firestore: null);

  @override
  Future<UserModel?> getUser(String userId) async {
    return _mockUser;
  }

  @override
  Stream<UserModel?> userStream(String userId) {
    return Stream.value(_mockUser);
  }
}
