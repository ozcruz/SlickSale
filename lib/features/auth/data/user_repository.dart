import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/firebase_providers.dart';
import '../domain/app_user.dart';
import 'auth_repository.dart';

part 'user_repository.g.dart';

/// Firestore `users` collection access.
class UserRepository {
  UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<void> createUserProfile(AppUser user) =>
      _users.doc(user.uid).set(user.toJson());

  Future<AppUser?> getUserProfile(String uid) async {
    final snapshot = await _users.doc(uid).get();
    final data = snapshot.data();
    return data == null ? null : AppUser.fromJson(data);
  }

  Future<void> updateUserProfile(AppUser user) =>
      _users.doc(user.uid).set(user.toJson(), SetOptions(merge: true));

  Stream<AppUser?> watchUserProfile(String uid) =>
      _users.doc(uid).snapshots().map((snapshot) {
        final data = snapshot.data();
        return data == null ? null : AppUser.fromJson(data);
      });
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) =>
    UserRepository(ref.watch(firebaseFirestoreProvider));

/// Profile of the signed-in user. Emits null when signed out or before
/// onboarding creates the document. keepAlive: it drives router redirects.
@Riverpod(keepAlive: true)
Stream<AppUser?> currentUserProfile(Ref ref) {
  final auth = ref.watch(authStateChangesProvider);
  // Auth still resolving: stay in loading (an empty stream never emits).
  if (auth.isLoading && !auth.hasValue) return const Stream.empty();
  final user = auth.value;
  if (user == null) return Stream.value(null);
  return ref.watch(userRepositoryProvider).watchUserProfile(user.uid);
}
