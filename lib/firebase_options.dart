import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // These are placeholder values for development
    return const FirebaseOptions(
      apiKey: 'dummy-api-key',
      appId: '1:1234567890:android:1234567890',
      messagingSenderId: '1234567890',
      projectId: 'fit-at-work-dev',
      storageBucket: 'fit-at-work-dev.appspot.com',
    );
  }
}
