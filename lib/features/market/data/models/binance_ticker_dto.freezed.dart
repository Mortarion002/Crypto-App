// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'binance_ticker_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BinanceTickerDto {

 String get symbol; String get priceChange; String get priceChangePercent; String get weightedAvgPrice; String get prevClosePrice; String get lastPrice; String get lastQty; String get bidPrice; String get bidQty; String get askPrice; String get askQty; String get openPrice; String get highPrice; String get lowPrice; String get volume; String get quoteVolume; int get openTime; int get closeTime; int get firstId; int get lastId; int get count;
/// Create a copy of BinanceTickerDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BinanceTickerDtoCopyWith<BinanceTickerDto> get copyWith => _$BinanceTickerDtoCopyWithImpl<BinanceTickerDto>(this as BinanceTickerDto, _$identity);

  /// Serializes this BinanceTickerDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BinanceTickerDto&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.priceChange, priceChange) || other.priceChange == priceChange)&&(identical(other.priceChangePercent, priceChangePercent) || other.priceChangePercent == priceChangePercent)&&(identical(other.weightedAvgPrice, weightedAvgPrice) || other.weightedAvgPrice == weightedAvgPrice)&&(identical(other.prevClosePrice, prevClosePrice) || other.prevClosePrice == prevClosePrice)&&(identical(other.lastPrice, lastPrice) || other.lastPrice == lastPrice)&&(identical(other.lastQty, lastQty) || other.lastQty == lastQty)&&(identical(other.bidPrice, bidPrice) || other.bidPrice == bidPrice)&&(identical(other.bidQty, bidQty) || other.bidQty == bidQty)&&(identical(other.askPrice, askPrice) || other.askPrice == askPrice)&&(identical(other.askQty, askQty) || other.askQty == askQty)&&(identical(other.openPrice, openPrice) || other.openPrice == openPrice)&&(identical(other.highPrice, highPrice) || other.highPrice == highPrice)&&(identical(other.lowPrice, lowPrice) || other.lowPrice == lowPrice)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.quoteVolume, quoteVolume) || other.quoteVolume == quoteVolume)&&(identical(other.openTime, openTime) || other.openTime == openTime)&&(identical(other.closeTime, closeTime) || other.closeTime == closeTime)&&(identical(other.firstId, firstId) || other.firstId == firstId)&&(identical(other.lastId, lastId) || other.lastId == lastId)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,symbol,priceChange,priceChangePercent,weightedAvgPrice,prevClosePrice,lastPrice,lastQty,bidPrice,bidQty,askPrice,askQty,openPrice,highPrice,lowPrice,volume,quoteVolume,openTime,closeTime,firstId,lastId,count]);

@override
String toString() {
  return 'BinanceTickerDto(symbol: $symbol, priceChange: $priceChange, priceChangePercent: $priceChangePercent, weightedAvgPrice: $weightedAvgPrice, prevClosePrice: $prevClosePrice, lastPrice: $lastPrice, lastQty: $lastQty, bidPrice: $bidPrice, bidQty: $bidQty, askPrice: $askPrice, askQty: $askQty, openPrice: $openPrice, highPrice: $highPrice, lowPrice: $lowPrice, volume: $volume, quoteVolume: $quoteVolume, openTime: $openTime, closeTime: $closeTime, firstId: $firstId, lastId: $lastId, count: $count)';
}


}

