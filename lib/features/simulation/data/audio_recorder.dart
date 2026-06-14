import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'simulation_exception.dart';

/// Microphone recorder for Flutter Web, built directly on `getUserMedia` +
/// `MediaRecorder`. Wrapped so the rest of the app never touches the browser
/// APIs — callers just [start] and [stop] and get bytes back. The app ships
/// web/CanvasKit only, so there is no non-web implementation to fall back to.
class AudioRecorder {
  web.MediaStream? _stream;
  web.MediaRecorder? _recorder;
  final List<web.Blob> _chunks = [];
  Completer<Uint8List>? _stopCompleter;
  String _mimeType = _defaultMimeType;

  static const String _defaultMimeType = 'audio/webm';

  // Preference order: Opus-in-WebM is compact and decodes cleanly in Whisper.
  static const List<String> _candidateMimeTypes = [
    'audio/webm;codecs=opus',
    'audio/webm',
    'audio/ogg;codecs=opus',
    'audio/mp4',
  ];

  bool get isRecording => _recorder != null;

  /// File extension matching the active recording's container — drives the
  /// upload filename so Modal decodes with the right demuxer.
  String get fileExtension {
    if (_mimeType.contains('ogg')) return 'ogg';
    if (_mimeType.contains('mp4')) return 'mp4';
    return 'webm';
  }

  /// Requests mic permission and starts recording.
  ///
  /// Throws [MicPermissionException] if the user denies access, and
  /// [SimulationException] for other capture failures.
  Future<void> start() async {
    if (_recorder != null) return;

    final web.MediaStream stream;
    try {
      stream = await web.window.navigator.mediaDevices
          .getUserMedia(web.MediaStreamConstraints(audio: true.toJS))
          .toDart;
    } catch (_) {
      throw const MicPermissionException();
    }

    _stream = stream;
    _chunks.clear();
    _mimeType = _pickMimeType();

    final web.MediaRecorder recorder;
    try {
      recorder = web.MediaRecorder(
        stream,
        _mimeType.isEmpty
            ? web.MediaRecorderOptions()
            : web.MediaRecorderOptions(mimeType: _mimeType),
      );
    } catch (_) {
      _releaseStream();
      throw const SimulationException(
        "This browser couldn't start recording. Try Chrome or Edge.",
      );
    }

    recorder.ondataavailable = ((web.BlobEvent event) {
      if (event.data.size > 0) _chunks.add(event.data);
    }).toJS;
    recorder.onstop = ((web.Event _) {
      unawaited(_finishStop());
    }).toJS;
    recorder.start();
    _recorder = recorder;
  }

  /// Stops recording and returns the captured audio bytes.
  Future<Uint8List> stop() async {
    final recorder = _recorder;
    if (recorder == null) return Uint8List(0);
    final completer = Completer<Uint8List>();
    _stopCompleter = completer;
    recorder.stop();
    return completer.future;
  }

  Future<void> _finishStop() async {
    final completer = _stopCompleter;
    _stopCompleter = null;
    try {
      final blob = web.Blob(
        <JSAny>[for (final chunk in _chunks) chunk].toJS,
        web.BlobPropertyBag(
          type: _mimeType.isEmpty ? _defaultMimeType : _mimeType,
        ),
      );
      final buffer = await blob.arrayBuffer().toDart;
      completer?.complete(buffer.toDart.asUint8List());
    } catch (_) {
      completer?.completeError(
        const SimulationException("Couldn't process the recording."),
      );
    } finally {
      _releaseStream();
    }
  }

  /// Abandons any in-progress recording (e.g. End Session mid-listen) without
  /// resolving [stop]'s future.
  void cancel() {
    final recorder = _recorder;
    _stopCompleter = null;
    if (recorder != null) {
      recorder.ondataavailable = null;
      recorder.onstop = null;
      try {
        recorder.stop();
      } catch (_) {
        // Already inactive — nothing to stop.
      }
    }
    _releaseStream();
  }

  void dispose() => cancel();

  static String _pickMimeType() {
    for (final type in _candidateMimeTypes) {
      if (web.MediaRecorder.isTypeSupported(type)) return type;
    }
    return '';
  }

  void _releaseStream() {
    final stream = _stream;
    if (stream != null) {
      for (final track in stream.getTracks().toDart) {
        track.stop();
      }
    }
    _stream = null;
    _recorder = null;
    _chunks.clear();
  }
}
