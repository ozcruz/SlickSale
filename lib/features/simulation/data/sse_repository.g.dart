// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sse_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sseChatRepository)
final sseChatRepositoryProvider = SseChatRepositoryProvider._();

final class SseChatRepositoryProvider
    extends
        $FunctionalProvider<
          SseChatRepository,
          SseChatRepository,
          SseChatRepository
        >
    with $Provider<SseChatRepository> {
  SseChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sseChatRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sseChatRepositoryHash();

  @$internal
  @override
  $ProviderElement<SseChatRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SseChatRepository create(Ref ref) {
    return sseChatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SseChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SseChatRepository>(value),
    );
  }
}

String _$sseChatRepositoryHash() => r'5ae2242d111b2a570425f2983d852906a67a45fe';