/// @nodoc
abstract mixin class $BinanceTickerDtoCopyWith<$Res>  {
  factory $BinanceTickerDtoCopyWith(BinanceTickerDto value, $Res Function(BinanceTickerDto) _then) = _$BinanceTickerDtoCopyWithImpl;
@useResult
$Res call({
 String symbol, String priceChange, String priceChangePercent, String weightedAvgPrice, String prevClosePrice, String lastPrice, String lastQty, String bidPrice, String bidQty, String askPrice, String askQty, String openPrice, String highPrice, String lowPrice, String volume, String quoteVolume, int openTime, int closeTime, int firstId, int lastId, int count
});




}
/// @nodoc
class _$BinanceTickerDtoCopyWithImpl<$Res>
    implements $BinanceTickerDtoCopyWith<$Res> {
  _$BinanceTickerDtoCopyWithImpl(this._self, this._then);

  final BinanceTickerDto _self;
  final $Res Function(BinanceTickerDto) _then;

/// Create a copy of BinanceTickerDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? symbol = null,Object? priceChange = null,Object? priceChangePercent = null,Object? weightedAvgPrice = null,Object? prevClosePrice = null,Object? lastPrice = null,Object? lastQty = null,Object? bidPrice = null,Object? bidQty = null,Object? askPrice = null,Object? askQty = null,Object? openPrice = null,Object? highPrice = null,Object? lowPrice = null,Object? volume = null,Object? quoteVolume = null,Object? openTime = null,Object? closeTime = null,Object? firstId = null,Object? lastId = null,Object? count = null,}) {
  return _then(_self.copyWith(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,priceChange: null == priceChange ? _self.priceChange : priceChange // ignore: cast_nullable_to_non_nullable
as String,priceChangePercent: null == priceChangePercent ? _self.priceChangePercent : priceChangePercent // ignore: cast_nullable_to_non_nullable
as String,weightedAvgPrice: null == weightedAvgPrice ? _self.weightedAvgPrice : weightedAvgPrice // ignore: cast_nullable_to_non_nullable
as String,prevClosePrice: null == prevClosePrice ? _self.prevClosePrice : prevClosePrice // ignore: cast_nullable_to_non_nullable
as String,lastPrice: null == lastPrice ? _self.lastPrice : lastPrice // ignore: cast_nullable_to_non_nullable
as String,lastQty: null == lastQty ? _self.lastQty : lastQty // ignore: cast_nullable_to_non_nullable
as String,bidPrice: null == bidPrice ? _self.bidPrice : bidPrice // ignore: cast_nullable_to_non_nullable
as String,bidQty: null == bidQty ? _self.bidQty : bidQty // ignore: cast_nullable_to_non_nullable
as String,askPrice: null == askPrice ? _self.askPrice : askPrice // ignore: cast_nullable_to_non_nullable
as String,askQty: null == askQty ? _self.askQty : askQty // ignore: cast_nullable_to_non_nullable
as String,openPrice: null == openPrice ? _self.openPrice : openPrice // ignore: cast_nullable_to_non_nullable
as String,highPrice: null == highPrice ? _self.highPrice : highPrice // ignore: cast_nullable_to_non_nullable
as String,lowPrice: null == lowPrice ? _self.lowPrice : lowPrice // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String,quoteVolume: null == quoteVolume ? _self.quoteVolume : quoteVolume // ignore: cast_nullable_to_non_nullable
as String,openTime: null == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as int,closeTime: null == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as int,firstId: null == firstId ? _self.firstId : firstId // ignore: cast_nullable_to_non_nullable
as int,lastId: null == lastId ? _self.lastId : lastId // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BinanceTickerDto].
extension BinanceTickerDtoPatterns on BinanceTickerDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BinanceTickerDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BinanceTickerDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BinanceTickerDto value)  $default,){
final _that = this;
switch (_that) {
case _BinanceTickerDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BinanceTickerDto value)?  $default,){
final _that = this;
switch (_that) {
case _BinanceTickerDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String symbol,  String priceChange,  String priceChangePercent,  String weightedAvgPrice,  String prevClosePrice,  String lastPrice,  String lastQty,  String bidPrice,  String bidQty,  String askPrice,  String askQty,  String openPrice,  String highPrice,  String lowPrice,  String volume,  String quoteVolume,  int openTime,  int closeTime,  int firstId,  int lastId,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BinanceTickerDto() when $default != null:
return $default(_that.symbol,_that.priceChange,_that.priceChangePercent,_that.weightedAvgPrice,_that.prevClosePrice,_that.lastPrice,_that.lastQty,_that.bidPrice,_that.bidQty,_that.askPrice,_that.askQty,_that.openPrice,_that.highPrice,_that.lowPrice,_that.volume,_that.quoteVolume,_that.openTime,_that.closeTime,_that.firstId,_that.lastId,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String symbol,  String priceChange,  String priceChangePercent,  String weightedAvgPrice,  String prevClosePrice,  String lastPrice,  String lastQty,  String bidPrice,  String bidQty,  String askPrice,  String askQty,  String openPrice,  String highPrice,  String lowPrice,  String volume,  String quoteVolume,  int openTime,  int closeTime,  int firstId,  int lastId,  int count)  $default,) {final _that = this;
switch (_that) {
case _BinanceTickerDto():
return $default(_that.symbol,_that.priceChange,_that.priceChangePercent,_that.weightedAvgPrice,_that.prevClosePrice,_that.lastPrice,_that.lastQty,_that.bidPrice,_that.bidQty,_that.askPrice,_that.askQty,_that.openPrice,_that.highPrice,_that.lowPrice,_that.volume,_that.quoteVolume,_that.openTime,_that.closeTime,_that.firstId,_that.lastId,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String symbol,  String priceChange,  String priceChangePercent,  String weightedAvgPrice,  String prevClosePrice,  String lastPrice,  String lastQty,  String bidPrice,  String bidQty,  String askPrice,  String askQty,  String openPrice,  String highPrice,  String lowPrice,  String volume,  String quoteVolume,  int openTime,  int closeTime,  int firstId,  int lastId,  int count)?  $default,) {final _that = this;
switch (_that) {
case _BinanceTickerDto() when $default != null:
return $default(_that.symbol,_that.priceChange,_that.priceChangePercent,_that.weightedAvgPrice,_that.prevClosePrice,_that.lastPrice,_that.lastQty,_that.bidPrice,_that.bidQty,_that.askPrice,_that.askQty,_that.openPrice,_that.highPrice,_that.lowPrice,_that.volume,_that.quoteVolume,_that.openTime,_that.closeTime,_that.firstId,_that.lastId,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BinanceTickerDto extends BinanceTickerDto {
  const _BinanceTickerDto({required this.symbol, required this.priceChange, required this.priceChangePercent, required this.weightedAvgPrice, required this.prevClosePrice, required this.lastPrice, required this.lastQty, required this.bidPrice, required this.bidQty, required this.askPrice, required this.askQty, required this.openPrice, required this.highPrice, required this.lowPrice, required this.volume, required this.quoteVolume, required this.openTime, required this.closeTime, required this.firstId, required this.lastId, required this.count}): super._();
  factory _BinanceTickerDto.fromJson(Map<String, dynamic> json) => _$BinanceTickerDtoFromJson(json);

@override final  String symbol;
@override final  String priceChange;
@override final  String priceChangePercent;
@override final  String weightedAvgPrice;
@override final  String prevClosePrice;
@override final  String lastPrice;
@override final  String lastQty;
@override final  String bidPrice;
@override final  String bidQty;
@override final  String askPrice;
@override final  String askQty;
@override final  String openPrice;
@override final  String highPrice;
@override final  String lowPrice;
@override final  String volume;
@override final  String quoteVolume;
@override final  int openTime;
@override final  int closeTime;
@override final  int firstId;
@override final  int lastId;
@override final  int count;

/// Create a copy of BinanceTickerDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BinanceTickerDtoCopyWith<_BinanceTickerDto> get copyWith => __$BinanceTickerDtoCopyWithImpl<_BinanceTickerDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BinanceTickerDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BinanceTickerDto&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.priceChange, priceChange) || other.priceChange == priceChange)&&(identical(other.priceChangePercent, priceChangePercent) || other.priceChangePercent == priceChangePercent)&&(identical(other.weightedAvgPrice, weightedAvgPrice) || other.weightedAvgPrice == weightedAvgPrice)&&(identical(other.prevClosePrice, prevClosePrice) || other.prevClosePrice == prevClosePrice)&&(identical(other.lastPrice, lastPrice) || other.lastPrice == lastPrice)&&(identical(other.lastQty, lastQty) || other.lastQty == lastQty)&&(identical(other.bidPrice, bidPrice) || other.bidPrice == bidPrice)&&(identical(other.bidQty, bidQty) || other.bidQty == bidQty)&&(identical(other.askPrice, askPrice) || other.askPrice == askPrice)&&(identical(other.askQty, askQty) || other.askQty == askQty)&&(identical(other.openPrice, openPrice) || other.openPrice == openPrice)&&(identical(other.highPrice, highPrice) || other.highPrice == highPrice)&&(identical(other.lowPrice, lowPrice) || other.lowPrice == lowPrice)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.quoteVolume, quoteVolume) || other.quoteVolume == quoteVolume)&&(identical(other.openTime, openTime) || other.openTime == openTime)&&(identical(other.closeTime, closeTime) || other.closeTime == closeTime)&&(identical(other.firstId, firstId) || other.firstId == firstId)&&(identical(other.lastId, lastId) || other.lastId == lastId)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,symbol,priceChange,priceChangePercent,weightedAvgPrice,prevClosePrice,lastPrice,lastQty,bidPrice,bidQty,askPrice,askQty,openPrice,highPrice,lowPrice,volume,quoteVolume,openTime,closeTime,firstId,lastId,count]);

@override
String toString() {
  return 'BinanceTickerDto(symbol: $symbol, priceChange: $priceChange, priceChangePercent: $priceChangePercent, weightedAvgPrice: $weightedAvgPrice, prevClosePrice: $prevClosePrice, lastPrice: $lastPrice, lastQty: $lastQty, bidPrice: $bidPrice, bidQty: $bidQty, askPrice: $askPrice, askQty: $askQty, openPrice: $openPrice, highPrice: $highPrice, lowPrice: $lowPrice, volume: $volume, quoteVolume: $quoteVolume, openTime: $openTime, closeTime: $closeTime, firstId: $firstId, lastId: $lastId, count: $count)';
}


}

/// @nodoc
abstract mixin class _$BinanceTickerDtoCopyWith<$Res> implements $BinanceTickerDtoCopyWith<$Res> {
  factory _$BinanceTickerDtoCopyWith(_BinanceTickerDto value, $Res Function(_BinanceTickerDto) _then) = __$BinanceTickerDtoCopyWithImpl;
@override @useResult
$Res call({
 String symbol, String priceChange, String priceChangePercent, String weightedAvgPrice, String prevClosePrice, String lastPrice, String lastQty, String bidPrice, String bidQty, String askPrice, String askQty, String openPrice, String highPrice, String lowPrice, String volume, String quoteVolume, int openTime, int closeTime, int firstId, int lastId, int count
});




}
/// @nodoc
class __$BinanceTickerDtoCopyWithImpl<$Res>
    implements _$BinanceTickerDtoCopyWith<$Res> {
  __$BinanceTickerDtoCopyWithImpl(this._self, this._then);

  final _BinanceTickerDto _self;
  final $Res Function(_BinanceTickerDto) _then;

/// Create a copy of BinanceTickerDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? symbol = null,Object? priceChange = null,Object? priceChangePercent = null,Object? weightedAvgPrice = null,Object? prevClosePrice = null,Object? lastPrice = null,Object? lastQty = null,Object? bidPrice = null,Object? bidQty = null,Object? askPrice = null,Object? askQty = null,Object? openPrice = null,Object? highPrice = null,Object? lowPrice = null,Object? volume = null,Object? quoteVolume = null,Object? openTime = null,Object? closeTime = null,Object? firstId = null,Object? lastId = null,Object? count = null,}) {
  return _then(_BinanceTickerDto(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,priceChange: null == priceChange ? _self.priceChange : priceChange // ignore: cast_nullable_to_non_nullable
as String,priceChangePercent: null == priceChangePercent ? _self.priceChangePercent : priceChangePercent // ignore: cast_nullable_to_non_nullable
as String,weightedAvgPrice: null == weightedAvgPrice ? _self.weightedAvgPrice : weightedAvgPrice // ignore: cast_nullable_to_non_nullable
as String,prevClosePrice: null == prevClosePrice ? _self.prevClosePrice : prevClosePrice // ignore: cast_nullable_to_non_nullable
as String,lastPrice: null == lastPrice ? _self.lastPrice : lastPrice // ignore: cast_nullable_to_non_nullable
as String,lastQty: null == lastQty ? _self.lastQty : lastQty // ignore: cast_nullable_to_non_nullable
as String,bidPrice: null == bidPrice ? _self.bidPrice : bidPrice // ignore: cast_nullable_to_non_nullable
as String,bidQty: null == bidQty ? _self.bidQty : bidQty // ignore: cast_nullable_to_non_nullable
as String,askPrice: null == askPrice ? _self.askPrice : askPrice // ignore: cast_nullable_to_non_nullable
as String,askQty: null == askQty ? _self.askQty : askQty // ignore: cast_nullable_to_non_nullable
as String,openPrice: null == openPrice ? _self.openPrice : openPrice // ignore: cast_nullable_to_non_nullable
as String,highPrice: null == highPrice ? _self.highPrice : highPrice // ignore: cast_nullable_to_non_nullable
as String,lowPrice: null == lowPrice ? _self.lowPrice : lowPrice // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String,quoteVolume: null == quoteVolume ? _self.quoteVolume : quoteVolume // ignore: cast_nullable_to_non_nullable
as String,openTime: null == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as int,closeTime: null == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as int,firstId: null == firstId ? _self.firstId : firstId // ignore: cast_nullable_to_non_nullable
as int,lastId: null == lastId ? _self.lastId : lastId // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
