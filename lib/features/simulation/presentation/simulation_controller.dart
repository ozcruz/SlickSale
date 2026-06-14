import 'dart:async';
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/data/auth_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../dashboard/domain/scenario.dart';
import '../../stats/data/session_repository.dart';
import '../../stats/domain/session.dart';
import '../data/audio_playback_manager.dart';
import '../data/audio_recorder.dart';
import '../data/scoring_repository.dart';
import '../data/simulation_exception.dart';
import '../data/sse_repository.dart';
import '../data/transcription_repository.dart';
import '../domain/chat_message.dart';
import '../domain/chat_stream_event.dart';
import '../domain/simulation_state.dart';
import '../domain/viseme.dart';
import 'rive_avatar_controller.dart';
import 'simulation_ui_state.dart';
import 'viseme_scheduler.dart';

part 'simulation_controller.g.dart';

/// Orchestrates the whole practice loop: warm up → listen → transcribe →
/// stream the prospect's reply (text + audio + visemes) → score on end.
///
/// Warmup note: the frontend only talks to the FastAPI backend (never Modal
/// directly, and there is no `/synthesize` proxy), so "warming up" is the
/// prospect's *opening turn* — a hidden kickoff `/chat` call. That covers the
/// Modal TTS cold start behind the warmup screen and matches the mockup, where
/// the prospect speaks first.
@riverpod
class SimulationController extends _$SimulationController {
  final RiveAvatarController _avatar = RiveAvatarController();
  final AudioRecorder _recorder = AudioRecorder();
  late final AudioPlaybackManager _playback;
  late final VisemeScheduler _scheduler;

  late String _scenarioId;
  Scenario? _scenario;

  StreamSubscription<ChatStreamEvent>? _chatSub;
  int? _assistantIndex;
  bool _streamDone = false;
  bool _turnFromWarmup = false;
  bool _disposed = false;

  /// Hidden first "user" message that makes the prospect open the conversation.
  /// Never shown in the chat log or sent to scoring.
  static const String _kickoffPrompt =
      "(You're now connected with the salesperson. Greet them and open the "
      'conversation in character — speak first, in one or two sentences.)';

  /// The avatar bridge the [RiveAvatar] widget binds to.
  RiveAvatarController get avatarController => _avatar;

  @override
  SimulationUiState build(String scenarioId) {
    _scenarioId = scenarioId;
    _playback = AudioPlaybackManager(
      onSentenceStart: _onSentenceStart,
      onIdle: _onPlaybackIdle,
    );
    _scheduler = VisemeScheduler(setViseme: _avatar.setViseme);
    ref.onDispose(_teardown);
    // Defer: state can't be mutated during build.
    Future.microtask(_init);
    return const SimulationUiState(status: SimulationState.loading);
  }

  // ---------------------------------------------------------------- init/warmup

  void _init() {
    if (_disposed) return;
    final scenario = ref.read(scenarioByIdProvider(_scenarioId));
    if (scenario == null) {
      state = state.copyWith(
        status: SimulationState.error,
        errorMessage: "We couldn't find that scenario.",
      );
      return;
    }
    _scenario = scenario;
    _warmUp();
  }

  void _warmUp() {
    state = state.copyWith(
      status: SimulationState.warmingUp,
      messages: const [],
      errorMessage: null,
      prospectEndedCall: false,
    );
    _runTurn(text: _kickoffPrompt, history: const [], fromWarmup: true);
  }

  /// Retry after a warmup failure (the full-screen error state).
  void retry() {
    if (state.status != SimulationState.error) return;
    _init();
  }

  // --------------------------------------------------------------------- mic

  /// Mic button tap: start recording when idle, stop + respond when listening.
  Future<void> toggleMic() async {
    if (state.prospectEndedCall) return;
    switch (state.status) {
      case SimulationState.ready:
        await _startListening();
      case SimulationState.listening:
        await _stopListeningAndRespond();
      case _:
        break; // Ignore taps mid-processing / mid-speech / warmup.
    }
  }

  Future<void> _startListening() async {
    try {
      await _recorder.start();
      if (_disposed) {
        _recorder.cancel();
        return;
      }
      state = state.copyWith(
        status: SimulationState.listening,
        micDenied: false,
        errorMessage: null,
      );
    } on MicPermissionException {
      if (!_disposed) state = state.copyWith(micDenied: true);
    } catch (error) {
      if (!_disposed) state = state.copyWith(errorMessage: _message(error));
    }
  }

