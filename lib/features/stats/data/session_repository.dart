import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/session.dart';

part 'session_repository.g.dart';

/// Firestore `users/{uid}/sessions` subcollection access.
class SessionRepository {
  SessionRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _sessions(String uid) =>
      _firestore.collection('users').doc(uid).collection('sessions');

  /// Saves under `session.id`, or a generated id when it's empty.
  /// Returns the stored id.
  Future<String> saveSession(String uid, Session session) async {
    final doc = session.id.isEmpty
        ? _sessions(uid).doc()
        : _sessions(uid).doc(session.id);
    await doc.set(session.copyWith(id: doc.id).toJson());
    return doc.id;
  }

  /// Newest-first session history. [limit] bounds the listener; v1 never
  /// needs more than this for stats, streaks, or history lists.
  Stream<List<Session>> watchSessions(String uid, {int limit = 50}) =>
      _sessions(uid)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => Session.fromJson(doc.data()))
                .toList(),
          );

  Future<Session?> getSession(String uid, String sessionId) async {
    final snapshot = await _sessions(uid).doc(sessionId).get();
    final data = snapshot.data();
    return data == null ? null : Session.fromJson(data);
  }
}

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) =>
    SessionRepository(ref.watch(firebaseFirestoreProvider));

/// Live newest-first history for the signed-in user; empty list when signed
/// out (dashboard routes are auth-gated, so that only spans sign-out races).
@riverpod
Stream<List<Session>> sessions(Ref ref) {
  final auth = ref.watch(authStateChangesProvider);
  if (auth.isLoading && !auth.hasValue) return const Stream.empty();
  final user = auth.value;
  if (user == null) return Stream.value(const []);
  return ref.watch(sessionRepositoryProvider).watchSessions(user.uid);
}

/// One session document (scorecard screen). Null when missing or signed out.
@riverpod
Future<Session?> session(Ref ref, String sessionId) async {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return null;
  return ref.watch(sessionRepositoryProvider).getSession(user.uid, sessionId);
}
