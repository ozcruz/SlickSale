// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TranscriptMessage {

 String get role; String get content;
/// Create a copy of TranscriptMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscriptMessageCopyWith<TranscriptMessage> get copyWith => _$TranscriptMessageCopyWithImpl<TranscriptMessage>(this as TranscriptMessage, _$identity);

  /// Serializes this TranscriptMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscriptMessage&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,content);

@override
String toString() {
  return 'TranscriptMessage(role: $role, content: $content)';
}


}

/// @nodoc
abstract mixin class $TranscriptMessageCopyWith<$Res>  {
  factory $TranscriptMessageCopyWith(TranscriptMessage value, $Res Function(TranscriptMessage) _then) = _$TranscriptMessageCopyWithImpl;
@useResult
$Res call({
 String role, String content
});




}
/// @nodoc
class _$TranscriptMessageCopyWithImpl<$Res>
    implements $TranscriptMessageCopyWith<$Res> {
  _$TranscriptMessageCopyWithImpl(this._self, this._then);

  final TranscriptMessage _self;
  final $Res Function(TranscriptMessage) _then;

/// Create a copy of TranscriptMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? content = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TranscriptMessage].
extension TranscriptMessagePatterns on TranscriptMessage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranscriptMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranscriptMessage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranscriptMessage value)  $default,){
final _that = this;
switch (_that) {
case _TranscriptMessage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranscriptMessage value)?  $default,){
final _that = this;
switch (_that) {
case _TranscriptMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranscriptMessage() when $default != null:
return $default(_that.role,_that.content);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role,  String content)  $default,) {final _that = this;
switch (_that) {
case _TranscriptMessage():
return $default(_that.role,_that.content);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role,  String content)?  $default,) {final _that = this;
switch (_that) {
case _TranscriptMessage() when $default != null:
return $default(_that.role,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TranscriptMessage implements TranscriptMessage {
  const _TranscriptMessage({required this.role, required this.content});
  factory _TranscriptMessage.fromJson(Map<String, dynamic> json) => _$TranscriptMessageFromJson(json);

@override final  String role;
@override final  String content;

/// Create a copy of TranscriptMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranscriptMessageCopyWith<_TranscriptMessage> get copyWith => __$TranscriptMessageCopyWithImpl<_TranscriptMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranscriptMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranscriptMessage&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,content);

@override
String toString() {
  return 'TranscriptMessage(role: $role, content: $content)';
}


}

/// @nodoc
abstract mixin class _$TranscriptMessageCopyWith<$Res> implements $TranscriptMessageCopyWith<$Res> {
  factory _$TranscriptMessageCopyWith(_TranscriptMessage value, $Res Function(_TranscriptMessage) _then) = __$TranscriptMessageCopyWithImpl;
@override @useResult
$Res call({
 String role, String content
});




}
/// @nodoc
class __$TranscriptMessageCopyWithImpl<$Res>
    implements _$TranscriptMessageCopyWith<$Res> {
  __$TranscriptMessageCopyWithImpl(this._self, this._then);

  final _TranscriptMessage _self;
  final $Res Function(_TranscriptMessage) _then;

/// Create a copy of TranscriptMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? content = null,}) {
  return _then(_TranscriptMessage(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Session {

 String get id; String get scenarioId; String get scenarioName;@TimestampConverter() DateTime get timestamp;/// 0-100.
 double get overallScore;/// Keyed by [ScoreCategory.key], values 0-100.
 Map<String, double> get categoryScores;/// AI coach prose summary.
 String get feedbackSummary;/// Numbered, conversation-specific coaching tips (backend `tips`).
 List<String> get tips; List<TranscriptMessage> get transcript;
/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCopyWith<Session> get copyWith => _$SessionCopyWithImpl<Session>(this as Session, _$identity);

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Session&&(identical(other.id, id) || other.id == id)&&(identical(other.scenarioId, scenarioId) || other.scenarioId == scenarioId)&&(identical(other.scenarioName, scenarioName) || other.scenarioName == scenarioName)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.overallScore, overallScore) || other.overallScore == overallScore)&&const DeepCollectionEquality().equals(other.categoryScores, categoryScores)&&(identical(other.feedbackSummary, feedbackSummary) || other.feedbackSummary == feedbackSummary)&&const DeepCollectionEquality().equals(other.tips, tips)&&const DeepCollectionEquality().equals(other.transcript, transcript));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scenarioId,scenarioName,timestamp,overallScore,const DeepCollectionEquality().hash(categoryScores),feedbackSummary,const DeepCollectionEquality().hash(tips),const DeepCollectionEquality().hash(transcript));

@override
String toString() {
  return 'Session(id: $id, scenarioId: $scenarioId, scenarioName: $scenarioName, timestamp: $timestamp, overallScore: $overallScore, categoryScores: $categoryScores, feedbackSummary: $feedbackSummary, tips: $tips, transcript: $transcript)';
}


}

/// @nodoc
abstract mixin class $SessionCopyWith<$Res>  {
  factory $SessionCopyWith(Session value, $Res Function(Session) _then) = _$SessionCopyWithImpl;
@useResult
$Res call({
 String id, String scenarioId, String scenarioName,@TimestampConverter() DateTime timestamp, double overallScore, Map<String, double> categoryScores, String feedbackSummary, List<String> tips, List<TranscriptMessage> transcript
});




}
/// @nodoc
class _$SessionCopyWithImpl<$Res>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._self, this._then);

  final Session _self;
  final $Res Function(Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scenarioId = null,Object? scenarioName = null,Object? timestamp = null,Object? overallScore = null,Object? categoryScores = null,Object? feedbackSummary = null,Object? tips = null,Object? transcript = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scenarioId: null == scenarioId ? _self.scenarioId : scenarioId // ignore: cast_nullable_to_non_nullable
as String,scenarioName: null == scenarioName ? _self.scenarioName : scenarioName // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,overallScore: null == overallScore ? _self.overallScore : overallScore // ignore: cast_nullable_to_non_nullable
as double,categoryScores: null == categoryScores ? _self.categoryScores : categoryScores // ignore: cast_nullable_to_non_nullable
as Map<String, double>,feedbackSummary: null == feedbackSummary ? _self.feedbackSummary : feedbackSummary // ignore: cast_nullable_to_non_nullable
as String,tips: null == tips ? _self.tips : tips // ignore: cast_nullable_to_non_nullable
as List<String>,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<TranscriptMessage>,
  ));
}

}


