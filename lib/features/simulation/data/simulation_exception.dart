/// A backend/voice failure whose [message] is safe to show directly in a
/// snackbar — raw exception strings never reach the UI. Mirrors the
/// AuthException pattern used in the auth feature.
class SimulationException implements Exception {
  const SimulationException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The user denied microphone access (or the browser blocked it). The screen
/// shows a dedicated "enable mic" affordance rather than a transient snackbar.
class MicPermissionException extends SimulationException {
  const MicPermissionException()
    : super(
        'Microphone access is needed to practice. '
        'Enable it in your browser and try again.',
      );
}
