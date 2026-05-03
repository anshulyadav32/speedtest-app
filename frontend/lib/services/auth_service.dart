import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class AuthService {
  static bool _firebaseInitialized = false;

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current user
  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<void> _ensureFirebaseInitialized() async {
    if (_firebaseInitialized) return;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } on FirebaseException catch (e) {
      // already-initialized is safe to ignore when hot-restarting/reloading
      if (e.code != 'duplicate-app') {
        rethrow;
      }
    }

    _firebaseInitialized = true;
  }

  /// Sign up with email and password
  Future<User?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      await _ensureFirebaseInitialized();
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName(displayName);

        // Store user data in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'displayName': displayName,
          'createdAt': FieldValue.serverTimestamp(),
          'testCount': 0,
          'lastTestDate': null,
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e.code);
    }
  }

  /// Sign in with email and password
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _ensureFirebaseInitialized();
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e.code);
    }
  }

  /// Sign in with Google (web + mobile)
  Future<User?> signInWithGoogle() async {
    try {
      await _ensureFirebaseInitialized();
      if (!kIsWeb) {
        throw 'Google sign-in is currently available on web only.';
      }

      final provider = GoogleAuthProvider();
      provider.addScope('email');
      provider.setCustomParameters({'prompt': 'select_account'});
      final userCredential = await _auth.signInWithPopup(provider);

      final user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email ?? '',
          'displayName': user.displayName ?? 'Google User',
          'createdAt': FieldValue.serverTimestamp(),
          'testCount': 0,
          'lastTestDate': null,
          'provider': 'google',
        }, SetOptions(merge: true));
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e.code);
    } catch (e) {
      throw 'Google sign-in failed. Please try again.';
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _ensureFirebaseInitialized();
    await _auth.signOut();
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _ensureFirebaseInitialized();
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e.code);
    }
  }

  /// Get user stats from Firestore
  Future<Map<String, dynamic>?> getUserStats(String uid) async {
    try {
      await _ensureFirebaseInitialized();
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  /// Update test count after speed test
  Future<void> updateTestCount(String uid) async {
    try {
      await _ensureFirebaseInitialized();
      await _firestore.collection('users').doc(uid).update({
        'testCount': FieldValue.increment(1),
        'lastTestDate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Silent fail for now
    }
  }

  String _getErrorMessage(String code) {
    return switch (code) {
      'weak-password' => 'Password is too weak (min 6 characters)',
      'email-already-in-use' => 'Email already registered',
      'invalid-email' => 'Invalid email address',
      'user-not-found' => 'User not found',
      'wrong-password' => 'Wrong password',
      'too-many-requests' => 'Too many attempts. Try again later',
      _ => 'Authentication error: $code',
    };
  }
}