/// Adds pattern-matching-related methods to [Session].
extension SessionPatterns on Session {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Session value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Session value)  $default,){
final _that = this;
switch (_that) {
case _Session():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Session value)?  $default,){
final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String scenarioId,  String scenarioName, @TimestampConverter()  DateTime timestamp,  double overallScore,  Map<String, double> categoryScores,  String feedbackSummary,  List<String> tips,  List<TranscriptMessage> transcript)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.id,_that.scenarioId,_that.scenarioName,_that.timestamp,_that.overallScore,_that.categoryScores,_that.feedbackSummary,_that.tips,_that.transcript);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String scenarioId,  String scenarioName, @TimestampConverter()  DateTime timestamp,  double overallScore,  Map<String, double> categoryScores,  String feedbackSummary,  List<String> tips,  List<TranscriptMessage> transcript)  $default,) {final _that = this;
switch (_that) {
case _Session():
return $default(_that.id,_that.scenarioId,_that.scenarioName,_that.timestamp,_that.overallScore,_that.categoryScores,_that.feedbackSummary,_that.tips,_that.transcript);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String scenarioId,  String scenarioName, @TimestampConverter()  DateTime timestamp,  double overallScore,  Map<String, double> categoryScores,  String feedbackSummary,  List<String> tips,  List<TranscriptMessage> transcript)?  $default,) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.id,_that.scenarioId,_that.scenarioName,_that.timestamp,_that.overallScore,_that.categoryScores,_that.feedbackSummary,_that.tips,_that.transcript);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Session implements Session {
  const _Session({required this.id, required this.scenarioId, required this.scenarioName, @TimestampConverter() required this.timestamp, required this.overallScore, required final  Map<String, double> categoryScores, required this.feedbackSummary, final  List<String> tips = const <String>[], final  List<TranscriptMessage> transcript = const <TranscriptMessage>[]}): _categoryScores = categoryScores,_tips = tips,_transcript = transcript;
  factory _Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

@override final  String id;
@override final  String scenarioId;
@override final  String scenarioName;
@override@TimestampConverter() final  DateTime timestamp;
/// 0-100.
@override final  double overallScore;
/// Keyed by [ScoreCategory.key], values 0-100.
 final  Map<String, double> _categoryScores;
/// Keyed by [ScoreCategory.key], values 0-100.
@override Map<String, double> get categoryScores {
  if (_categoryScores is EqualUnmodifiableMapView) return _categoryScores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categoryScores);
}

