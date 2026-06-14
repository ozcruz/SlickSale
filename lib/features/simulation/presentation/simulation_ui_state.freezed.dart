// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'simulation_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SimulationUiState {

 SimulationState get status; List<ChatMessage> get messages;/// A recoverable error to surface as a snackbar (cleared once shown).
 String? get errorMessage;/// Mic permission was denied — the screen shows an "enable mic" affordance
/// instead of the normal mic button.
 bool get micDenied;/// The prospect closed/lost the deal ([SESSION_COMPLETE]); the mic is
/// disabled and the user is nudged to end the session for their score.
 bool get prospectEndedCall;
/// Create a copy of SimulationUiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SimulationUiStateCopyWith<SimulationUiState> get copyWith => _$SimulationUiStateCopyWithImpl<SimulationUiState>(this as SimulationUiState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SimulationUiState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.micDenied, micDenied) || other.micDenied == micDenied)&&(identical(other.prospectEndedCall, prospectEndedCall) || other.prospectEndedCall == prospectEndedCall));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(messages),errorMessage,micDenied,prospectEndedCall);

@override
String toString() {
  return 'SimulationUiState(status: $status, messages: $messages, errorMessage: $errorMessage, micDenied: $micDenied, prospectEndedCall: $prospectEndedCall)';
}


}

/// @nodoc
abstract mixin class $SimulationUiStateCopyWith<$Res>  {
  factory $SimulationUiStateCopyWith(SimulationUiState value, $Res Function(SimulationUiState) _then) = _$SimulationUiStateCopyWithImpl;
@useResult
$Res call({
 SimulationState status, List<ChatMessage> messages, String? errorMessage, bool micDenied, bool prospectEndedCall
});




}
/// @nodoc
class _$SimulationUiStateCopyWithImpl<$Res>
    implements $SimulationUiStateCopyWith<$Res> {
  _$SimulationUiStateCopyWithImpl(this._self, this._then);

  final SimulationUiState _self;
  final $Res Function(SimulationUiState) _then;

/// Create a copy of SimulationUiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? messages = null,Object? errorMessage = freezed,Object? micDenied = null,Object? prospectEndedCall = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SimulationState,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,micDenied: null == micDenied ? _self.micDenied : micDenied // ignore: cast_nullable_to_non_nullable
as bool,prospectEndedCall: null == prospectEndedCall ? _self.prospectEndedCall : prospectEndedCall // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SimulationUiState].
extension SimulationUiStatePatterns on SimulationUiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SimulationUiState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SimulationUiState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SimulationUiState value)  $default,){
final _that = this;
switch (_that) {
case _SimulationUiState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SimulationUiState value)?  $default,){
final _that = this;
switch (_that) {
case _SimulationUiState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SimulationState status,  List<ChatMessage> messages,  String? errorMessage,  bool micDenied,  bool prospectEndedCall)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SimulationUiState() when $default != null:
return $default(_that.status,_that.messages,_that.errorMessage,_that.micDenied,_that.prospectEndedCall);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SimulationState status,  List<ChatMessage> messages,  String? errorMessage,  bool micDenied,  bool prospectEndedCall)  $default,) {final _that = this;
switch (_that) {
case _SimulationUiState():
return $default(_that.status,_that.messages,_that.errorMessage,_that.micDenied,_that.prospectEndedCall);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SimulationState status,  List<ChatMessage> messages,  String? errorMessage,  bool micDenied,  bool prospectEndedCall)?  $default,) {final _that = this;
switch (_that) {
case _SimulationUiState() when $default != null:
return $default(_that.status,_that.messages,_that.errorMessage,_that.micDenied,_that.prospectEndedCall);case _:
  return null;

}
}

}

/// @nodoc


class _SimulationUiState extends SimulationUiState {
  const _SimulationUiState({required this.status, final  List<ChatMessage> messages = const <ChatMessage>[], this.errorMessage, this.micDenied = false, this.prospectEndedCall = false}): _messages = messages,super._();
  

@override final  SimulationState status;
 final  List<ChatMessage> _messages;
@override@JsonKey() List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

/// A recoverable error to surface as a snackbar (cleared once shown).
@override final  String? errorMessage;
/// Mic permission was denied — the screen shows an "enable mic" affordance
/// instead of the normal mic button.
@override@JsonKey() final  bool micDenied;
/// The prospect closed/lost the deal ([SESSION_COMPLETE]); the mic is
/// disabled and the user is nudged to end the session for their score.
@override@JsonKey() final  bool prospectEndedCall;

/// Create a copy of SimulationUiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SimulationUiStateCopyWith<_SimulationUiState> get copyWith => __$SimulationUiStateCopyWithImpl<_SimulationUiState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SimulationUiState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.micDenied, micDenied) || other.micDenied == micDenied)&&(identical(other.prospectEndedCall, prospectEndedCall) || other.prospectEndedCall == prospectEndedCall));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_messages),errorMessage,micDenied,prospectEndedCall);

@override
String toString() {
  return 'SimulationUiState(status: $status, messages: $messages, errorMessage: $errorMessage, micDenied: $micDenied, prospectEndedCall: $prospectEndedCall)';
}


}

/// @nodoc
abstract mixin class _$SimulationUiStateCopyWith<$Res> implements $SimulationUiStateCopyWith<$Res> {
  factory _$SimulationUiStateCopyWith(_SimulationUiState value, $Res Function(_SimulationUiState) _then) = __$SimulationUiStateCopyWithImpl;
@override @useResult
$Res call({
 SimulationState status, List<ChatMessage> messages, String? errorMessage, bool micDenied, bool prospectEndedCall
});




}
/// @nodoc
class __$SimulationUiStateCopyWithImpl<$Res>
    implements _$SimulationUiStateCopyWith<$Res> {
  __$SimulationUiStateCopyWithImpl(this._self, this._then);

  final _SimulationUiState _self;
  final $Res Function(_SimulationUiState) _then;

/// Create a copy of SimulationUiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? messages = null,Object? errorMessage = freezed,Object? micDenied = null,Object? prospectEndedCall = null,}) {
  return _then(_SimulationUiState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SimulationState,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,micDenied: null == micDenied ? _self.micDenied : micDenied // ignore: cast_nullable_to_non_nullable
as bool,prospectEndedCall: null == prospectEndedCall ? _self.prospectEndedCall : prospectEndedCall // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
