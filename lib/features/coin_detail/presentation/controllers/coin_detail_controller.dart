import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/coin_detail/domain/entities/kline_point.dart';
import 'package:crypto_pulse/features/coin_detail/data/repositories/coin_detail_repository_impl.dart';

final coinDetailControllerProvider =
    AsyncNotifierProviderFamily<CoinDetailController, List<KlinePoint>, CoinDetailParams>(() {
  return CoinDetailController();
});

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

class CoinDetailController extends FamilyAsyncNotifier<List<KlinePoint>, CoinDetailParams> {
  @override
  Future<List<KlinePoint>> build(CoinDetailParams arg) async {
    return _fetchKlines(arg.symbol, arg.interval);
  }

  Future<List<KlinePoint>> _fetchKlines(String symbol, String interval) async {
    final repository = ref.read(coinDetailRepositoryProvider);
    return await repository.getCoinKlines(symbol, interval);
  }

  Future<void> updateInterval(String newInterval) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchKlines(arg.symbol, newInterval));
  }
}
