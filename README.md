# Fit at Work

A Flutter application designed to promote fitness and well-being in the workplace.

## Features

- Interactive 3D human model for muscle group selection
- Personalized exercise recommendations
- Video-guided exercises
- Progress tracking and gamification
- Company and global rankings
- Regular strength tests
- Customizable work hour notifications
- Support for both standing and sitting exercises
- Theraband exercise integration

## Technical Requirements

- Flutter SDK
- Firebase
- SQLite
- YouTube API integration

## Setup Instructions

### Prerequisites
- Flutter SDK (installed at `/media/sebastian/DATA/Code/flutter`)
- Android Studio (installed at `/media/sebastian/DATA/Code/android-studio`)
- Android SDK (installed via Android Studio)
- Firebase project configured

### Environment Setup
1. **Flutter SDK**
   - Location: `/media/sebastian/DATA/Code/flutter`
   - Version: 3.16.3

2. **Android Setup**
   - Android SDK installed
   - Minimum SDK Version: 21
   - Target SDK Version: 34
   - Physical device debugging enabled

3. **Firebase Configuration**
   - Project ID: fit-at-work-bd1c1
   - Android package name: com.seppelz.fit_at_work
   - Firebase services ready for:
     - Authentication
     - Cloud Firestore
     - Cloud Storage

### Running the Project
1. Ensure Flutter is in your PATH:
   ```bash
   export PATH="$PATH:/media/sebastian/DATA/Code/flutter/bin"
   ```

2. Connect your Android device with USB debugging enabled

3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure
```
fit_at_work/
├── android/          # Android-specific configuration
├── ios/             # iOS-specific configuration
├── lib/             # Main Dart code
│   ├── models/      # Data models
│   ├── services/    # Business logic and services
│   └── screens/     # UI screens
└── test/            # Test files
```

## Development Status
Current development status and next steps can be found in HANDOVER.md

## Privacy & GDPR Compliance

- User data is stored securely
- Option to opt-out of rankings
- Data export functionality
- Clear data deletion process
- Transparent data usage policy

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  cloud_firestore: ^4.13.3
  sqflite: ^2.3.0
  youtube_player_flutter: ^8.1.2
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  flutter_local_notifications: ^16.2.0
  flutter_3d_viewer: ^1.0.0
```
