# Fit at Work

A Flutter application designed to promote fitness and well-being in the workplace through quick, simple exercises that can be done at your desk.

## Features

Current Features:
- Quick office-friendly exercises (1-2 minutes each)
- Exercise categories: Desk, Standing, Floor, Stretching
- Progress tracking with points and streaks
- Daily exercise recommendations
- Interactive body model for muscle group selection
- Development mode for testing without Firebase
- Muscle development tracking
- Exercise filtering by muscle group

Upcoming Features:
- Video demonstrations
- Company and global rankings
- Customizable work hour notifications

## Getting Started

### Prerequisites
- Flutter SDK (installed at `/media/sebastian/DATA/Code/flutter`)
- Android Studio (installed at `/media/sebastian/DATA/Code/android-studio`)
- Android SDK (installed via Android Studio)
- Firebase project (optional for development mode)

### Environment Setup
1. **Flutter SDK**
   - Location: `/media/sebastian/DATA/Code/flutter`
   - Version: 3.16.3

2. **Android Setup**
   - Android SDK installed
   - Minimum SDK Version: 21
   - Target SDK Version: 34
   - Physical device debugging enabled

3. **Firebase Configuration (Optional)**
   - Only needed for production mode
   - Project ID: fit-at-work-bd1c1
   - Android package name: com.seppelz.fit_at_work

### Running the Project

#### Development Mode (No Firebase Required)
```bash
flutter run -t lib/main_dev.dart
```

#### Production Mode (Requires Firebase)
```bash
flutter run -t lib/main.dart
```

## Project Structure

```
fit_at_work/
├── android/          # Android-specific configuration
├── ios/             # iOS-specific configuration
├── lib/             # Main Dart code
│   ├── main.dart          # Production entry point
│   ├── main_dev.dart      # Development entry point
│   ├── models/           # Data models
│   │   ├── exercise_model.dart     # Exercise data structure
│   │   ├── muscle_group_model.dart # Muscle group enums and properties
│   │   └── progress_model.dart     # Progress tracking
│   ├── providers/        # State management
│   │   ├── muscle_group_provider.dart  # Muscle selection state
│   │   └── muscle_development_provider.dart # Development tracking
│   ├── screens/         # UI screens
│   │   ├── body_model/  # Interactive body model components
│   │   └── exercise/    # Exercise-related screens
│   ├── services/        # Business logic
│   └── widgets/         # Reusable UI components
└── test/            # Test files

## Development Notes

- The app uses Provider for state management
- Development mode uses mock data and services
- Exercise durations are kept short (1-2 minutes) for better workplace integration
- Focus on simple, effective exercises that can be done at a desk
- Interactive body model uses SVG paths for accurate muscle group visualization
- Muscle development is tracked and visualized through color gradients

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

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
