import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants.dart';
import '../domain/audio_chunk.dart';
import '../domain/chat_message.dart';
import '../domain/chat_stream_event.dart';
import '../domain/viseme_event.dart';
import 'backend.dart';
import 'simulation_exception.dart';

part 'sse_repository.g.dart';

/// Consumes the backend `POST /chat` Server-Sent Events stream and turns each
/// `event:` / `data:` pair into a typed [ChatStreamEvent]. The backend fires
/// `text_delta`, `audio_chunk`, and `viseme` events interleaved (TTS runs in
/// parallel with the LLM), terminated by `done`.
class SseChatRepository {
  SseChatRepository(this._client);

  final http.Client _client;

  Stream<ChatStreamEvent> connectToChat({
    required String text,
    required List<ChatMessage> history,
    required String scenarioId,
  }) async* {
    final request =
        http.Request('POST', Uri.parse('${AppConfig.backendBaseUrl}/chat'))
          ..headers['content-type'] = 'application/json'
          ..headers['accept'] = 'text/event-stream'
          ..body = jsonEncode({
            'text': text,
            'history': [
              for (final message in history)
                {'role': message.role.name, 'content': message.content},
            ],
            'scenario_id': scenarioId,
          });

    final http.StreamedResponse response;
    try {
      response = await _client.send(request);
    } catch (_) {
      throw const SimulationException(
        "Couldn't reach your coach. Check your connection and try again.",
      );
    }
    if (response.statusCode != 200) {
      throw SimulationException(
        'Your coach is unavailable right now (${response.statusCode}). '
        'Please try again.',
      );
    }

    // SSE frames are separated by a blank line; within a frame we collect the
    // `event:` name and one or more `data:` lines. Comment lines (`:` — the
    // keep-alive pings sse-starlette sends) and unknown events are ignored.
    String? eventName;
    final dataBuffer = <String>[];

    final lines = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());
    await for (final line in lines) {
      if (line.isEmpty) {
        final event = _decode(eventName, dataBuffer);
        eventName = null;
        dataBuffer.clear();
        if (event != null) yield event;
        continue;
      }
      if (line.startsWith(':')) continue;
      if (line.startsWith('event:')) {
        eventName = line.substring('event:'.length).trim();
      } else if (line.startsWith('data:')) {
        dataBuffer.add(line.substring('data:'.length).trimLeft());
      }
    }
    // Flush a trailing frame the stream closed before the blank-line separator.
    final tail = _decode(eventName, dataBuffer);
    if (tail != null) yield tail;
  }

  ChatStreamEvent? _decode(String? event, List<String> dataLines) {
    if (event == null || dataLines.isEmpty) return null;
    final Map<String, dynamic> data;
    try {
      data = jsonDecode(dataLines.join('\n')) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }

    switch (event) {
      case 'text_delta':
        return TextDeltaEvent((data['text'] as String?) ?? '');
      case 'audio_chunk':
        return AudioChunkEvent(
          AudioChunk(
            base64: (data['audio_b64'] as String?) ?? '',
            sentenceIndex: _asInt(data['sentence_index']),
          ),
        );
      case 'viseme':
        final sentenceIndex = _asInt(data['sentence_index']);
        final raw = (data['visemes'] as List?) ?? const [];
        return VisemeBatchEvent(sentenceIndex, [
          for (final item in raw)
            if (item is Map)
              VisemeEvent(
                id: (item['id'] as String?) ?? 'REST',
                startMs: _asInt(item['start_ms']),
                durationMs: _asInt(item['duration_ms']),
                sentenceIndex: sentenceIndex,
              ),
        ]);
      case 'audio_error':
        return AudioErrorEvent(
          _asInt(data['sentence_index']),
          (data['detail'] as String?) ?? 'audio failed',
        );
      case 'error':
        return StreamErrorEvent((data['detail'] as String?) ?? 'stream error');
      case 'session_complete':
        return SessionCompleteEvent((data['status'] as String?) ?? 'CLOSED');
      case 'done':
        return const DoneEvent();
      default:
        return null;
    }
  }

  static int _asInt(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;
}

@riverpod
SseChatRepository sseChatRepository(Ref ref) =>
    SseChatRepository(ref.watch(backendHttpClientProvider));
