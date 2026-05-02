import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/coin_detail/data/datasources/binance_coin_remote_data_source.dart';
import 'package:crypto_pulse/features/coin_detail/domain/entities/kline_point.dart';
import 'package:crypto_pulse/features/coin_detail/domain/repositories/coin_detail_repository.dart';

final coinDetailRepositoryProvider = Provider<CoinDetailRepository>((ref) {
  return CoinDetailRepositoryImpl(ref.watch(binanceCoinRemoteDataSourceProvider));
});

class CoinDetailRepositoryImpl implements CoinDetailRepository {
  final BinanceCoinRemoteDataSource _remoteDataSource;

  CoinDetailRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<KlinePoint>> getCoinKlines(String symbol, String interval) async {
    final dtos = await _remoteDataSource.getKlines(symbol, interval);
    
    return dtos.map((dto) {
      return KlinePoint(
        timestamp: DateTime.fromMillisecondsSinceEpoch(dto.openTime),
        open: double.tryParse(dto.open) ?? 0.0,
        high: double.tryParse(dto.high) ?? 0.0,
        low: double.tryParse(dto.low) ?? 0.0,
        close: double.tryParse(dto.close) ?? 0.0,
        volume: double.tryParse(dto.volume) ?? 0.0,
      );
    }).toList();
  }
}
