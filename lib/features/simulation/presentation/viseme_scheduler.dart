import 'dart:async';

import '../domain/viseme.dart';
import '../domain/viseme_event.dart';

/// Drives the avatar's mouth shapes in time with audio playback.
///
/// All lip-sync timing lives here (per .claude/rules/rive-lipsync.md): viseme
/// batches arrive ahead of time via [loadSentence], and when that sentence's
/// audio actually starts playing the controller calls [startSentence], which
/// schedules one timer per viseme relative to the audio's start. Writing the
/// resulting ids is change-gated downstream (RiveAvatarController), so this
/// class only worries about *when* each shape fires.
class VisemeScheduler {
  VisemeScheduler({
    required this.setViseme,
    this.calibrationOffset = defaultCalibrationOffset,
  });

  /// Receives the integer viseme id to display now (0=REST … 7=SS).
  final void Function(int visemeId) setViseme;

  /// Nudges the whole schedule later to line lips up with audible sound.
  /// Starts at 80ms (tune by eye — see the rive-lipsync rule).
  final Duration calibrationOffset;

  static const Duration defaultCalibrationOffset = Duration(milliseconds: 80);

  final Map<int, List<VisemeEvent>> _bySentence = {};
  final List<Timer> _timers = [];

  /// Stores the visemes for [sentenceIndex] until its audio begins.
  void loadSentence(int sentenceIndex, List<VisemeEvent> visemes) {
    _bySentence[sentenceIndex] = visemes;
  }

  /// Begins animating [sentenceIndex] — call the moment its audio starts.
  void startSentence(int sentenceIndex) {
    _cancelTimers();
    final visemes = _bySentence[sentenceIndex];
    if (visemes == null || visemes.isEmpty) {
      setViseme(restVisemeId);
      return;
    }

    var lastEndMs = 0;
    for (final viseme in visemes) {
      final id = visemeIdFromName(viseme.id);
      _timers.add(
        Timer(
          Duration(milliseconds: viseme.startMs) + calibrationOffset,
          () => setViseme(id),
        ),
      );
      final endMs = viseme.startMs + viseme.durationMs;
      if (endMs > lastEndMs) lastEndMs = endMs;
    }
    // Close the mouth once the sentence has finished.
    _timers.add(
      Timer(
        Duration(milliseconds: lastEndMs) + calibrationOffset,
        () => setViseme(restVisemeId),
      ),
    );
  }

  /// Cancels any in-flight animation and rests the mouth (turn end, errors).
  void rest() {
    _cancelTimers();
    setViseme(restVisemeId);
  }

  /// Drops everything — used at the start of each new turn (the backend resets
  /// sentence indices to 0 per reply) and on teardown.
  void clear() {
    _cancelTimers();
    _bySentence.clear();
  }

  void dispose() {
    clear();
    setViseme(restVisemeId);
  }

  void _cancelTimers() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }
}
