import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/chat_message.dart';
import '../domain/simulation_state.dart';

part 'simulation_ui_state.freezed.dart';

/// Everything the simulation screen renders from. The orchestration logic lives
/// in SimulationController; this is the immutable snapshot it publishes.
@freezed
abstract class SimulationUiState with _$SimulationUiState {
  const factory SimulationUiState({
    required SimulationState status,
    @Default(<ChatMessage>[]) List<ChatMessage> messages,

    /// A recoverable error to surface as a snackbar (cleared once shown).
    String? errorMessage,

    /// Mic permission was denied — the screen shows an "enable mic" affordance
    /// instead of the normal mic button.
    @Default(false) bool micDenied,

    /// The prospect closed/lost the deal ([SESSION_COMPLETE]); the mic is
    /// disabled and the user is nudged to end the session for their score.
    @Default(false) bool prospectEndedCall,
  }) = _SimulationUiState;

  const SimulationUiState._();

  /// Currently capturing the microphone.
  bool get isListening => status == SimulationState.listening;

  /// Transcribing or waiting on the AI's first token.
  bool get isProcessing => status == SimulationState.processing;

  /// The mic button is interactive (idle, or already recording).
  bool get canToggleMic =>
      !prospectEndedCall &&
      (status == SimulationState.ready || status == SimulationState.listening);
}
