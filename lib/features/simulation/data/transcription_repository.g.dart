// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcription_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transcriptionRepository)
final transcriptionRepositoryProvider = TranscriptionRepositoryProvider._();

final class TranscriptionRepositoryProvider
    extends
        $FunctionalProvider<
          TranscriptionRepository,
          TranscriptionRepository,
          TranscriptionRepository
        >
    with $Provider<TranscriptionRepository> {
  TranscriptionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transcriptionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transcriptionRepositoryHash();

  @$internal
  @override
  $ProviderElement<TranscriptionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TranscriptionRepository create(Ref ref) {
    return transcriptionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TranscriptionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TranscriptionRepository>(value),
    );
  }
}

String _$transcriptionRepositoryHash() =>
    r'794c80d57cd5f03863de364695a04703b0d95450';
