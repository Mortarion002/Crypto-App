import 'package:crypto_pulse/features/market/domain/entities/coin.dart';

abstract class MarketRepository {
  Future<List<Coin>> getMarketPulse(List<String> symbols);
}