/// AI coach prose summary.
@override final  String feedbackSummary;
/// Numbered, conversation-specific coaching tips (backend `tips`).
 final  List<String> _tips;
/// Numbered, conversation-specific coaching tips (backend `tips`).
@override@JsonKey() List<String> get tips {
  if (_tips is EqualUnmodifiableListView) return _tips;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tips);
}

 final  List<TranscriptMessage> _transcript;
@override@JsonKey() List<TranscriptMessage> get transcript {
  if (_transcript is EqualUnmodifiableListView) return _transcript;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transcript);
}


/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCopyWith<_Session> get copyWith => __$SessionCopyWithImpl<_Session>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Session&&(identical(other.id, id) || other.id == id)&&(identical(other.scenarioId, scenarioId) || other.scenarioId == scenarioId)&&(identical(other.scenarioName, scenarioName) || other.scenarioName == scenarioName)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.overallScore, overallScore) || other.overallScore == overallScore)&&const DeepCollectionEquality().equals(other._categoryScores, _categoryScores)&&(identical(other.feedbackSummary, feedbackSummary) || other.feedbackSummary == feedbackSummary)&&const DeepCollectionEquality().equals(other._tips, _tips)&&const DeepCollectionEquality().equals(other._transcript, _transcript));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scenarioId,scenarioName,timestamp,overallScore,const DeepCollectionEquality().hash(_categoryScores),feedbackSummary,const DeepCollectionEquality().hash(_tips),const DeepCollectionEquality().hash(_transcript));

@override
String toString() {
  return 'Session(id: $id, scenarioId: $scenarioId, scenarioName: $scenarioName, timestamp: $timestamp, overallScore: $overallScore, categoryScores: $categoryScores, feedbackSummary: $feedbackSummary, tips: $tips, transcript: $transcript)';
}


}

/// @nodoc
abstract mixin class _$SessionCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$SessionCopyWith(_Session value, $Res Function(_Session) _then) = __$SessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String scenarioId, String scenarioName,@TimestampConverter() DateTime timestamp, double overallScore, Map<String, double> categoryScores, String feedbackSummary, List<String> tips, List<TranscriptMessage> transcript
});




}
/// @nodoc
class __$SessionCopyWithImpl<$Res>
    implements _$SessionCopyWith<$Res> {
  __$SessionCopyWithImpl(this._self, this._then);

  final _Session _self;
  final $Res Function(_Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scenarioId = null,Object? scenarioName = null,Object? timestamp = null,Object? overallScore = null,Object? categoryScores = null,Object? feedbackSummary = null,Object? tips = null,Object? transcript = null,}) {
  return _then(_Session(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scenarioId: null == scenarioId ? _self.scenarioId : scenarioId // ignore: cast_nullable_to_non_nullable
as String,scenarioName: null == scenarioName ? _self.scenarioName : scenarioName // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,overallScore: null == overallScore ? _self.overallScore : overallScore // ignore: cast_nullable_to_non_nullable
as double,categoryScores: null == categoryScores ? _self._categoryScores : categoryScores // ignore: cast_nullable_to_non_nullable
as Map<String, double>,feedbackSummary: null == feedbackSummary ? _self.feedbackSummary : feedbackSummary // ignore: cast_nullable_to_non_nullable
as String,tips: null == tips ? _self._tips : tips // ignore: cast_nullable_to_non_nullable
as List<String>,transcript: null == transcript ? _self._transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<TranscriptMessage>,
  ));
}


}

// dart format on
