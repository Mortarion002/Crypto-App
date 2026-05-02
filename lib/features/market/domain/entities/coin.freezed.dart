// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Coin {

 String get symbol; String get name; double get currentPrice; double get priceChangePercent24h; double get priceChange24h; double get volume24h; double get high24h; double get low24h; bool get isUp;
/// Create a copy of Coin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoinCopyWith<Coin> get copyWith => _$CoinCopyWithImpl<Coin>(this as Coin, _$identity);

  /// Serializes this Coin to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Coin&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.name, name) || other.name == name)&&(identical(other.currentPrice, currentPrice) || other.currentPrice == currentPrice)&&(identical(other.priceChangePercent24h, priceChangePercent24h) || other.priceChangePercent24h == priceChangePercent24h)&&(identical(other.priceChange24h, priceChange24h) || other.priceChange24h == priceChange24h)&&(identical(other.volume24h, volume24h) || other.volume24h == volume24h)&&(identical(other.high24h, high24h) || other.high24h == high24h)&&(identical(other.low24h, low24h) || other.low24h == low24h)&&(identical(other.isUp, isUp) || other.isUp == isUp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,symbol,name,currentPrice,priceChangePercent24h,priceChange24h,volume24h,high24h,low24h,isUp);

@override
String toString() {
  return 'Coin(symbol: $symbol, name: $name, currentPrice: $currentPrice, priceChangePercent24h: $priceChangePercent24h, priceChange24h: $priceChange24h, volume24h: $volume24h, high24h: $high24h, low24h: $low24h, isUp: $isUp)';
}


}

