import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/market/domain/entities/coin.dart';
import 'package:crypto_pulse/features/market/presentation/controllers/market_controller.dart';

class MarketInsights {
  final List<Coin> topGainers;
  final List<Coin> topLosers;
  final String marketHeadline;
  final double volatilityIndex; // simple dummy index

  MarketInsights({
    required this.topGainers,
    required this.topLosers,
    required this.marketHeadline,
    required this.volatilityIndex,
  });
}

final insightsControllerProvider = Provider<AsyncValue<MarketInsights>>((ref) {
  final marketState = ref.watch(marketControllerProvider);

  return marketState.whenData((coins) {
    if (coins.isEmpty) {
      return MarketInsights(
        topGainers: [],
        topLosers: [],
        marketHeadline: 'Market data unavailable.',
        volatilityIndex: 0.0,
      );
    }

    final sortedByChange = List<Coin>.from(coins)
      ..sort((a, b) => b.priceChangePercent24h.compareTo(a.priceChangePercent24h));

    final gainers = sortedByChange.where((c) => c.isUp).toList();
    final losers = sortedByChange.reversed.where((c) => !c.isUp).toList();

    // Calculate a naive volatility index based on average absolute price change
    final totalChange = coins.fold<double>(
        0.0, (sum, c) => sum + c.priceChangePercent24h.abs());
    final volatilityIndex = totalChange / coins.length;

    String headline;
    if (volatilityIndex > 5.0) {
      headline = 'High Volatility! The market is seeing wild swings today.';
    } else if (gainers.length > losers.length) {
      headline = 'Bullish Momentum. Buyers are stepping in across the board.';
    } else {
      headline = 'Bearish Pressure. Most assets are trending downwards.';
    }

    return MarketInsights(
      topGainers: gainers.take(3).toList(),
      topLosers: losers.take(3).toList(),
      marketHeadline: headline,
      volatilityIndex: volatilityIndex,
    );
  });
});
