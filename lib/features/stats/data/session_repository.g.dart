// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sessionRepository)
final sessionRepositoryProvider = SessionRepositoryProvider._();

final class SessionRepositoryProvider
    extends
        $FunctionalProvider<
          SessionRepository,
          SessionRepository,
          SessionRepository
        >
    with $Provider<SessionRepository> {
  SessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<SessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SessionRepository create(Ref ref) {
    return sessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionRepository>(value),
    );
  }
}

String _$sessionRepositoryHash() => r'b3a0cccdaae2dc981aa206c810b520afb8f3f531';

/// Live newest-first history for the signed-in user; empty list when signed
/// out (dashboard routes are auth-gated, so that only spans sign-out races).

@ProviderFor(sessions)
final sessionsProvider = SessionsProvider._();

/// Live newest-first history for the signed-in user; empty list when signed
/// out (dashboard routes are auth-gated, so that only spans sign-out races).

final class SessionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Session>>,
          List<Session>,
          Stream<List<Session>>
        >
    with $FutureModifier<List<Session>>, $StreamProvider<List<Session>> {
  /// Live newest-first history for the signed-in user; empty list when signed
  /// out (dashboard routes are auth-gated, so that only spans sign-out races).
  SessionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionsHash();

  @$internal
  @override
  $StreamProviderElement<List<Session>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Session>> create(Ref ref) {
    return sessions(ref);
  }
}

String _$sessionsHash() => r'167787d622447464ad0bc5e8e27763c288561a60';

/// One session document (scorecard screen). Null when missing or signed out.

@ProviderFor(session)
final sessionProvider = SessionFamily._();

/// One session document (scorecard screen). Null when missing or signed out.

final class SessionProvider
    extends
        $FunctionalProvider<AsyncValue<Session?>, Session?, FutureOr<Session?>>
    with $FutureModifier<Session?>, $FutureProvider<Session?> {
  /// One session document (scorecard screen). Null when missing or signed out.
  SessionProvider._({
    required SessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionHash();

  @override
  String toString() {
    return r'sessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Session?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Session?> create(Ref ref) {
    final argument = this.argument as String;
    return session(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionHash() => r'a14363ed5e99f4b7c85003c3304eaaa350d757ea';

/// One session document (scorecard screen). Null when missing or signed out.

final class SessionFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Session?>, String> {
  SessionFamily._()
    : super(
        retry: null,
        name: r'sessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One session document (scorecard screen). Null when missing or signed out.

  SessionProvider call(String sessionId) =>
      SessionProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'sessionProvider';
}
