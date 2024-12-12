import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore? _firestore;
  final String _collection = 'users';

  UserService({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    if (_firestore == null) return;
    await _firestore!.collection(_collection).doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUser(String userId) async {
    if (_firestore == null) return null;
    final doc = await _firestore!.collection(_collection).doc(userId).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      data['id'] = doc.id;
      return UserModel.fromMap(data);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    if (_firestore == null) return;
    await _firestore!.collection(_collection).doc(user.id).update(user.toMap());
  }

  Stream<UserModel?> userStream(String userId) {
    if (_firestore == null) {
      return Stream.value(null);
    }
    return _firestore!.collection(_collection).doc(userId).snapshots().map(
          (doc) => doc.exists
              ? UserModel.fromMap(doc.data()!..['id'] = doc.id)
              : null,
        );
  }

  Future<void> updateUserSettings(String userId, Map<String, dynamic> settings) async {
    if (_firestore == null) return;
    
    // First check if user settings exist
    final userSettingsRef = _firestore!.collection('user_settings').doc(userId);
    final doc = await userSettingsRef.get();
    
    if (doc.exists) {
      // Update existing settings
      await userSettingsRef.update(settings);
    } else {
      // Create new settings
      await userSettingsRef.set(settings);
    }
  }
}
