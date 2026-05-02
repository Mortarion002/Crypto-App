// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kline_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KlinePoint {

 DateTime get timestamp; double get open; double get high; double get low; double get close; double get volume;
/// Create a copy of KlinePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KlinePointCopyWith<KlinePoint> get copyWith => _$KlinePointCopyWithImpl<KlinePoint>(this as KlinePoint, _$identity);

  /// Serializes this KlinePoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KlinePoint&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.open, open) || other.open == open)&&(identical(other.high, high) || other.high == high)&&(identical(other.low, low) || other.low == low)&&(identical(other.close, close) || other.close == close)&&(identical(other.volume, volume) || other.volume == volume));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,open,high,low,close,volume);

@override
String toString() {
  return 'KlinePoint(timestamp: $timestamp, open: $open, high: $high, low: $low, close: $close, volume: $volume)';
}


}

/// @nodoc
abstract mixin class $KlinePointCopyWith<$Res>  {
  factory $KlinePointCopyWith(KlinePoint value, $Res Function(KlinePoint) _then) = _$KlinePointCopyWithImpl;
@useResult
$Res call({
 DateTime timestamp, double open, double high, double low, double close, double volume
});




}
/// @nodoc
class _$KlinePointCopyWithImpl<$Res>
    implements $KlinePointCopyWith<$Res> {
  _$KlinePointCopyWithImpl(this._self, this._then);

  final KlinePoint _self;
  final $Res Function(KlinePoint) _then;

/// Create a copy of KlinePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timestamp = null,Object? open = null,Object? high = null,Object? low = null,Object? close = null,Object? volume = null,}) {
  return _then(_self.copyWith(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,open: null == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as double,high: null == high ? _self.high : high // ignore: cast_nullable_to_non_nullable
as double,low: null == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as double,close: null == close ? _self.close : close // ignore: cast_nullable_to_non_nullable
as double,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [KlinePoint].
extension KlinePointPatterns on KlinePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KlinePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KlinePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KlinePoint value)  $default,){
final _that = this;
switch (_that) {
case _KlinePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KlinePoint value)?  $default,){
final _that = this;
switch (_that) {
case _KlinePoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime timestamp,  double open,  double high,  double low,  double close,  double volume)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KlinePoint() when $default != null:
return $default(_that.timestamp,_that.open,_that.high,_that.low,_that.close,_that.volume);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime timestamp,  double open,  double high,  double low,  double close,  double volume)  $default,) {final _that = this;
switch (_that) {
case _KlinePoint():
return $default(_that.timestamp,_that.open,_that.high,_that.low,_that.close,_that.volume);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime timestamp,  double open,  double high,  double low,  double close,  double volume)?  $default,) {final _that = this;
switch (_that) {
case _KlinePoint() when $default != null:
return $default(_that.timestamp,_that.open,_that.high,_that.low,_that.close,_that.volume);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KlinePoint implements KlinePoint {
  const _KlinePoint({required this.timestamp, required this.open, required this.high, required this.low, required this.close, required this.volume});
  factory _KlinePoint.fromJson(Map<String, dynamic> json) => _$KlinePointFromJson(json);

@override final  DateTime timestamp;
@override final  double open;
@override final  double high;
@override final  double low;
@override final  double close;
@override final  double volume;

/// Create a copy of KlinePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KlinePointCopyWith<_KlinePoint> get copyWith => __$KlinePointCopyWithImpl<_KlinePoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KlinePointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KlinePoint&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.open, open) || other.open == open)&&(identical(other.high, high) || other.high == high)&&(identical(other.low, low) || other.low == low)&&(identical(other.close, close) || other.close == close)&&(identical(other.volume, volume) || other.volume == volume));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,open,high,low,close,volume);

@override
String toString() {
  return 'KlinePoint(timestamp: $timestamp, open: $open, high: $high, low: $low, close: $close, volume: $volume)';
}


}

/// @nodoc
abstract mixin class _$KlinePointCopyWith<$Res> implements $KlinePointCopyWith<$Res> {
  factory _$KlinePointCopyWith(_KlinePoint value, $Res Function(_KlinePoint) _then) = __$KlinePointCopyWithImpl;
@override @useResult
$Res call({
 DateTime timestamp, double open, double high, double low, double close, double volume
});




}
/// @nodoc
class __$KlinePointCopyWithImpl<$Res>
    implements _$KlinePointCopyWith<$Res> {
  __$KlinePointCopyWithImpl(this._self, this._then);

  final _KlinePoint _self;
  final $Res Function(_KlinePoint) _then;

/// Create a copy of KlinePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timestamp = null,Object? open = null,Object? high = null,Object? low = null,Object? close = null,Object? volume = null,}) {
  return _then(_KlinePoint(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,open: null == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as double,high: null == high ? _self.high : high // ignore: cast_nullable_to_non_nullable
as double,low: null == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as double,close: null == close ? _self.close : close // ignore: cast_nullable_to_non_nullable
as double,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
