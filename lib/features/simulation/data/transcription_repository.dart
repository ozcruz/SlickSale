import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants.dart';
import 'backend.dart';
import 'simulation_exception.dart';

part 'transcription_repository.g.dart';

/// Uploads recorded audio to the backend `POST /transcribe`, which forwards it
/// to Modal's self-hosted Whisper and returns the recognized text.
class TranscriptionRepository {
  TranscriptionRepository(this._client);

  final http.Client _client;

  /// [fileExtension] (webm/ogg/mp4) drives the upload filename — Modal picks the
  /// audio container from the filename suffix, so it must match the recording.
  Future<String> transcribe(
    Uint8List audioBytes, {
    required String fileExtension,
  }) async {
    final request =
        http.MultipartRequest(
            'POST',
            Uri.parse('${AppConfig.backendBaseUrl}/transcribe'),
          )
          ..files.add(
            http.MultipartFile.fromBytes(
              'file',
              audioBytes,
              filename: 'speech.$fileExtension',
            ),
          );

    final http.Response response;
    try {
      response = await http.Response.fromStream(await _client.send(request));
    } catch (_) {
      throw const SimulationException(
        "Couldn't reach the transcription service. Check your connection.",
      );
    }
    if (response.statusCode != 200) {
      throw const SimulationException(
        "Sorry, I couldn't make out what you said. Please try again.",
      );
    }

    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ((data['text'] as String?) ?? '').trim();
    } catch (_) {
      throw const SimulationException(
        'Got an unexpected response while transcribing. Please try again.',
      );
    }
  }
}

@riverpod
TranscriptionRepository transcriptionRepository(Ref ref) =>
    TranscriptionRepository(ref.watch(backendHttpClientProvider));
