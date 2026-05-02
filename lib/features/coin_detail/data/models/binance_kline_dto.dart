class BinanceKlineDto {
  final int openTime;
  final String open;
  final String high;
  final String low;
  final String close;
  final String volume;
  final int closeTime;
  final String quoteAssetVolume;
  final int numberOfTrades;
  final String takerBuyBaseAssetVolume;
  final String takerBuyQuoteAssetVolume;
  final String ignore;

  BinanceKlineDto({
    required this.openTime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.closeTime,
    required this.quoteAssetVolume,
    required this.numberOfTrades,
    required this.takerBuyBaseAssetVolume,
    required this.takerBuyQuoteAssetVolume,
    required this.ignore,
  });

  factory BinanceKlineDto.fromJson(List<dynamic> json) {
    return BinanceKlineDto(
      openTime: json[0] as int,
      open: json[1] as String,
      high: json[2] as String,
      low: json[3] as String,
      close: json[4] as String,
      volume: json[5] as String,
      closeTime: json[6] as int,
      quoteAssetVolume: json[7] as String,
      numberOfTrades: json[8] as int,
      takerBuyBaseAssetVolume: json[9] as String,
      takerBuyQuoteAssetVolume: json[10] as String,
      ignore: json[11] as String,
    );
  }
}
