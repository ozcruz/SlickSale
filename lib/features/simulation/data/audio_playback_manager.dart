import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import '../domain/audio_chunk.dart';

/// Plays a queue of base64 WAV sentences back-to-back through an
/// `HTMLAudioElement` (more reliable on web than just_audio). Sentences play
/// in arrival order with no gap beyond the time it takes to swap the source.
///
/// - [onSentenceStart] fires the instant a sentence begins playing, carrying
///   its `sentenceIndex` so the viseme scheduler can start animating in sync.
/// - [onIdle] fires when the queue empties — the controller pairs it with the
///   SSE `done` event to know the avatar has finished its whole turn.
class AudioPlaybackManager {
  AudioPlaybackManager({this.onSentenceStart, this.onIdle});

  void Function(int sentenceIndex)? onSentenceStart;
  void Function()? onIdle;

  final List<AudioChunk> _queue = [];
  web.HTMLAudioElement? _audio;
  String? _objectUrl;
  bool _busy = false;
  bool _disposed = false;

  bool get isPlaying => _busy;

  /// Queues a sentence and starts playback if nothing is currently playing.
  void enqueue(AudioChunk chunk) {
    if (_disposed) return;
    _queue.add(chunk);
    if (!_busy) _playNext();
  }

  void _playNext() {
    if (_disposed) return;
    if (_queue.isEmpty) {
      _busy = false;
      onIdle?.call();
      return;
    }
    _busy = true;
    final chunk = _queue.removeAt(0);

    final Uint8List bytes;
    try {
      bytes = base64Decode(chunk.base64);
    } catch (_) {
      _playNext();
      return;
    }
    if (bytes.isEmpty) {
      _playNext();
      return;
    }

    _disposeAudio();
    final blob = web.Blob(
      <JSAny>[bytes.toJS].toJS,
      web.BlobPropertyBag(type: 'audio/wav'),
    );
    final url = web.URL.createObjectURL(blob);
    _objectUrl = url;

    final audio = web.HTMLAudioElement()
      ..src = url
      ..preload = 'auto';
    _audio = audio;
    audio.onended = ((web.Event _) => _playNext()).toJS;
    // A decode/playback error shouldn't stall the queue — skip to the next.
    audio.onerror = ((web.Event _) => _playNext()).toJS;

    onSentenceStart?.call(chunk.sentenceIndex);
    _safePlay(audio);
  }

  // play() can reject (autoplay policy, decode error). Swallow it so a single
  // bad sentence never stalls the queue; onended/onerror still drive progress.
  void _safePlay(web.HTMLAudioElement audio) {
    audio.play().toDart.then((_) {}, onError: (Object _) {});
  }

  /// Stops playback immediately and drops anything queued (End Session, errors,
  /// new turn). Does not fire [onIdle].
  void stop() {
    _queue.clear();
    _busy = false;
    final audio = _audio;
    if (audio != null) {
      audio.onended = null;
      audio.onerror = null;
      audio.pause();
    }
    _disposeAudio();
  }

  void _disposeAudio() {
    final url = _objectUrl;
    if (url != null) {
      web.URL.revokeObjectURL(url);
      _objectUrl = null;
    }
    _audio = null;
  }

  void dispose() {
    _disposed = true;
    stop();
    onSentenceStart = null;
    onIdle = null;
  }
}
