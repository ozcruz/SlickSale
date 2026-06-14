import 'audio_chunk.dart';
import 'viseme_event.dart';

/// Typed events parsed from the backend `/chat` SSE stream.
///
/// Named to mirror the backend's SSE event names: `text_delta`, `audio_chunk`,
/// `viseme`, `audio_error`, `error`, `session_complete`, `done`. The viseme
/// payload arrives as a per-sentence batch, hence [VisemeBatchEvent] (the
/// single-mouth-shape model is [VisemeEvent]).
sealed class ChatStreamEvent {
  const ChatStreamEvent();
}

/// A fragment of the prospect's reply text (already sentence-cleaned upstream).
class TextDeltaEvent extends ChatStreamEvent {
  const TextDeltaEvent(this.text);
  final String text;
}

/// Synthesized audio for one sentence, ready to queue for playback.
class AudioChunkEvent extends ChatStreamEvent {
  const AudioChunkEvent(this.chunk);
  final AudioChunk chunk;
}

/// All visemes for one sentence, ready to hand to the scheduler when that
/// sentence's audio begins.
class VisemeBatchEvent extends ChatStreamEvent {
  const VisemeBatchEvent(this.sentenceIndex, this.visemes);
  final int sentenceIndex;
  final List<VisemeEvent> visemes;
}

/// TTS failed for a single sentence; the rest of the reply still streams.
class AudioErrorEvent extends ChatStreamEvent {
  const AudioErrorEvent(this.sentenceIndex, this.detail);
  final int sentenceIndex;
  final String detail;
}

/// The LLM stream itself failed (surfaced to the user with a retry).
class StreamErrorEvent extends ChatStreamEvent {
  const StreamErrorEvent(this.detail);
  final String detail;
}

/// The prospect signalled the deal is closed/lost; the session can auto-end.
class SessionCompleteEvent extends ChatStreamEvent {
  const SessionCompleteEvent(this.status);

  /// 'CLOSED' or 'LOST'.
  final String status;
}

/// The reply is fully delivered; the user may speak again.
class DoneEvent extends ChatStreamEvent {
  const DoneEvent();
}
