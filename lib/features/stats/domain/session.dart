import 'package:freezed_annotation/freezed_annotation.dart';

import '../../auth/domain/app_user.dart' show TimestampConverter;

part 'session.freezed.dart';
part 'session.g.dart';

/// The five scored skill areas. [name] doubles as the key inside
/// `Session.categoryScores` (and matches the backend scoring schema).
enum ScoreCategory {
  objectionHandling('Objection Handling'),
  rapportBuilding('Rapport Building'),
  closingTechnique('Closing Technique'),
  discoveryQuestions('Discovery Questions'),
  activeListening('Active Listening');

  const ScoreCategory(this.label);

  final String label;

  String get key => name;
}

/// One turn of the practice conversation. [role] is 'user' (the seller) or
/// 'assistant' (the AI buyer).
@freezed
abstract class TranscriptMessage with _$TranscriptMessage {
  const factory TranscriptMessage({
    required String role,
    required String content,
  }) = _TranscriptMessage;

  factory TranscriptMessage.fromJson(Map<String, dynamic> json) =>
      _$TranscriptMessageFromJson(json);
}

/// A completed, scored practice session — the Firestore
/// `users/{uid}/sessions/{sessionId}` document.
@freezed
abstract class Session with _$Session {
  const factory Session({
    required String id,
    required String scenarioId,
    required String scenarioName,
    @TimestampConverter() required DateTime timestamp,

    /// 0-100.
    required double overallScore,

    /// Keyed by [ScoreCategory.key], values 0-100.
    required Map<String, double> categoryScores,

    /// AI coach prose summary.
    required String feedbackSummary,

    /// Numbered, conversation-specific coaching tips (backend `tips`).
    @Default(<String>[]) List<String> tips,
    @Default(<TranscriptMessage>[]) List<TranscriptMessage> transcript,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
