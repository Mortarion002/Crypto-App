import 'package:freezed_annotation/freezed_annotation.dart';

part 'binance_ticker_dto.freezed.dart';
part 'binance_ticker_dto.g.dart';

@freezed
class BinanceTickerDto with _$BinanceTickerDto {
  const BinanceTickerDto._();
  const factory BinanceTickerDto({
    required String symbol,
    required String priceChange,
    required String priceChangePercent,
    required String weightedAvgPrice,
    required String prevClosePrice,
    required String lastPrice,
    required String lastQty,
    required String bidPrice,
    required String bidQty,
    required String askPrice,
    required String askQty,
    required String openPrice,
    required String highPrice,
    required String lowPrice,
    required String volume,
    required String quoteVolume,
    required int openTime,
    required int closeTime,
    required int firstId,
    required int lastId,
    required int count,
  }) = _BinanceTickerDto;

  factory BinanceTickerDto.fromJson(Map<String, dynamic> json) => 
      _$BinanceTickerDtoFromJson(json);
}
