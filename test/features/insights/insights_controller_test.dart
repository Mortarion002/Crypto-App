import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/market/domain/entities/coin.dart';
import 'package:crypto_pulse/features/market/presentation/controllers/market_controller.dart';
import 'package:crypto_pulse/features/insights/presentation/controllers/insights_controller.dart';

// ── Fake market controller ───────────────────────────────────────────────────
// Must extend MarketController (not bare AsyncNotifier) so overrideWith
// returns the correct type for AsyncNotifierProvider<MarketController, ...>.

class _FakeMarketController extends MarketController {
  final List<Coin> _coins;
  _FakeMarketController(this._coins);

  @override
  Future<List<Coin>> build() async => _coins;
}

// ── Helpers ──────────────────────────────────────────────────────────────────

Coin _coin(String symbol, double changePercent) => Coin(
      symbol: symbol,
      name: symbol,
      currentPrice: 100.0,
      priceChangePercent24h: changePercent,
      priceChange24h: changePercent,
      volume24h: 1_000_000.0,
      high24h: 110.0,
      low24h: 90.0,
      isUp: changePercent >= 0,
    );

ProviderContainer _makeContainer(List<Coin> coins) {
  return ProviderContainer(
    overrides: [
      marketControllerProvider
          .overrideWith(() => _FakeMarketController(coins)),
    ],
  );
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  group('InsightsController — market mood', () {
    test('BULLISH when gainers > losers × 2', () async {
      // 4 gainers (>2%), 0 losers (<-2%)
      final container = _makeContainer([
        _coin('BTC', 5.0),
        _coin('ETH', 4.0),
        _coin('SOL', 3.0),
        _coin('BNB', 3.5),
        _coin('ADA', 1.0), // between -2 and 2 — neutral, not counted
      ]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.marketMood, MarketMood.bullish);
      expect(data.marketHeadline, 'BULLISH');
    });

    test('BEARISH when losers > gainers × 2', () async {
      // 0 gainers, 4 losers
      final container = _makeContainer([
        _coin('BTC', -5.0),
        _coin('ETH', -4.0),
        _coin('SOL', -3.0),
        _coin('BNB', -3.5),
        _coin('ADA', 1.0),
      ]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.marketMood, MarketMood.bearish);
      expect(data.marketHeadline, 'BEARISH');
    });

    test('NEUTRAL when gainers and losers are balanced', () async {
      final container = _makeContainer([
        _coin('BTC', 3.0),
        _coin('ETH', -3.0),
        _coin('SOL', 1.0), // neutral zone
      ]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.marketMood, MarketMood.neutral);
      expect(data.marketHeadline, 'NEUTRAL');
    });

    test('NEUTRAL when all coins are in the neutral zone (±2%)', () async {
      final container = _makeContainer([
        _coin('BTC', 1.0),
        _coin('ETH', -1.5),
        _coin('SOL', 0.5),
      ]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.gainersCount, 0);
      expect(data.losersCount, 0);
      expect(data.marketMood, MarketMood.neutral);
    });
  });

  group('InsightsController — volatility', () {
    test('LOW when avg absolute change < 2%', () async {
      // avg = (1.0 + 0.5 + 1.5) / 3 = 1.0
      final container = _makeContainer([
        _coin('BTC', 1.0),
        _coin('ETH', -0.5),
        _coin('SOL', 1.5),
      ]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.volatilityLevel, VolatilityLevel.low);
    });

    test('MODERATE when avg absolute change is 2–5%', () async {
      // avg = (3.0 + 3.0 + 4.0) / 3 ≈ 3.33
      final container = _makeContainer([
        _coin('BTC', 3.0),
        _coin('ETH', -3.0),
        _coin('SOL', 4.0),
      ]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.volatilityLevel, VolatilityLevel.moderate);
    });

    test('HIGH when avg absolute change > 5%', () async {
      // avg = (8.0 + 7.0 + 6.0) / 3 = 7.0
      final container = _makeContainer([
        _coin('BTC', 8.0),
        _coin('ETH', -7.0),
        _coin('SOL', 6.0),
      ]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.volatilityLevel, VolatilityLevel.high);
    });

    test('volatilityIndex is clamped to 0–100', () async {
      // avg = (50.0 + 50.0) / 2 = 50 → index = 500 → clamped to 100
      final container = _makeContainer([
        _coin('BTC', 50.0),
        _coin('ETH', -50.0),
      ]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.volatilityIndex, 100.0);
    });

    test('volatilityIndex is 0 for zero-change coins', () async {
      final container = _makeContainer([
        _coin('BTC', 0.0),
        _coin('ETH', 0.0),
      ]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.volatilityIndex, 0.0);
    });
  });

  group('InsightsController — top movers', () {
    test('top gainers are limited to 3 and sorted descending', () async {
      final container = _makeContainer([
        _coin('BTC', 10.0),
        _coin('ETH', 8.0),
        _coin('SOL', 6.0),
        _coin('BNB', 4.0),
        _coin('ADA', -3.0),
      ]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.topGainers.length, 3);
      expect(data.topGainers.first.priceChangePercent24h, 10.0);
      expect(data.topGainers.last.priceChangePercent24h, 6.0);
    });

    test('top losers are limited to 3', () async {
      final container = _makeContainer([
        _coin('BTC', -10.0),
        _coin('ETH', -8.0),
        _coin('SOL', -6.0),
        _coin('BNB', -4.0),
        _coin('ADA', 3.0),
      ]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.topLosers.length, 3);
      for (final loser in data.topLosers) {
        expect(loser.priceChangePercent24h, lessThan(-2.0));
      }
    });

    test('gainersCount only counts coins above the 2% threshold', () async {
      final container = _makeContainer([
        _coin('BTC', 5.0), // gainer
        _coin('ETH', 3.0), // gainer
        _coin('SOL', 1.0), // not a gainer (<2%)
        _coin('BNB', -1.0), // not a loser (>-2%)
      ]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.gainersCount, 2);
    });

    test('losersCount only counts coins below the -2% threshold', () async {
      final container = _makeContainer([
        _coin('BTC', -5.0), // loser
        _coin('ETH', -3.0), // loser
        _coin('SOL', -1.0), // not a loser (>-2%)
        _coin('BNB', 1.0),
      ]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.losersCount, 2);
    });
  });

  group('InsightsController — empty data', () {
    test('handles empty coin list gracefully', () async {
      final container = _makeContainer([]);
      addTearDown(container.dispose);

      await container.read(marketControllerProvider.future);
      final data =
          container.read(insightsControllerProvider).asData!.value;

      expect(data.topGainers, isEmpty);
      expect(data.topLosers, isEmpty);
      expect(data.gainersCount, 0);
      expect(data.losersCount, 0);
      expect(data.volatilityIndex, 0.0);
      expect(data.marketHeadline, 'Market data unavailable.');
    });
  });
}
