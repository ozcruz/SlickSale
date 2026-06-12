import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// Sales experience level chosen during onboarding.
enum ExperienceLevel {
  beginner,
  intermediate,
  advanced;

  String get label => switch (this) {
        ExperienceLevel.beginner => 'Beginner',
        ExperienceLevel.intermediate => 'Intermediate',
        ExperienceLevel.advanced => 'Advanced',
      };
}

/// The Firestore `users/{uid}` document.
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    required String displayName,
    required ExperienceLevel experienceLevel,
    required String industry,
    @TimestampConverter() required DateTime createdAt,
    @Default(0) int totalSessions,
    @Default(false) bool onboardingCompleted,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

/// Firestore stores DateTime as [Timestamp]; tolerate ISO strings so models
/// stay testable without Firestore.
class TimestampConverter implements JsonConverter<DateTime, Object> {
  const TimestampConverter();

  @override
  DateTime fromJson(Object json) => switch (json) {
        Timestamp() => json.toDate(),
        String() => DateTime.parse(json),
        _ => DateTime.fromMillisecondsSinceEpoch(0),
      };

  @override
  Object toJson(DateTime date) => Timestamp.fromDate(date);
}
