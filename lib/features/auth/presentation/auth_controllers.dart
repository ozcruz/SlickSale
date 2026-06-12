import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';
import '../data/user_repository.dart';
import '../domain/app_user.dart';

part 'auth_controllers.g.dart';

/// Maps any thrown error to a message safe for the UI.
String friendlyAuthError(Object error) =>
    error is AuthException ? error.message : 'Something went wrong. Please try again.';

/// Runs an auth action and normalizes the outcome:
/// - success and user-cancelled flows both end as AsyncData (no error UI),
/// - Firestore failures become friendly [AuthException]s,
/// - everything else surfaces as AsyncError for the inline banner.
Future<AsyncValue<void>> _runAuthAction(
  Future<void> Function() action,
) async {
  try {
    await action();
    return const AsyncData(null);
  } on AuthCancelledException {
    return const AsyncData(null);
  } on AuthException catch (error, stackTrace) {
    return AsyncError(error, stackTrace);
  } on FirebaseException catch (error, stackTrace) {
    debugPrint('FirebaseException(${error.plugin}/${error.code}): '
        '${error.message}');
    final message = error.code == 'permission-denied'
        ? 'Could not save your data — check that the Firestore rules are deployed.'
        : 'Could not reach the server. Please try again.';
    return AsyncError(AuthException(message), stackTrace);
  } catch (error, stackTrace) {
    debugPrint('Unexpected auth error: $error');
    return AsyncError(error, stackTrace);
  }
}

// Each user-triggered action gets its own tiny AsyncNotifier so every button
// shows its own loading spinner independently. autoDispose (default): the
// state belongs to the screen that triggered it.

@riverpod
class EmailSignInController extends _$EmailSignInController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await _runAuthAction(
      () => ref
          .read(authRepositoryProvider)
          .signInWithEmail(email: email, password: password),
    );
    if (ref.mounted) state = result;
  }
}

@riverpod
class EmailSignUpController extends _$EmailSignUpController {
  @override
  FutureOr<void> build() {}

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await _runAuthAction(
      () => ref
          .read(authRepositoryProvider)
          .signUpWithEmail(email: email, password: password),
    );
    if (ref.mounted) state = result;
  }
}

@riverpod
class GoogleSignInController extends _$GoogleSignInController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn() async {
    state = const AsyncLoading();
    final result = await _runAuthAction(
      () => ref.read(authRepositoryProvider).signInWithGoogle(),
    );
    if (ref.mounted) state = result;
  }
}

@riverpod
class SignOutController extends _$SignOutController {
  @override
  FutureOr<void> build() {}

  Future<void> signOut() async {
    state = const AsyncLoading();
    final result = await _runAuthAction(
      () => ref.read(authRepositoryProvider).signOut(),
    );
    if (ref.mounted) state = result;
  }
}

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  FutureOr<void> build() {}

  /// Creates the user profile document and marks onboarding complete.
  /// Returns true on success so the screen can navigate immediately.
  Future<bool> complete({
    required String displayName,
    required ExperienceLevel experienceLevel,
    required String industry,
  }) async {
    state = const AsyncLoading();
    final result = await _runAuthAction(() async {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) {
        throw const AuthException('Your session expired. Please sign in again.');
      }
      final profile = AppUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: displayName,
        experienceLevel: experienceLevel,
        industry: industry,
        createdAt: DateTime.now(),
        onboardingCompleted: true,
      );
      await ref.read(userRepositoryProvider).createUserProfile(profile);
      try {
        await user.updateDisplayName(displayName);
      } on FirebaseException catch (error) {
        // Non-fatal: the Firestore profile is the source of truth.
        debugPrint('updateDisplayName failed: ${error.code}');
      }
    });
    if (ref.mounted) state = result;
    return result is AsyncData;
  }
}
