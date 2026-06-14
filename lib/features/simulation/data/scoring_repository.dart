import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants.dart';
import '../domain/chat_message.dart';
import 'backend.dart';
import 'simulation_exception.dart';

part 'scoring_repository.g.dart';

/// The backend `/score` response. Category keys come straight from the LLM
/// (e.g. "Objection Handling") and are normalized to the app's
/// `ScoreCategory` keys by the controller before persisting.
class ScoreResult {
  const ScoreResult({
    required this.overallScore,
    required this.categoryScores,
    required this.feedback,
    required this.tips,
  });

  final double overallScore;
  final Map<String, double> categoryScores;
  final String feedback;
  final List<String> tips;
}

/// Calls `POST /score` to grade a completed conversation.
class ScoringRepository {
  ScoringRepository(this._client);

  final http.Client _client;

  Future<ScoreResult> score({
    required List<ChatMessage> history,
    required String scenarioId,
    required String experienceLevel,
  }) async {
    final http.Response response;
    try {
      response = await _client.post(
        Uri.parse('${AppConfig.backendBaseUrl}/score'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'history': [
            for (final message in history)
              {'role': message.role.name, 'content': message.content},
          ],
          'scenario_id': scenarioId,
          'user_experience_level': experienceLevel,
        }),
      );
    } catch (_) {
      throw const SimulationException(
        "Couldn't reach the scoring service. Check your connection and try again.",
      );
    }
    if (response.statusCode != 200) {
      throw const SimulationException(
        "Couldn't score this session. Please try again.",
      );
    }

    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ScoreResult(
        overallScore: _asDouble(data['overall_score']),
        categoryScores: {
          for (final entry in (data['category_scores'] as Map? ?? {}).entries)
            '${entry.key}': _asDouble(entry.value),
        },
        feedback: (data['feedback'] as String?) ?? '',
        tips: [for (final tip in (data['tips'] as List? ?? const [])) '$tip'],
      );
    } catch (_) {
      throw const SimulationException(
        'Got an unexpected response while scoring. Please try again.',
      );
    }
  }

  static double _asDouble(Object? value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
}

@riverpod
ScoringRepository scoringRepository(Ref ref) =>
    ScoringRepository(ref.watch(backendHttpClientProvider));
