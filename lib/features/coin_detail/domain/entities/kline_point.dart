import 'package:freezed_annotation/freezed_annotation.dart';

part 'kline_point.freezed.dart';
part 'kline_point.g.dart';

@freezed
abstract class KlinePoint with _$KlinePoint {
  const KlinePoint._();
  const factory KlinePoint({
    required DateTime timestamp,
    required double open,
    required double high,
    required double low,
    required double close,
    required double volume,
  }) = _KlinePoint;

  factory KlinePoint.fromJson(Map<String, dynamic> json) => _$KlinePointFromJson(json);
}
