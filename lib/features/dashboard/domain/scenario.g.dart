// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The launch catalog. Hard-coded for v1; difficulty doubles as each card's
/// visual accent (matching the mockup, where badge and accent colors agree).

@ProviderFor(scenarios)
final scenariosProvider = ScenariosProvider._();

/// The launch catalog. Hard-coded for v1; difficulty doubles as each card's
/// visual accent (matching the mockup, where badge and accent colors agree).

final class ScenariosProvider
    extends $FunctionalProvider<List<Scenario>, List<Scenario>, List<Scenario>>
    with $Provider<List<Scenario>> {
  /// The launch catalog. Hard-coded for v1; difficulty doubles as each card's
  /// visual accent (matching the mockup, where badge and accent colors agree).
  ScenariosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scenariosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scenariosHash();

  @$internal
  @override
  $ProviderElement<List<Scenario>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Scenario> create(Ref ref) {
    return scenarios(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Scenario> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Scenario>>(value),
    );
  }
}

String _$scenariosHash() => r'34b0b28aec6abc46aaae34fe7a8500b1512b4fc4';

/// Lookup by id; null for unknown ids (e.g. a hand-edited URL).

@ProviderFor(scenarioById)
final scenarioByIdProvider = ScenarioByIdFamily._();

/// Lookup by id; null for unknown ids (e.g. a hand-edited URL).

final class ScenarioByIdProvider
    extends $FunctionalProvider<Scenario?, Scenario?, Scenario?>
    with $Provider<Scenario?> {
  /// Lookup by id; null for unknown ids (e.g. a hand-edited URL).
  ScenarioByIdProvider._({
    required ScenarioByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'scenarioByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$scenarioByIdHash();

  @override
  String toString() {
    return r'scenarioByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Scenario?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Scenario? create(Ref ref) {
    final argument = this.argument as String;
    return scenarioById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Scenario? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Scenario?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ScenarioByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scenarioByIdHash() => r'a205407974618f011923930f09f47c230d15e920';

/// Lookup by id; null for unknown ids (e.g. a hand-edited URL).

final class ScenarioByIdFamily extends $Family
    with $FunctionalFamilyOverride<Scenario?, String> {
  ScenarioByIdFamily._()
    : super(
        retry: null,
        name: r'scenarioByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Lookup by id; null for unknown ids (e.g. a hand-edited URL).

  ScenarioByIdProvider call(String id) =>
      ScenarioByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'scenarioByIdProvider';
}