/// @nodoc
abstract mixin class $CoinCopyWith<$Res>  {
  factory $CoinCopyWith(Coin value, $Res Function(Coin) _then) = _$CoinCopyWithImpl;
@useResult
$Res call({
 String symbol, String name, double currentPrice, double priceChangePercent24h, double priceChange24h, double volume24h, double high24h, double low24h, bool isUp
});




}
/// @nodoc
class _$CoinCopyWithImpl<$Res>
    implements $CoinCopyWith<$Res> {
  _$CoinCopyWithImpl(this._self, this._then);

  final Coin _self;
  final $Res Function(Coin) _then;

/// Create a copy of Coin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? symbol = null,Object? name = null,Object? currentPrice = null,Object? priceChangePercent24h = null,Object? priceChange24h = null,Object? volume24h = null,Object? high24h = null,Object? low24h = null,Object? isUp = null,}) {
  return _then(_self.copyWith(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currentPrice: null == currentPrice ? _self.currentPrice : currentPrice // ignore: cast_nullable_to_non_nullable
as double,priceChangePercent24h: null == priceChangePercent24h ? _self.priceChangePercent24h : priceChangePercent24h // ignore: cast_nullable_to_non_nullable
as double,priceChange24h: null == priceChange24h ? _self.priceChange24h : priceChange24h // ignore: cast_nullable_to_non_nullable
as double,volume24h: null == volume24h ? _self.volume24h : volume24h // ignore: cast_nullable_to_non_nullable
as double,high24h: null == high24h ? _self.high24h : high24h // ignore: cast_nullable_to_non_nullable
as double,low24h: null == low24h ? _self.low24h : low24h // ignore: cast_nullable_to_non_nullable
as double,isUp: null == isUp ? _self.isUp : isUp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Coin].
extension CoinPatterns on Coin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Coin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Coin() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Coin value)  $default,){
final _that = this;
switch (_that) {
case _Coin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Coin value)?  $default,){
final _that = this;
switch (_that) {
case _Coin() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String symbol,  String name,  double currentPrice,  double priceChangePercent24h,  double priceChange24h,  double volume24h,  double high24h,  double low24h,  bool isUp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Coin() when $default != null:
return $default(_that.symbol,_that.name,_that.currentPrice,_that.priceChangePercent24h,_that.priceChange24h,_that.volume24h,_that.high24h,_that.low24h,_that.isUp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String symbol,  String name,  double currentPrice,  double priceChangePercent24h,  double priceChange24h,  double volume24h,  double high24h,  double low24h,  bool isUp)  $default,) {final _that = this;
switch (_that) {
case _Coin():
return $default(_that.symbol,_that.name,_that.currentPrice,_that.priceChangePercent24h,_that.priceChange24h,_that.volume24h,_that.high24h,_that.low24h,_that.isUp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String symbol,  String name,  double currentPrice,  double priceChangePercent24h,  double priceChange24h,  double volume24h,  double high24h,  double low24h,  bool isUp)?  $default,) {final _that = this;
switch (_that) {
case _Coin() when $default != null:
return $default(_that.symbol,_that.name,_that.currentPrice,_that.priceChangePercent24h,_that.priceChange24h,_that.volume24h,_that.high24h,_that.low24h,_that.isUp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Coin implements Coin {
  const _Coin({required this.symbol, required this.name, required this.currentPrice, required this.priceChangePercent24h, required this.priceChange24h, required this.volume24h, required this.high24h, required this.low24h, required this.isUp});
  factory _Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);

@override final  String symbol;
@override final  String name;
@override final  double currentPrice;
@override final  double priceChangePercent24h;
@override final  double priceChange24h;
@override final  double volume24h;
@override final  double high24h;
@override final  double low24h;
@override final  bool isUp;

/// Create a copy of Coin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoinCopyWith<_Coin> get copyWith => __$CoinCopyWithImpl<_Coin>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoinToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Coin&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.name, name) || other.name == name)&&(identical(other.currentPrice, currentPrice) || other.currentPrice == currentPrice)&&(identical(other.priceChangePercent24h, priceChangePercent24h) || other.priceChangePercent24h == priceChangePercent24h)&&(identical(other.priceChange24h, priceChange24h) || other.priceChange24h == priceChange24h)&&(identical(other.volume24h, volume24h) || other.volume24h == volume24h)&&(identical(other.high24h, high24h) || other.high24h == high24h)&&(identical(other.low24h, low24h) || other.low24h == low24h)&&(identical(other.isUp, isUp) || other.isUp == isUp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,symbol,name,currentPrice,priceChangePercent24h,priceChange24h,volume24h,high24h,low24h,isUp);

@override
String toString() {
  return 'Coin(symbol: $symbol, name: $name, currentPrice: $currentPrice, priceChangePercent24h: $priceChangePercent24h, priceChange24h: $priceChange24h, volume24h: $volume24h, high24h: $high24h, low24h: $low24h, isUp: $isUp)';
}


}

/// @nodoc
abstract mixin class _$CoinCopyWith<$Res> implements $CoinCopyWith<$Res> {
  factory _$CoinCopyWith(_Coin value, $Res Function(_Coin) _then) = __$CoinCopyWithImpl;
@override @useResult
$Res call({
 String symbol, String name, double currentPrice, double priceChangePercent24h, double priceChange24h, double volume24h, double high24h, double low24h, bool isUp
});




}
/// @nodoc
class __$CoinCopyWithImpl<$Res>
    implements _$CoinCopyWith<$Res> {
  __$CoinCopyWithImpl(this._self, this._then);

  final _Coin _self;
  final $Res Function(_Coin) _then;

/// Create a copy of Coin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? symbol = null,Object? name = null,Object? currentPrice = null,Object? priceChangePercent24h = null,Object? priceChange24h = null,Object? volume24h = null,Object? high24h = null,Object? low24h = null,Object? isUp = null,}) {
  return _then(_Coin(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currentPrice: null == currentPrice ? _self.currentPrice : currentPrice // ignore: cast_nullable_to_non_nullable
as double,priceChangePercent24h: null == priceChangePercent24h ? _self.priceChangePercent24h : priceChangePercent24h // ignore: cast_nullable_to_non_nullable
as double,priceChange24h: null == priceChange24h ? _self.priceChange24h : priceChange24h // ignore: cast_nullable_to_non_nullable
as double,volume24h: null == volume24h ? _self.volume24h : volume24h // ignore: cast_nullable_to_non_nullable
as double,high24h: null == high24h ? _self.high24h : high24h // ignore: cast_nullable_to_non_nullable
as double,low24h: null == low24h ? _self.low24h : low24h // ignore: cast_nullable_to_non_nullable
as double,isUp: null == isUp ? _self.isUp : isUp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
