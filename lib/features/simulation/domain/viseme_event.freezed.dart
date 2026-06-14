// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'viseme_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VisemeEvent {

 String get id; int get startMs; int get durationMs; int get sentenceIndex;
/// Create a copy of VisemeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisemeEventCopyWith<VisemeEvent> get copyWith => _$VisemeEventCopyWithImpl<VisemeEvent>(this as VisemeEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisemeEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.startMs, startMs) || other.startMs == startMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.sentenceIndex, sentenceIndex) || other.sentenceIndex == sentenceIndex));
}


@override
int get hashCode => Object.hash(runtimeType,id,startMs,durationMs,sentenceIndex);

@override
String toString() {
  return 'VisemeEvent(id: $id, startMs: $startMs, durationMs: $durationMs, sentenceIndex: $sentenceIndex)';
}


}

/// @nodoc
abstract mixin class $VisemeEventCopyWith<$Res>  {
  factory $VisemeEventCopyWith(VisemeEvent value, $Res Function(VisemeEvent) _then) = _$VisemeEventCopyWithImpl;
@useResult
$Res call({
 String id, int startMs, int durationMs, int sentenceIndex
});




}
/// @nodoc
class _$VisemeEventCopyWithImpl<$Res>
    implements $VisemeEventCopyWith<$Res> {
  _$VisemeEventCopyWithImpl(this._self, this._then);

  final VisemeEvent _self;
  final $Res Function(VisemeEvent) _then;

/// Create a copy of VisemeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? startMs = null,Object? durationMs = null,Object? sentenceIndex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startMs: null == startMs ? _self.startMs : startMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,sentenceIndex: null == sentenceIndex ? _self.sentenceIndex : sentenceIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VisemeEvent].
extension VisemeEventPatterns on VisemeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisemeEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisemeEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisemeEvent value)  $default,){
final _that = this;
switch (_that) {
case _VisemeEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisemeEvent value)?  $default,){
final _that = this;
switch (_that) {
case _VisemeEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int startMs,  int durationMs,  int sentenceIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisemeEvent() when $default != null:
return $default(_that.id,_that.startMs,_that.durationMs,_that.sentenceIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int startMs,  int durationMs,  int sentenceIndex)  $default,) {final _that = this;
switch (_that) {
case _VisemeEvent():
return $default(_that.id,_that.startMs,_that.durationMs,_that.sentenceIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int startMs,  int durationMs,  int sentenceIndex)?  $default,) {final _that = this;
switch (_that) {
case _VisemeEvent() when $default != null:
return $default(_that.id,_that.startMs,_that.durationMs,_that.sentenceIndex);case _:
  return null;

}
}

}

/// @nodoc


class _VisemeEvent implements VisemeEvent {
  const _VisemeEvent({required this.id, required this.startMs, required this.durationMs, required this.sentenceIndex});
  

@override final  String id;
@override final  int startMs;
@override final  int durationMs;
@override final  int sentenceIndex;

/// Create a copy of VisemeEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisemeEventCopyWith<_VisemeEvent> get copyWith => __$VisemeEventCopyWithImpl<_VisemeEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisemeEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.startMs, startMs) || other.startMs == startMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.sentenceIndex, sentenceIndex) || other.sentenceIndex == sentenceIndex));
}


@override
int get hashCode => Object.hash(runtimeType,id,startMs,durationMs,sentenceIndex);

@override
String toString() {
  return 'VisemeEvent(id: $id, startMs: $startMs, durationMs: $durationMs, sentenceIndex: $sentenceIndex)';
}


}

/// @nodoc
abstract mixin class _$VisemeEventCopyWith<$Res> implements $VisemeEventCopyWith<$Res> {
  factory _$VisemeEventCopyWith(_VisemeEvent value, $Res Function(_VisemeEvent) _then) = __$VisemeEventCopyWithImpl;
@override @useResult
$Res call({
 String id, int startMs, int durationMs, int sentenceIndex
});




}
/// @nodoc
class __$VisemeEventCopyWithImpl<$Res>
    implements _$VisemeEventCopyWith<$Res> {
  __$VisemeEventCopyWithImpl(this._self, this._then);

  final _VisemeEvent _self;
  final $Res Function(_VisemeEvent) _then;

/// Create a copy of VisemeEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? startMs = null,Object? durationMs = null,Object? sentenceIndex = null,}) {
  return _then(_VisemeEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startMs: null == startMs ? _self.startMs : startMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,sentenceIndex: null == sentenceIndex ? _self.sentenceIndex : sentenceIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
