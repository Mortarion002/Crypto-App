// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Coin _$CoinFromJson(Map<String, dynamic> json) => _Coin(
  symbol: json['symbol'] as String,
  name: json['name'] as String,
  currentPrice: (json['currentPrice'] as num).toDouble(),
  priceChangePercent24h: (json['priceChangePercent24h'] as num).toDouble(),
  priceChange24h: (json['priceChange24h'] as num).toDouble(),
  volume24h: (json['volume24h'] as num).toDouble(),
  high24h: (json['high24h'] as num).toDouble(),
  low24h: (json['low24h'] as num).toDouble(),
  isUp: json['isUp'] as bool,
);

Map<String, dynamic> _$CoinToJson(_Coin instance) => <String, dynamic>{
  'symbol': instance.symbol,
  'name': instance.name,
  'currentPrice': instance.currentPrice,
  'priceChangePercent24h': instance.priceChangePercent24h,
  'priceChange24h': instance.priceChange24h,
  'volume24h': instance.volume24h,
  'high24h': instance.high24h,
  'low24h': instance.low24h,
  'isUp': instance.isUp,
};
