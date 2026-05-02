import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/core/config/api_endpoints.dart';
import 'package:crypto_pulse/core/network/dio_provider.dart';
import 'package:crypto_pulse/features/coin_detail/data/models/binance_kline_dto.dart';

final binanceCoinRemoteDataSourceProvider = Provider<BinanceCoinRemoteDataSource>((ref) {
  return BinanceCoinRemoteDataSource(ref.watch(dioProvider));
});

class BinanceCoinRemoteDataSource {
  final Dio _dio;

  BinanceCoinRemoteDataSource(this._dio);

  Future<List<BinanceKlineDto>> getKlines(String symbol, String interval, {int limit = 100}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.klines,
        queryParameters: {
          'symbol': symbol,
          'interval': interval,
          'limit': limit,
        },
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => BinanceKlineDto.fromJson(json as List<dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch klines: $e');
    }
  }
}
