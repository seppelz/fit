import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtcqt36AtRNqwgHk3xo-AelCo8ys5OcNY',
    appId: '1:787022911821:android:eeae2c9f9bf911c448bf04',
    messagingSenderId: '787022911821',
    projectId: 'fit-at-work-bd1c1',
    storageBucket: 'fit-at-work-bd1c1.firebasestorage.app',
  );
}
