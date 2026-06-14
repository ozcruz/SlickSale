// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoring_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(scoringRepository)
final scoringRepositoryProvider = ScoringRepositoryProvider._();

final class ScoringRepositoryProvider
    extends
        $FunctionalProvider<
          ScoringRepository,
          ScoringRepository,
          ScoringRepository
        >
    with $Provider<ScoringRepository> {
  ScoringRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scoringRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scoringRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScoringRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScoringRepository create(Ref ref) {
    return scoringRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScoringRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScoringRepository>(value),
    );
  }
}

String _$scoringRepositoryHash() => r'7af156ca55a623b37c76e730fe3ad7dbff29f3dc';
