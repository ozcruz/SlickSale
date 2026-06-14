// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_chunk.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudioChunk {

 String get base64; int get sentenceIndex;
/// Create a copy of AudioChunk
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioChunkCopyWith<AudioChunk> get copyWith => _$AudioChunkCopyWithImpl<AudioChunk>(this as AudioChunk, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioChunk&&(identical(other.base64, base64) || other.base64 == base64)&&(identical(other.sentenceIndex, sentenceIndex) || other.sentenceIndex == sentenceIndex));
}


@override
int get hashCode => Object.hash(runtimeType,base64,sentenceIndex);

@override
String toString() {
  return 'AudioChunk(base64: $base64, sentenceIndex: $sentenceIndex)';
}


}

/// @nodoc
abstract mixin class $AudioChunkCopyWith<$Res>  {
  factory $AudioChunkCopyWith(AudioChunk value, $Res Function(AudioChunk) _then) = _$AudioChunkCopyWithImpl;
@useResult
$Res call({
 String base64, int sentenceIndex
});




}
/// @nodoc
class _$AudioChunkCopyWithImpl<$Res>
    implements $AudioChunkCopyWith<$Res> {
  _$AudioChunkCopyWithImpl(this._self, this._then);

  final AudioChunk _self;
  final $Res Function(AudioChunk) _then;

/// Create a copy of AudioChunk
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? base64 = null,Object? sentenceIndex = null,}) {
  return _then(_self.copyWith(
base64: null == base64 ? _self.base64 : base64 // ignore: cast_nullable_to_non_nullable
as String,sentenceIndex: null == sentenceIndex ? _self.sentenceIndex : sentenceIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioChunk].
extension AudioChunkPatterns on AudioChunk {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioChunk value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioChunk() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioChunk value)  $default,){
final _that = this;
switch (_that) {
case _AudioChunk():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioChunk value)?  $default,){
final _that = this;
switch (_that) {
case _AudioChunk() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String base64,  int sentenceIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioChunk() when $default != null:
return $default(_that.base64,_that.sentenceIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String base64,  int sentenceIndex)  $default,) {final _that = this;
switch (_that) {
case _AudioChunk():
return $default(_that.base64,_that.sentenceIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String base64,  int sentenceIndex)?  $default,) {final _that = this;
switch (_that) {
case _AudioChunk() when $default != null:
return $default(_that.base64,_that.sentenceIndex);case _:
  return null;

}
}

}

/// @nodoc


class _AudioChunk implements AudioChunk {
  const _AudioChunk({required this.base64, required this.sentenceIndex});
  

@override final  String base64;
@override final  int sentenceIndex;

/// Create a copy of AudioChunk
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioChunkCopyWith<_AudioChunk> get copyWith => __$AudioChunkCopyWithImpl<_AudioChunk>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioChunk&&(identical(other.base64, base64) || other.base64 == base64)&&(identical(other.sentenceIndex, sentenceIndex) || other.sentenceIndex == sentenceIndex));
}


@override
int get hashCode => Object.hash(runtimeType,base64,sentenceIndex);

@override
String toString() {
  return 'AudioChunk(base64: $base64, sentenceIndex: $sentenceIndex)';
}


}

/// @nodoc
abstract mixin class _$AudioChunkCopyWith<$Res> implements $AudioChunkCopyWith<$Res> {
  factory _$AudioChunkCopyWith(_AudioChunk value, $Res Function(_AudioChunk) _then) = __$AudioChunkCopyWithImpl;
@override @useResult
$Res call({
 String base64, int sentenceIndex
});




}
/// @nodoc
class __$AudioChunkCopyWithImpl<$Res>
    implements _$AudioChunkCopyWith<$Res> {
  __$AudioChunkCopyWithImpl(this._self, this._then);

  final _AudioChunk _self;
  final $Res Function(_AudioChunk) _then;

/// Create a copy of AudioChunk
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? base64 = null,Object? sentenceIndex = null,}) {
  return _then(_AudioChunk(
base64: null == base64 ? _self.base64 : base64 // ignore: cast_nullable_to_non_nullable
as String,sentenceIndex: null == sentenceIndex ? _self.sentenceIndex : sentenceIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
