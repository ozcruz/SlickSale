import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_chunk.freezed.dart';

/// One sentence of synthesized speech: base64-encoded WAV bytes tagged with
/// the [sentenceIndex] that correlates it with its [VisemeEvent]s.
@freezed
abstract class AudioChunk with _$AudioChunk {
  const factory AudioChunk({
    required String base64,
    required int sentenceIndex,
  }) = _AudioChunk;
}
