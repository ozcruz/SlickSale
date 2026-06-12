// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  experienceLevel: $enumDecode(
    _$ExperienceLevelEnumMap,
    json['experienceLevel'],
  ),
  industry: json['industry'] as String,
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
  onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'displayName': instance.displayName,
  'experienceLevel': _$ExperienceLevelEnumMap[instance.experienceLevel]!,
  'industry': instance.industry,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'totalSessions': instance.totalSessions,
  'onboardingCompleted': instance.onboardingCompleted,
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.beginner: 'beginner',
  ExperienceLevel.intermediate: 'intermediate',
  ExperienceLevel.advanced: 'advanced',
};
