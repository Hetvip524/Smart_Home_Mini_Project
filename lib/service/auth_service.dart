import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

@JS('google.accounts.id')
external dynamic get googleAccounts;

@JS('google.accounts.id.initialize')
external void initializeGoogleSignIn(dynamic config);

@JS('google.accounts.id.prompt')
external void promptGoogleSignIn();

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Clear any existing sessions
      await _auth.signOut();
      
      print('Attempting to sign in with email: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      print('Sign in successful for user: ${credential.user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during sign in: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found with this email.';
        case 'wrong-password':
          throw 'Incorrect password.';
        case 'invalid-email':
          throw 'Invalid email format.';
        case 'user-disabled':
          throw 'This account has been disabled.';
        case 'too-many-requests':
          throw 'Too many attempts. Please try again later.';
        case 'invalid-credential':
          throw 'The provided credentials are invalid or expired.';
        case 'operation-not-allowed':
          throw 'Email/password sign-in is not enabled.';
        default:
          throw e.message ?? 'An error occurred during sign in.';
      }
    } catch (e) {
      print('Unexpected error during sign in: $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      // Clear any existing sessions
      await _auth.signOut();
      
      print('Attempting to register with email: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      print('Registration successful for user: ${credential.user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during registration: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'weak-password':
          throw 'Password is too weak. Use at least 6 characters.';
        case 'email-already-in-use':
          throw 'An account already exists with this email.';
        case 'invalid-email':
          throw 'Invalid email format.';
        case 'operation-not-allowed':
          throw 'Email/password registration is not enabled.';
        case 'too-many-requests':
          throw 'Too many attempts. Please try again later.';
        default:
          throw e.message ?? 'An error occurred during registration.';
      }
    } catch (e) {
      print('Unexpected error during registration: $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Clear any existing sessions
        await _auth.signOut();
        await _googleSignIn.signOut();
        
        // Initialize Google Sign-In for web
        final provider = GoogleAuthProvider();
        provider.addScope('email');
        return await _auth.signInWithPopup(provider);
      } else {
        // Handle mobile Google Sign-In
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) throw 'Google Sign In was cancelled';

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during Google sign in: ${e.code} - ${e.message}');
      throw e.message ?? 'Failed to sign in with Google. Please try again.';
    } catch (e) {
      print('Unexpected error during Google sign in: $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('Error during sign out: $e');
      throw 'Failed to sign out. Please try again.';
    }
  }
} 