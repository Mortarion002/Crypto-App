import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/market/domain/entities/coin.dart';
import 'package:crypto_pulse/features/market/presentation/controllers/market_controller.dart';

enum MarketMood { bullish, bearish, neutral }

enum VolatilityLevel { low, moderate, high }

class MarketInsights {
  final List<Coin> topGainers;
  final List<Coin> topLosers;
  final String marketHeadline;
  final String marketSubtext;
  final double volatilityIndex; // 0–100 display scale
  final VolatilityLevel volatilityLevel;
  final MarketMood marketMood;
  final int gainersCount;
  final int losersCount;
  final String insightText;

  MarketInsights({
    required this.topGainers,
    required this.topLosers,
    required this.marketHeadline,
    required this.marketSubtext,
    required this.volatilityIndex,
    required this.volatilityLevel,
    required this.marketMood,
    required this.gainersCount,
    required this.losersCount,
    required this.insightText,
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
        marketSubtext: 'Pull to refresh and try again.',
        volatilityIndex: 0.0,
        volatilityLevel: VolatilityLevel.low,
        marketMood: MarketMood.neutral,
        gainersCount: 0,
        losersCount: 0,
        insightText: 'No market data available at this time.',
      );
    }

    final sortedByChange = List<Coin>.from(coins)
      ..sort((a, b) => b.priceChangePercent24h.compareTo(a.priceChangePercent24h));

    final gainers = sortedByChange.where((c) => c.priceChangePercent24h > 2.0).toList();
    final losers = sortedByChange.reversed
        .where((c) => c.priceChangePercent24h < -2.0)
        .toList();
    final gainersCount = gainers.length;
    final losersCount = losers.length;

    // Average absolute price change
    final avgAbsChange = coins.fold<double>(
          0.0, (sum, c) => sum + c.priceChangePercent24h.abs()) /
        coins.length;

    // Volatility on 0–100 scale (avg * 10, capped at 100)
    final volatilityIndex = (avgAbsChange * 10).clamp(0.0, 100.0);

    final VolatilityLevel volatilityLevel;
    if (avgAbsChange < 2.0) {
      volatilityLevel = VolatilityLevel.low;
    } else if (avgAbsChange < 5.0) {
      volatilityLevel = VolatilityLevel.moderate;
    } else {
      volatilityLevel = VolatilityLevel.high;
    }

    // Overall mood
    final MarketMood marketMood;
    if (gainersCount > losersCount * 2) {
      marketMood = MarketMood.bullish;
    } else if (losersCount > gainersCount * 2) {
      marketMood = MarketMood.bearish;
    } else {
      marketMood = MarketMood.neutral;
    }

    // Headlines and subtexts
    String marketHeadline;
    String marketSubtext;
    String insightText;

    switch (marketMood) {
      case MarketMood.bullish:
        marketHeadline = 'BULLISH';
        marketSubtext =
            'Buyers are stepping in. Broad strength across major assets with $gainersCount coins pushing higher.';
        final topSymbol = gainers.isNotEmpty ? gainers.first.symbol.replaceAll('USDT', '') : 'BTC';
        insightText =
            'Market is bullish with $topSymbol leading the charge. '
            '${volatilityLevel == VolatilityLevel.high ? 'Elevated volatility — expect wider swings.' : 'Momentum looks sustainable for the next session.'}';
      case MarketMood.bearish:
        marketHeadline = 'BEARISH';
        marketSubtext =
            'Risk-off sentiment dominates. Most tracked assets are trading below yesterday\'s close.';
        final bottomSymbol = losers.isNotEmpty ? losers.first.symbol.replaceAll('USDT', '') : 'BTC';
        insightText =
            'Market is under pressure with $bottomSymbol showing notable weakness. '
            '${volatilityLevel == VolatilityLevel.high ? 'Volatility is elevated — proceed with caution.' : 'Watch for a potential reversal near key support levels.'}';
      case MarketMood.neutral:
        marketHeadline = 'NEUTRAL';
        marketSubtext =
            'Holding steady. Volume is drying up as participants wait for the next macroeconomic signal.';
        insightText =
            'Market is neutral with mixed signals across tracked coins. '
            'Expect sideways movement before the next directional move. '
            '${volatilityLevel == VolatilityLevel.high ? 'Volatility is elevated despite the neutral tone.' : 'Low volatility confirms the consolidation phase.'}';
    }

    return MarketInsights(
      topGainers: gainers.take(3).toList(),
      topLosers: losers.take(3).toList(),
      marketHeadline: marketHeadline,
      marketSubtext: marketSubtext,
      volatilityIndex: volatilityIndex,
      volatilityLevel: volatilityLevel,
      marketMood: marketMood,
      gainersCount: gainersCount,
      losersCount: losersCount,
      insightText: insightText,
    );
  });
});
