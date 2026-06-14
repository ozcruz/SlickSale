/// The phases of a practice simulation, driving every visual state on the
/// simulation screen. The controller moves through these in order:
/// loading → warmingUp → ready ⇄ listening → processing → avatarSpeaking → ready,
/// ending in [ended] (scoring) or [error] on an unrecoverable failure.
enum SimulationState {
  /// Resolving the scenario and spinning up the controller.
  loading,

  /// Priming the Modal cold start (the "Warming up your coach…" screen).
  warmingUp,

  /// Idle and waiting for the user to tap the mic.
  ready,

  /// Recording the user's microphone.
  listening,

  /// Transcribing speech and/or waiting on the AI's first token.
  processing,

  /// The avatar is talking — audio playing and visemes animating.
  avatarSpeaking,

  /// An unrecoverable error (the screen shows a retry affordance).
  error,

  /// The session is over; scoring runs and the scorecard loads.
  ended,
}
