import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/firebase_providers.dart';

part 'auth_repository.g.dart';

/// Auth failure with a [message] that is safe to show in the UI — raw
/// Firebase error codes never reach a screen.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The user dismissed a sign-in flow (closed the Google popup, etc.).
/// Controllers swallow this instead of showing an error.
class AuthCancelledException extends AuthException {
  const AuthCancelledException() : super('Sign-in cancelled.');
}

class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;
  bool _googleInitialized = false;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _guard(
        () => _auth.signInWithEmailAndPassword(email: email, password: password),
      );

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) =>
      _guard(
        () => _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      );

  /// Web (the primary target) uses the Firebase popup flow directly; other
  /// platforms go through the google_sign_in plugin.
  Future<UserCredential> signInWithGoogle() => _guard(() async {
        if (kIsWeb) {
          final provider = GoogleAuthProvider()..addScope('email');
          return _auth.signInWithPopup(provider);
        }
        final google = GoogleSignIn.instance;
        if (!_googleInitialized) {
          await google.initialize();
          _googleInitialized = true;
        }
        final account = await google.authenticate();
        final credential = GoogleAuthProvider.credential(
          idToken: account.authentication.idToken,
        );
        return _auth.signInWithCredential(credential);
      });

  Future<void> signOut() => _guard(() => _auth.signOut());

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on FirebaseAuthException catch (error) {
      if (_cancelledCodes.contains(error.code)) {
        throw const AuthCancelledException();
      }
      debugPrint('FirebaseAuthException(${error.code}): ${error.message}');
      throw AuthException(_friendlyMessage(error.code));
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthCancelledException();
      }
      debugPrint('GoogleSignInException(${error.code}): ${error.description}');
      throw const AuthException('Google sign-in failed. Please try again.');
    }
  }

  static const Set<String> _cancelledCodes = {
    'popup-closed-by-user',
    'cancelled-popup-request',
    'user-cancelled',
    'web-context-cancelled',
  };

  static String _friendlyMessage(String code) => switch (code) {
        'invalid-email' => 'That email address looks invalid.',
        'user-disabled' => 'This account has been disabled.',
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' ||
        'INVALID_LOGIN_CREDENTIALS' =>
          'Incorrect email or password.',
        'email-already-in-use' =>
          'An account already exists with that email. Try signing in instead.',
        'weak-password' => 'Password is too weak — use at least 6 characters.',
        'operation-not-allowed' =>
          'This sign-in method is not enabled for the project.',
        'too-many-requests' =>
          'Too many attempts. Wait a moment and try again.',
        'network-request-failed' =>
          'Network error. Check your connection and try again.',
        'popup-blocked' =>
          'Your browser blocked the sign-in popup. Allow popups and try again.',
        'account-exists-with-different-credential' =>
          'An account already exists with a different sign-in method for that email.',
        _ => 'Something went wrong. Please try again.',
      };
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(firebaseAuthProvider));

/// Raw Firebase auth state. keepAlive: it drives router redirects app-wide.
@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();
