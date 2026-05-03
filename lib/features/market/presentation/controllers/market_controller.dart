import 'dart:async';
import 'package:flutter/foundation.dart';
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
  Future<List<Coin>>? _inFlightRequest;

  @override
  FutureOr<List<Coin>> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);
    final liveRefreshEnabled =
        prefs.getBool(PreferenceKeys.liveRefresh) ?? true;

    _refreshTimer?.cancel();
    if (liveRefreshEnabled) {
      _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        _refreshInBackground();
      });
    }

    // Cleanup timer on dispose
    ref.onDispose(() {
      _refreshTimer?.cancel();
    });

    return _fetchMarketPulse();
  }

  Future<List<Coin>> _fetchMarketPulse() async {
    final inFlight = _inFlightRequest;
    if (inFlight != null) return inFlight;

    final repository = ref.read(marketRepositoryProvider);
    final request = () async {
      final coins = await repository.getMarketPulse(
        SupportedCoins.defaultMarketSymbols,
      );

      // Keep Binance responses in the app's curated symbol order.
      coins.sort((a, b) {
        final indexA = SupportedCoins.defaultMarketSymbols.indexOf(a.symbol);
        final indexB = SupportedCoins.defaultMarketSymbols.indexOf(b.symbol);
        return indexA.compareTo(indexB);
      });

      state = AsyncValue.data(coins);
      return coins;
    }();
    _inFlightRequest = request;

    try {
      return await request;
    } finally {
      _inFlightRequest = null;
    }
  }

  void _refreshInBackground() {
    unawaited(
      _fetchMarketPulse().catchError((Object error, StackTrace stackTrace) {
        if (!kDebugMode) return <Coin>[];
        debugPrint('Market background refresh failed: $error');
        debugPrintStack(stackTrace: stackTrace);
        return <Coin>[];
      }),
    );
  }
}