  Future<void> _stopListeningAndRespond() async {
    state = state.copyWith(status: SimulationState.processing);

    final Uint8List bytes;
    try {
      bytes = await _recorder.stop();
    } catch (error) {
      _backToReady(_message(error));
      return;
    }
    if (_disposed) return;
    if (bytes.isEmpty) {
      _backToReady("I didn't catch that — try again.");
      return;
    }

    final String text;
    try {
      text = await ref
          .read(transcriptionRepositoryProvider)
          .transcribe(bytes, fileExtension: _recorder.fileExtension);
    } catch (error) {
      if (_disposed) return;
      _backToReady(_message(error));
      return;
    }
    if (_disposed) return;
    if (text.isEmpty) {
      _backToReady("I didn't catch that — try again.");
      return;
    }

    // History is everything before this turn; the spoken text is sent
    // separately as the current user message.
    final history = state.messages;
    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(
          role: ChatRole.user,
          content: text,
          timestamp: DateTime.now(),
        ),
      ],
    );
    _runTurn(text: text, history: history);
  }

  // ------------------------------------------------------------- chat streaming

  void _runTurn({
    required String text,
    required List<ChatMessage> history,
    bool fromWarmup = false,
  }) {
    // Each reply restarts audio/viseme state — the backend numbers sentences
    // from 0 per `/chat` call.
    _playback.stop();
    _scheduler.clear();
    _avatar.setViseme(restVisemeId);
    _streamDone = false;
    _turnFromWarmup = fromWarmup;

    final messages = [
      ...state.messages,
      ChatMessage(
        role: ChatRole.assistant,
        content: '',
        timestamp: DateTime.now(),
        isStreaming: true,
      ),
    ];
    _assistantIndex = messages.length - 1;
    state = state.copyWith(messages: messages);

    _chatSub?.cancel();
    _chatSub = ref
        .read(sseChatRepositoryProvider)
        .connectToChat(text: text, history: history, scenarioId: _scenarioId)
        .listen(
          _handleEvent,
          onError: (Object error) =>
              _handleTurnError(error, fromWarmup: _turnFromWarmup),
          cancelOnError: true,
        );
  }

  void _handleEvent(ChatStreamEvent event) {
    if (_disposed) return;
    switch (event) {
      case TextDeltaEvent(:final text):
        _appendAssistantText(text);
      case AudioChunkEvent(:final chunk):
        if (chunk.base64.isNotEmpty) _playback.enqueue(chunk);
      case VisemeBatchEvent(:final sentenceIndex, :final visemes):
        _scheduler.loadSentence(sentenceIndex, visemes);
      case AudioErrorEvent():
        // One sentence lost its audio; its text still shows. Nothing to do.
        break;
      case SessionCompleteEvent():
        state = state.copyWith(prospectEndedCall: true);
      case StreamErrorEvent():
        _handleTurnError(
          const SimulationException(
            'Your coach ran into a problem mid-reply. Please try again.',
          ),
          fromWarmup: _turnFromWarmup,
        );
      case DoneEvent():
        _streamDone = true;
        _markAssistantComplete();
        if (!_playback.isPlaying) _finishTurn();
    }
  }

  void _appendAssistantText(String delta) {
    final index = _assistantIndex;
    if (index == null || index >= state.messages.length) return;
    final messages = [...state.messages];
    final current = messages[index];
    messages[index] = current.copyWith(content: current.content + delta);
    state = state.copyWith(messages: messages);
    // First content covers the warmup cold start / "processing" wait.
    if (state.status == SimulationState.warmingUp ||
        state.status == SimulationState.processing) {
      state = state.copyWith(status: SimulationState.avatarSpeaking);
    }
  }

  void _markAssistantComplete() {
    final index = _assistantIndex;
    if (index == null || index >= state.messages.length) return;
    final messages = [...state.messages];
    final message = messages[index];
    if (message.content.trim().isEmpty) {
      // Nothing came through (e.g. all TTS failed and no text) — drop the bubble.
      messages.removeAt(index);
      _assistantIndex = null;
    } else {
      messages[index] = message.copyWith(isStreaming: false);
    }
    state = state.copyWith(messages: messages);
  }

  /// Fires when audio for a sentence actually begins — start its visemes and
  /// flip into the speaking state.
  void _onSentenceStart(int sentenceIndex) {
    if (_disposed) return;
    _scheduler.startSentence(sentenceIndex);
    if (state.status == SimulationState.warmingUp ||
        state.status == SimulationState.processing) {
      state = state.copyWith(status: SimulationState.avatarSpeaking);
    }
  }

  /// Fires when the audio queue drains; if the reply is also fully streamed the
  /// turn is over.
  void _onPlaybackIdle() {
    if (_disposed) return;
    _scheduler.rest();
    if (_streamDone) _finishTurn();
  }

  void _finishTurn() {
    if (_disposed) return;
    if (state.status == SimulationState.ended ||
        state.status == SimulationState.error) {
      return;
    }
    state = state.copyWith(status: SimulationState.ready);
  }

  void _handleTurnError(Object error, {required bool fromWarmup}) {
    if (_disposed) return;
    _chatSub?.cancel();
    _chatSub = null;
    _playback.stop();
    _scheduler.rest();
    _dropEmptyAssistantBubble();

    final message = _message(error);
    if (fromWarmup) {
      // No conversation yet — show the full-screen retry.
      state = state.copyWith(
        status: SimulationState.error,
        errorMessage: message,
      );
    } else {
      // Keep the conversation; surface a snackbar and let them speak again.
      state = state.copyWith(
        status: SimulationState.ready,
        errorMessage: message,
      );
    }
  }

  // ------------------------------------------------------------------ end/score

  /// Ends the session: stops everything, scores the conversation, persists it,
  /// and returns the new session id (null if there's nothing worth scoring).
  /// Throws [SimulationException] on a scoring/save failure so the screen can
  /// surface it and let the user retry.
  Future<String?> endSession() async {
    await _chatSub?.cancel();
    _chatSub = null;
    _recorder.cancel();
    _playback.stop();
    _scheduler.rest();
    state = state.copyWith(status: SimulationState.ended, errorMessage: null);

    final scenario = _scenario;
    final hasUserTurn = state.messages.any((m) => m.role == ChatRole.user);
    if (scenario == null || !hasUserTurn) {
      return null; // Nothing to score — the screen just pops back.
    }

    final uid = ref.read(authStateChangesProvider).value?.uid;
    if (uid == null) {
      state = state.copyWith(status: SimulationState.ready);
      throw const SimulationException(
        'You appear to be signed out. Please sign in again.',
      );
    }
    final experienceLevel =
        ref.read(currentUserProfileProvider).value?.experienceLevel.name ??
        'intermediate';

    final ScoreResult result;
    try {
      result = await ref
          .read(scoringRepositoryProvider)
          .score(
            history: state.messages,
            scenarioId: scenario.id,
            experienceLevel: experienceLevel,
          );
    } catch (error) {
      if (!_disposed) state = state.copyWith(status: SimulationState.ready);
      rethrow; // SimulationException with a user-safe message.
    }

    final session = Session(
      id: '',
      scenarioId: scenario.id,
      scenarioName: scenario.name,
      timestamp: DateTime.now(),
      overallScore: result.overallScore.clamp(0, 100).toDouble(),
      categoryScores: _normalizeCategoryScores(result.categoryScores),
      feedbackSummary: result.feedback,
      tips: result.tips,
      transcript: [
        for (final message in state.messages)
          TranscriptMessage(role: message.role.name, content: message.content),
      ],
    );

    try {
      return await ref
          .read(sessionRepositoryProvider)
          .saveSession(uid, session);
    } catch (_) {
      if (!_disposed) state = state.copyWith(status: SimulationState.ready);
      throw const SimulationException(
        "Couldn't save this session. Please try again.",
      );
    }
  }

  /// Maps the LLM's free-form category keys ("Objection Handling",
  /// "objection_handling", …) onto the app's canonical [ScoreCategory] keys.
  Map<String, double> _normalizeCategoryScores(Map<String, double> raw) {
    String normalize(String value) =>
        value.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');
    final byNormalized = {
      for (final entry in raw.entries) normalize(entry.key): entry.value,
    };
    return {
      for (final category in ScoreCategory.values)
        category.key:
            (byNormalized[normalize(category.label)] ??
                    byNormalized[normalize(category.name)] ??
                    0)
                .clamp(0, 100)
                .toDouble(),
    };
  }

  // --------------------------------------------------------------------- misc

  /// Clears the transient error after the screen has shown it.
  void clearError() {
    if (!_disposed && state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  void _backToReady(String error) {
    if (_disposed) return;
    state = state.copyWith(status: SimulationState.ready, errorMessage: error);
  }

  void _dropEmptyAssistantBubble() {
    final index = _assistantIndex;
    if (index != null &&
        index < state.messages.length &&
        state.messages[index].content.trim().isEmpty) {
      final messages = [...state.messages]..removeAt(index);
      _assistantIndex = null;
      state = state.copyWith(messages: messages);
    }
  }

  String _message(Object error) => error is SimulationException
      ? error.message
      : 'Something went wrong. Please try again.';

  void _teardown() {
    _disposed = true;
    _chatSub?.cancel();
    _chatSub = null;
    _recorder.dispose();
    _playback.dispose();
    _scheduler.dispose();
    _avatar.dispose();
  }
}
