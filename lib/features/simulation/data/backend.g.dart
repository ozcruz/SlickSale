// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One shared HTTP client for every backend call (SSE chat, transcription,
/// scoring). On web `package:http` streams the response body incrementally
/// (via the Fetch ReadableStream reader), which is what makes the `/chat` SSE
/// stream arrive token-by-token rather than all at once.

@ProviderFor(backendHttpClient)
final backendHttpClientProvider = BackendHttpClientProvider._();

/// One shared HTTP client for every backend call (SSE chat, transcription,
/// scoring). On web `package:http` streams the response body incrementally
/// (via the Fetch ReadableStream reader), which is what makes the `/chat` SSE
/// stream arrive token-by-token rather than all at once.

final class BackendHttpClientProvider
    extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  /// One shared HTTP client for every backend call (SSE chat, transcription,
  /// scoring). On web `package:http` streams the response body incrementally
  /// (via the Fetch ReadableStream reader), which is what makes the `/chat` SSE
  /// stream arrive token-by-token rather than all at once.
  BackendHttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backendHttpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backendHttpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return backendHttpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<http.Client>(value),
    );
  }
}

String _$backendHttpClientHash() => r'9ae792d5be75385bed579ada9aa274683ef13eda';
