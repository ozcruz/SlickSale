// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TranscriptMessage _$TranscriptMessageFromJson(Map<String, dynamic> json) =>
    _TranscriptMessage(
      role: json['role'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$TranscriptMessageToJson(_TranscriptMessage instance) =>
    <String, dynamic>{'role': instance.role, 'content': instance.content};

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
  id: json['id'] as String,
  scenarioId: json['scenarioId'] as String,
  scenarioName: json['scenarioName'] as String,
  timestamp: const TimestampConverter().fromJson(json['timestamp'] as Object),
  overallScore: (json['overallScore'] as num).toDouble(),
  categoryScores: (json['categoryScores'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  feedbackSummary: json['feedbackSummary'] as String,
  tips:
      (json['tips'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  transcript:
      (json['transcript'] as List<dynamic>?)
          ?.map((e) => TranscriptMessage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TranscriptMessage>[],
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'id': instance.id,
  'scenarioId': instance.scenarioId,
  'scenarioName': instance.scenarioName,
  'timestamp': const TimestampConverter().toJson(instance.timestamp),
  'overallScore': instance.overallScore,
  'categoryScores': instance.categoryScores,
  'feedbackSummary': instance.feedbackSummary,
  'tips': instance.tips,
  'transcript': instance.transcript,
};
