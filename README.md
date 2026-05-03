# Net Speed Test App

A cross-platform speed test application built with Flutter.

## Project Structure

```
├── frontend/          # Flutter app (web, iOS, Android, macOS)
│   ├── lib/          # Dart source code
│   ├── web/          # Web platform files
│   ├── ios/          # iOS platform files
│   ├── android/      # Android platform files
│   ├── macos/        # macOS platform files
│   ├── test/         # Unit and widget tests
│   ├── pubspec.yaml  # Dependencies
│   └── README.md     # Flutter project README
```

## Getting Started

### Prerequisites
- Flutter 3.41.6 (stable)
- Dart 3.11.4

### Development

```bash
cd frontend
flutter pub get
flutter run
```

### Web Deployment

```bash
cd frontend
flutter build web --release
vercel deploy --prod
```

## Platforms

- **Web**: Deployed on Vercel at https://netspeed-navy.vercel.app
- **iOS**: Available via App Store (when built and distributed)
- **Android**: Available via Google Play Store (when built and distributed)
- **macOS**: Desktop app

## Technology Stack

- **Framework**: Flutter
- **Language**: Dart
- **Backend**: Firebase Authentication & Firestore
- **State Management**: Provider
- **Web Hosting**: Vercel
