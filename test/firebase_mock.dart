import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

typedef Callback = void Function(MethodCall call);

final mockFirebaseOptions = FirebaseOptions(
  apiKey: 'test-api-key',
  appId: 'test-app-id',
  messagingSenderId: 'test-sender-id',
  projectId: 'test-project-id',
);

class MockFirebaseApp extends FirebaseAppPlatform {
  MockFirebaseApp() : super('[DEFAULT]', mockFirebaseOptions);
}

class MockFirebasePlatform extends FirebasePlatform {
  @override
  Future<List<Map<String, dynamic>>> initializeCore() async {
    return [
      {
        'name': '[DEFAULT]',
        'options': mockFirebaseOptions.asMap,
        'pluginConstants': {},
      }
    ];
  }

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return MockFirebaseApp();
  }

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return MockFirebaseApp();
  }
}

void setupFirebaseCoreMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  FirebasePlatform.instance = MockFirebasePlatform();
}
