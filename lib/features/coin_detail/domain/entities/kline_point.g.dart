// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kline_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KlinePoint _$KlinePointFromJson(Map<String, dynamic> json) => _KlinePoint(
  timestamp: DateTime.parse(json['timestamp'] as String),
  open: (json['open'] as num).toDouble(),
  high: (json['high'] as num).toDouble(),
  low: (json['low'] as num).toDouble(),
  close: (json['close'] as num).toDouble(),
  volume: (json['volume'] as num).toDouble(),
);

Map<String, dynamic> _$KlinePointToJson(_KlinePoint instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'open': instance.open,
      'high': instance.high,
      'low': instance.low,
      'close': instance.close,
      'volume': instance.volume,
    };
