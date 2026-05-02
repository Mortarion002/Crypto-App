import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/core/config/api_endpoints.dart';
import 'package:crypto_pulse/core/network/dio_provider.dart';
import 'package:crypto_pulse/features/market/data/models/binance_ticker_dto.dart';

final binanceMarketRemoteDataSourceProvider = Provider<BinanceMarketRemoteDataSource>((ref) {
  return BinanceMarketRemoteDataSource(ref.watch(dioProvider));
});

class BinanceMarketRemoteDataSource {
  final Dio _dio;

  BinanceMarketRemoteDataSource(this._dio);

  Future<List<BinanceTickerDto>> getTickers24h(List<String> symbols) async {
    try {
      // Binance API requires symbols to be formatted like: ["BTCUSDT","ETHUSDT"]
      final symbolsString = '[${symbols.map((s) => '"$s"').join(',')}]';
      
      final response = await _dio.get(
        ApiEndpoints.ticker24hr,
        queryParameters: {
          'symbols': symbolsString,
        },
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => BinanceTickerDto.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch market data: $e');
    }
  }
}
