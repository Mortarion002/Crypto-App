import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/market/data/datasources/binance_market_remote_data_source.dart';
import 'package:crypto_pulse/features/market/domain/entities/coin.dart';
import 'package:crypto_pulse/features/market/domain/repositories/market_repository.dart';
import 'package:crypto_pulse/core/constants/supported_coins.dart';

final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  return MarketRepositoryImpl(ref.watch(binanceMarketRemoteDataSourceProvider));
});

class MarketRepositoryImpl implements MarketRepository {
  final BinanceMarketRemoteDataSource _remoteDataSource;

  MarketRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Coin>> getMarketPulse(List<String> symbols) async {
    final dtos = await _remoteDataSource.getTickers24h(symbols);
    
    return dtos.map((dto) {
      final currentPrice = double.tryParse(dto.lastPrice) ?? 0.0;
      final priceChange24h = double.tryParse(dto.priceChange) ?? 0.0;
      final priceChangePercent24h = double.tryParse(dto.priceChangePercent) ?? 0.0;
      final volume24h = double.tryParse(dto.quoteVolume) ?? 0.0;
      final high24h = double.tryParse(dto.highPrice) ?? 0.0;
      final low24h = double.tryParse(dto.lowPrice) ?? 0.0;
      
      return Coin(
        symbol: dto.symbol,
        name: SupportedCoins.getCoinName(dto.symbol),
        currentPrice: currentPrice,
        priceChangePercent24h: priceChangePercent24h,
        priceChange24h: priceChange24h,
        volume24h: volume24h,
        high24h: high24h,
        low24h: low24h,
        isUp: priceChange24h >= 0,
      );
    }).toList();
  }
}
