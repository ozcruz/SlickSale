import 'package:freezed_annotation/freezed_annotation.dart';

part 'viseme_event.freezed.dart';

/// A single mouth shape with timing, relative to the start of its sentence's
/// audio. [id] is one of REST/AA/EE/MM/FF/OO/LL/SS (the 8 Rive visemes);
/// [sentenceIndex] ties it to the matching [AudioChunk] so the scheduler only
/// animates a sentence once its audio actually starts playing.
@freezed
abstract class VisemeEvent with _$VisemeEvent {
  const factory VisemeEvent({
    required String id,
    required int startMs,
    required int durationMs,
    required int sentenceIndex,
  }) = _VisemeEvent;
}
