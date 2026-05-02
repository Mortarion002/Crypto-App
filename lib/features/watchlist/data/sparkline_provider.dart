import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/coin_detail/data/datasources/binance_coin_remote_data_source.dart';
import 'package:crypto_pulse/features/coin_detail/domain/entities/kline_point.dart';

// Fetches 20-point 1d klines for sparkline display in watchlist tiles.
final coinSparklineProvider =
    FutureProvider.family<List<KlinePoint>, String>((ref, symbol) async {
  final dataSource = ref.read(binanceCoinRemoteDataSourceProvider);
  final dtos = await dataSource.getKlines(symbol, '1d', limit: 20);
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
});
