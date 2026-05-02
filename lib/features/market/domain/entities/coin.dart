import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin.freezed.dart';
part 'coin.g.dart';

@freezed
class Coin with _$Coin {
  const factory Coin({
    required String symbol,
    required String name,
    required double currentPrice,
    required double priceChangePercent24h,
    required double priceChange24h,
    required double volume24h,
    required double high24h,
    required double low24h,
    required bool isUp,
  }) = _Coin;

  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);
}
