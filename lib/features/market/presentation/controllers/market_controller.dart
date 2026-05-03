import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/core/config/preference_keys.dart';
import 'package:crypto_pulse/features/market/domain/entities/coin.dart';
import 'package:crypto_pulse/features/market/data/repositories/market_repository_impl.dart';
import 'package:crypto_pulse/core/constants/supported_coins.dart';
import 'package:crypto_pulse/core/providers/shared_prefs_provider.dart';

final marketControllerProvider =
    AsyncNotifierProvider<MarketController, List<Coin>>(() {
      return MarketController();
    });

class MarketController extends AsyncNotifier<List<Coin>> {
  Timer? _refreshTimer;

  @override
  FutureOr<List<Coin>> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);
    final liveRefreshEnabled =
        prefs.getBool(PreferenceKeys.liveRefresh) ?? true;

    _refreshTimer?.cancel();
    if (liveRefreshEnabled) {
      _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        _fetchMarketPulse();
      });
    }

    // Cleanup timer on dispose
    ref.onDispose(() {
      _refreshTimer?.cancel();
    });

    return _fetchMarketPulse();
  }

  Future<List<Coin>> _fetchMarketPulse() async {
    final repository = ref.read(marketRepositoryProvider);
    final coins = await repository.getMarketPulse(
      SupportedCoins.defaultMarketSymbols,
    );

    // Sort coins by market cap / relevance based on defaultMarketSymbols order
    // But since Binance might return them in different order, let's keep the predefined order.
    coins.sort((a, b) {
      final indexA = SupportedCoins.defaultMarketSymbols.indexOf(a.symbol);
      final indexB = SupportedCoins.defaultMarketSymbols.indexOf(b.symbol);
      return indexA.compareTo(indexB);
    });

    // Update state explicitly when doing background refresh
    state = AsyncValue.data(coins);
    return coins;
  }
}
