import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';

part 'settings_controllers.g.dart';

/// Saves profile edits from the Edit Profile dialog. autoDispose: its state
/// belongs to the dialog that triggered it.
@riverpod
class ProfileEditController extends _$ProfileEditController {
  @override
  FutureOr<void> build() {}

  /// Returns true on success so the dialog can close immediately.
  Future<bool> save(AppUser updated) async {
    state = const AsyncLoading();
    try {
      await ref.read(userRepositoryProvider).updateUserProfile(updated);
      if (ref.mounted) state = const AsyncData(null);
      return true;
    } on FirebaseException catch (error, stackTrace) {
      debugPrint('Profile save failed (${error.code}): ${error.message}');
      if (ref.mounted) state = AsyncError(error, stackTrace);
      return false;
    } catch (error, stackTrace) {
      debugPrint('Profile save failed: $error');
      if (ref.mounted) state = AsyncError(error, stackTrace);
      return false;
    }
  }
}
