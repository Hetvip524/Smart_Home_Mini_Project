import 'package:domus/provider/base_model.dart';
import 'package:domus/service/auth_service.dart';
import 'package:domus/service/navigation_service.dart';
import 'package:domus/provider/getit.dart';
import 'package:domus/src/screens/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class AuthViewModel extends BaseModel {
  final AuthService _authService = AuthService();
  final NavigationService _navigationService = getIt<NavigationService>();
  String? _errorMessage;
  bool _isLoading = false;
  int _attemptCount = 0;
  DateTime? _lastAttemptTime;
  static const int _maxAttempts = 5;
  static const Duration _cooldownDuration = Duration(minutes: 15);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _authService.currentUser;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  bool _checkRateLimit() {
    if (_lastAttemptTime != null) {
      final timeSinceLastAttempt = DateTime.now().difference(_lastAttemptTime!);
      if (timeSinceLastAttempt < _cooldownDuration && _attemptCount >= _maxAttempts) {
        final remainingTime = _cooldownDuration - timeSinceLastAttempt;
        _setError('Too many attempts. Please try again in ${(remainingTime.inMinutes + 1)} minutes.');
        return false;
      }
      if (timeSinceLastAttempt >= _cooldownDuration) {
        _attemptCount = 0;
      }
    }
    return true;
  }

  void _updateAttemptCount() {
    _attemptCount++;
    _lastAttemptTime = DateTime.now();
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    if (!_checkRateLimit()) return false;

    try {
      _setLoading(true);
      _setError(null);
      
      // Add a small delay to prevent rapid-fire attempts
      await Future.delayed(const Duration(milliseconds: 500));
      
      await _authService.signInWithEmailAndPassword(email, password);
      _navigationService.navigateTo(HomeScreen.routeName, withreplacement: true);
      _attemptCount = 0; // Reset counter on successful login
      return true;
    } catch (e) {
      _updateAttemptCount();
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            _setError('No user found with this email.');
            break;
          case 'wrong-password':
            _setError('Incorrect password.');
            break;
          case 'invalid-email':
            _setError('Invalid email format.');
            break;
          case 'too-many-requests':
            _setError('Too many attempts. Please try again later.');
            break;
          default:
            _setError(e.message ?? 'An error occurred during sign in.');
        }
      } else {
        _setError(e.toString());
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> registerWithEmailAndPassword(String email, String password) async {
    if (!_checkRateLimit()) return false;

    try {
      _setLoading(true);
      _setError(null);
      
      // Add a small delay to prevent rapid-fire attempts
      await Future.delayed(const Duration(milliseconds: 500));
      
      await _authService.registerWithEmailAndPassword(email, password);
      _navigationService.navigateTo(HomeScreen.routeName, withreplacement: true);
      _attemptCount = 0; // Reset counter on successful registration
      return true;
    } catch (e) {
      _updateAttemptCount();
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'weak-password':
            _setError('Password is too weak. Use at least 6 characters.');
            break;
          case 'email-already-in-use':
            _setError('An account already exists with this email.');
            break;
          case 'invalid-email':
            _setError('Invalid email format.');
            break;
          case 'too-many-requests':
            _setError('Too many attempts. Please try again later.');
            break;
          default:
            _setError(e.message ?? 'An error occurred during registration.');
        }
      } else {
        _setError(e.toString());
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.signInWithGoogle();
      _navigationService.navigateTo(HomeScreen.routeName, withreplacement: true);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.signOut();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
} 