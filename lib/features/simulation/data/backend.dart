import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backend.g.dart';

/// One shared HTTP client for every backend call (SSE chat, transcription,
/// scoring). On web `package:http` streams the response body incrementally
/// (via the Fetch ReadableStream reader), which is what makes the `/chat` SSE
/// stream arrive token-by-token rather than all at once.
@Riverpod(keepAlive: true)
http.Client backendHttpClient(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
}
