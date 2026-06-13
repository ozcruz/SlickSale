// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Saves profile edits from the Edit Profile dialog. autoDispose: its state
/// belongs to the dialog that triggered it.

@ProviderFor(ProfileEditController)
final profileEditControllerProvider = ProfileEditControllerProvider._();

/// Saves profile edits from the Edit Profile dialog. autoDispose: its state
/// belongs to the dialog that triggered it.
final class ProfileEditControllerProvider
    extends $AsyncNotifierProvider<ProfileEditController, void> {
  /// Saves profile edits from the Edit Profile dialog. autoDispose: its state
  /// belongs to the dialog that triggered it.
  ProfileEditControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileEditControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileEditControllerHash();

  @$internal
  @override
  ProfileEditController create() => ProfileEditController();
}

String _$profileEditControllerHash() =>
    r'6b8251d0c1a7da525eb762c93942b6361856a25e';

/// Saves profile edits from the Edit Profile dialog. autoDispose: its state
/// belongs to the dialog that triggered it.

abstract class _$ProfileEditController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
