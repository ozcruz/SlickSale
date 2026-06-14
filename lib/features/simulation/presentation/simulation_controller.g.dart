// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Orchestrates the whole practice loop: warm up → listen → transcribe →
/// stream the prospect's reply (text + audio + visemes) → score on end.
///
/// Warmup note: the frontend only talks to the FastAPI backend (never Modal
/// directly, and there is no `/synthesize` proxy), so "warming up" is the
/// prospect's *opening turn* — a hidden kickoff `/chat` call. That covers the
/// Modal TTS cold start behind the warmup screen and matches the mockup, where
/// the prospect speaks first.

@ProviderFor(SimulationController)
final simulationControllerProvider = SimulationControllerFamily._();

/// Orchestrates the whole practice loop: warm up → listen → transcribe →
/// stream the prospect's reply (text + audio + visemes) → score on end.
///
/// Warmup note: the frontend only talks to the FastAPI backend (never Modal
/// directly, and there is no `/synthesize` proxy), so "warming up" is the
/// prospect's *opening turn* — a hidden kickoff `/chat` call. That covers the
/// Modal TTS cold start behind the warmup screen and matches the mockup, where
/// the prospect speaks first.
final class SimulationControllerProvider
    extends $NotifierProvider<SimulationController, SimulationUiState> {
  /// Orchestrates the whole practice loop: warm up → listen → transcribe →
  /// stream the prospect's reply (text + audio + visemes) → score on end.
  ///
  /// Warmup note: the frontend only talks to the FastAPI backend (never Modal
  /// directly, and there is no `/synthesize` proxy), so "warming up" is the
  /// prospect's *opening turn* — a hidden kickoff `/chat` call. That covers the
  /// Modal TTS cold start behind the warmup screen and matches the mockup, where
  /// the prospect speaks first.
  SimulationControllerProvider._({
    required SimulationControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'simulationControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$simulationControllerHash();

  @override
  String toString() {
    return r'simulationControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SimulationController create() => SimulationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SimulationUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SimulationUiState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SimulationControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$simulationControllerHash() =>
    r'2eb039da8f85716902009eb08491cfd7d1ee0427';

/// Orchestrates the whole practice loop: warm up → listen → transcribe →
/// stream the prospect's reply (text + audio + visemes) → score on end.
///
/// Warmup note: the frontend only talks to the FastAPI backend (never Modal
/// directly, and there is no `/synthesize` proxy), so "warming up" is the
/// prospect's *opening turn* — a hidden kickoff `/chat` call. That covers the
/// Modal TTS cold start behind the warmup screen and matches the mockup, where
/// the prospect speaks first.

final class SimulationControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SimulationController,
          SimulationUiState,
          SimulationUiState,
          SimulationUiState,
          String
        > {
  SimulationControllerFamily._()
    : super(
        retry: null,
        name: r'simulationControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Orchestrates the whole practice loop: warm up → listen → transcribe →
  /// stream the prospect's reply (text + audio + visemes) → score on end.
  ///
  /// Warmup note: the frontend only talks to the FastAPI backend (never Modal
  /// directly, and there is no `/synthesize` proxy), so "warming up" is the
  /// prospect's *opening turn* — a hidden kickoff `/chat` call. That covers the
  /// Modal TTS cold start behind the warmup screen and matches the mockup, where
  /// the prospect speaks first.

  SimulationControllerProvider call(String scenarioId) =>
      SimulationControllerProvider._(argument: scenarioId, from: this);

  @override
  String toString() => r'simulationControllerProvider';
}

/// Orchestrates the whole practice loop: warm up → listen → transcribe →
/// stream the prospect's reply (text + audio + visemes) → score on end.
///
/// Warmup note: the frontend only talks to the FastAPI backend (never Modal
/// directly, and there is no `/synthesize` proxy), so "warming up" is the
/// prospect's *opening turn* — a hidden kickoff `/chat` call. That covers the
/// Modal TTS cold start behind the warmup screen and matches the mockup, where
/// the prospect speaks first.

abstract class _$SimulationController extends $Notifier<SimulationUiState> {
  late final _$args = ref.$arg as String;
  String get scenarioId => _$args;

  SimulationUiState build(String scenarioId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SimulationUiState, SimulationUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SimulationUiState, SimulationUiState>,
              SimulationUiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
