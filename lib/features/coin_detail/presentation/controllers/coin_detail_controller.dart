import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/coin_detail/domain/entities/kline_point.dart';
import 'package:crypto_pulse/features/coin_detail/data/repositories/coin_detail_repository_impl.dart';

class CoinDetailParams {
  final String symbol;
  final String interval;

  CoinDetailParams({required this.symbol, required this.interval});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CoinDetailParams &&
            other.symbol == symbol &&
            other.interval == interval);
  }

  @override
  int get hashCode => symbol.hashCode ^ interval.hashCode;
}

final coinDetailProvider = FutureProvider.family<List<KlinePoint>, CoinDetailParams>((ref, params) async {
  final repository = ref.read(coinDetailRepositoryProvider);
  return repository.getCoinKlines(params.symbol, params.interval);
});
