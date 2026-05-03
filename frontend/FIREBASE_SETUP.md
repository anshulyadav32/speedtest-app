# Firebase Setup Guide

To complete the Firebase integration, follow these steps:

## 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project (or use existing)
3. Enable Authentication (Email/Password method)
4. Create Firestore Database (Start in test mode for development)

## 2. Configure Firebase for Each Platform

### Web
1. In Firebase Console, register a web app
2. Copy the Firebase config
3. Update `lib/firebase_options.dart` with your web credentials

### Android
1. In Firebase Console, register an Android app
2. Download `google-services.json`
3. Place it in `android/app/`
4. Update `lib/firebase_options.dart` with Android API key

### iOS / macOS
1. In Firebase Console, register an iOS app
2. Download `GoogleService-Info.plist`
3. Add to iOS project via Xcode
4. Update `lib/firebase_options.dart` with iOS credentials

## 3. Firestore Security Rules (Development)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

## 4. Test the Auth System
- Run the app
- You'll see the login screen
- Click "Sign Up" to create a new account
- After login, access the speed test app
- Click "SIGN OUT" to return to login

## Features Implemented
✅ Email/Password authentication
✅ Sign up with validation
✅ Password reset
✅ User profiles in Firestore
✅ Test statistics tracking (testCount, lastTestDate)
✅ Auto sign-in on app restart
✅ Protected routes

## Next Steps (Optional)
- Add Google/GitHub OAuth sign-in
- Email verification
- User profile editing screen
- Speed test history dashboard
- Sharing results
