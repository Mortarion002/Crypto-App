import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_pulse/features/market/domain/entities/coin.dart';

Coin _btc({double changePercent = 2.5, bool isUp = true}) => Coin(
      symbol: 'BTCUSDT',
      name: 'Bitcoin',
      currentPrice: 50000.0,
      priceChangePercent24h: changePercent,
      priceChange24h: changePercent * 100,
      volume24h: 1_000_000.0,
      high24h: 51000.0,
      low24h: 49000.0,
      isUp: isUp,
    );

void main() {
  group('Coin', () {
    test('constructs with all required fields', () {
      final coin = _btc();
      expect(coin.symbol, 'BTCUSDT');
      expect(coin.name, 'Bitcoin');
      expect(coin.currentPrice, 50000.0);
      expect(coin.priceChangePercent24h, 2.5);
      expect(coin.high24h, 51000.0);
      expect(coin.low24h, 49000.0);
    });

    test('isUp is true for positive price change', () {
      expect(_btc(changePercent: 3.0, isUp: true).isUp, isTrue);
    });

    test('isUp is false for negative price change', () {
      final coin = Coin(
        symbol: 'ETHUSDT',
        name: 'Ethereum',
        currentPrice: 3000.0,
        priceChangePercent24h: -3.5,
        priceChange24h: -110.0,
        volume24h: 500_000.0,
        high24h: 3200.0,
        low24h: 2900.0,
        isUp: false,
      );
      expect(coin.isUp, isFalse);
      expect(coin.priceChangePercent24h, isNegative);
    });

    test('equality — two identical coins are equal (Freezed)', () {
      final coin1 = _btc();
      final coin2 = _btc();
      expect(coin1, equals(coin2));
    });

    test('coins with different symbols are not equal', () {
      final btc = _btc();
      final eth = Coin(
        symbol: 'ETHUSDT',
        name: 'Ethereum',
        currentPrice: 50000.0,
        priceChangePercent24h: 2.5,
        priceChange24h: 250.0,
        volume24h: 1_000_000.0,
        high24h: 51000.0,
        low24h: 49000.0,
        isUp: true,
      );
      expect(btc, isNot(equals(eth)));
    });

    test('copyWith updates currentPrice while keeping other fields', () {
      final original = _btc();
      final updated = original.copyWith(currentPrice: 55000.0);

      expect(updated.currentPrice, 55000.0);
      expect(updated.symbol, original.symbol);
      expect(updated.name, original.name);
      expect(updated.isUp, original.isUp);
    });

    test('copyWith updates isUp independently', () {
      final original = _btc(changePercent: 2.5, isUp: true);
      final updated = original.copyWith(isUp: false);

      expect(updated.isUp, isFalse);
      expect(updated.priceChangePercent24h, original.priceChangePercent24h);
    });

    test('volume24h is positive', () {
      expect(_btc().volume24h, greaterThan(0));
    });

    test('high24h is greater than or equal to low24h', () {
      final coin = _btc();
      expect(coin.high24h, greaterThanOrEqualTo(coin.low24h));
    });
  });
}
