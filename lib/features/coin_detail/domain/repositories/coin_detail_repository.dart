import 'package:crypto_pulse/features/coin_detail/domain/entities/kline_point.dart';

abstract class CoinDetailRepository {
  Future<List<KlinePoint>> getCoinKlines(String symbol, String interval);
}
