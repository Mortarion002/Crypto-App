import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto_pulse/core/providers/shared_prefs_provider.dart';
import 'package:crypto_pulse/features/watchlist/presentation/controllers/watchlist_controller.dart';

// ── Setup helpers ────────────────────────────────────────────────────────────

Future<ProviderContainer> _makeContainer({
  Map<String, Object> prefsData = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefsData);
  final prefs = await SharedPreferences.getInstance();
  return ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // SharedPreferences mock MUST be set before Supabase.initialize because
    // Supabase uses SharedPreferencesGotrueAsyncStorage internally.
    SharedPreferences.setMockInitialValues({});
    try {
      await Supabase.initialize(
        url: 'https://vhnkcjubcmerwebfteoq.supabase.co',
        anonKey: 'sb_publishable_ApfMUgTvLnqbamq-RF6qlw_-pq5hJeq',
      );
    } catch (_) {
      // Already initialized by a previous test run
    }
  });

  group('WatchlistController — initial state', () {
    test('starts empty when SharedPreferences has no saved watchlist', () async {
      final container = await _makeContainer();
      addTearDown(container.dispose);

      expect(container.read(watchlistControllerProvider), isEmpty);
    });

    test('loads persisted symbols from SharedPreferences', () async {
      final container = await _makeContainer(prefsData: {
        'user_watchlist': ['BTCUSDT', 'ETHUSDT'],
      });
      addTearDown(container.dispose);

      final state = container.read(watchlistControllerProvider);
      expect(state, containsAll(['BTCUSDT', 'ETHUSDT']));
      expect(state, hasLength(2));
    });
  });

  group('WatchlistController.toggleWatchlist', () {
    test('adds a new symbol to an empty list', () async {
      final container = await _makeContainer();
      addTearDown(container.dispose);

      await container
          .read(watchlistControllerProvider.notifier)
          .toggleWatchlist('BTCUSDT');

      expect(container.read(watchlistControllerProvider), contains('BTCUSDT'));
    });

    test('removes an existing symbol from the list', () async {
      final container = await _makeContainer(prefsData: {
        'user_watchlist': ['BTCUSDT'],
      });
      addTearDown(container.dispose);

      await container
          .read(watchlistControllerProvider.notifier)
          .toggleWatchlist('BTCUSDT');

      expect(
          container.read(watchlistControllerProvider),
          isNot(contains('BTCUSDT')));
    });

    test('add then remove returns to empty', () async {
      final container = await _makeContainer();
      addTearDown(container.dispose);

      final notifier =
          container.read(watchlistControllerProvider.notifier);
      await notifier.toggleWatchlist('SOLUSDT');
      await notifier.toggleWatchlist('SOLUSDT');

      expect(container.read(watchlistControllerProvider), isEmpty);
    });

    test('can add multiple different symbols', () async {
      final container = await _makeContainer();
      addTearDown(container.dispose);

      final notifier =
          container.read(watchlistControllerProvider.notifier);
      await notifier.toggleWatchlist('BTCUSDT');
      await notifier.toggleWatchlist('ETHUSDT');
      await notifier.toggleWatchlist('SOLUSDT');

      final state = container.read(watchlistControllerProvider);
      expect(state, hasLength(3));
      expect(state, containsAll(['BTCUSDT', 'ETHUSDT', 'SOLUSDT']));
    });

    test('removing one symbol does not affect others', () async {
      final container = await _makeContainer(prefsData: {
        'user_watchlist': ['BTCUSDT', 'ETHUSDT', 'SOLUSDT'],
      });
      addTearDown(container.dispose);

      await container
          .read(watchlistControllerProvider.notifier)
          .toggleWatchlist('ETHUSDT');

      final state = container.read(watchlistControllerProvider);
      expect(state, isNot(contains('ETHUSDT')));
      expect(state, containsAll(['BTCUSDT', 'SOLUSDT']));
    });

    test('persists changes to SharedPreferences', () async {
      final container = await _makeContainer();
      addTearDown(container.dispose);

      await container
          .read(watchlistControllerProvider.notifier)
          .toggleWatchlist('BNBUSDT');

      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('user_watchlist');
      expect(saved, contains('BNBUSDT'));
    });

    test('removal is persisted to SharedPreferences', () async {
      final container = await _makeContainer(prefsData: {
        'user_watchlist': ['ADAUSDT'],
      });
      addTearDown(container.dispose);

      await container
          .read(watchlistControllerProvider.notifier)
          .toggleWatchlist('ADAUSDT');

      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('user_watchlist');
      expect(saved, isNot(contains('ADAUSDT')));
    });
  });

  group('WatchlistController.isWatched', () {
    test('returns true for a symbol in the watchlist', () async {
      final container = await _makeContainer(prefsData: {
        'user_watchlist': ['ETHUSDT'],
      });
      addTearDown(container.dispose);

      final notifier =
          container.read(watchlistControllerProvider.notifier);
      expect(notifier.isWatched('ETHUSDT'), isTrue);
    });

    test('returns false for a symbol not in the watchlist', () async {
      final container = await _makeContainer();
      addTearDown(container.dispose);

      final notifier =
          container.read(watchlistControllerProvider.notifier);
      expect(notifier.isWatched('XRPUSDT'), isFalse);
    });

    test('reflects state after toggle', () async {
      final container = await _makeContainer();
      addTearDown(container.dispose);

      final notifier =
          container.read(watchlistControllerProvider.notifier);

      expect(notifier.isWatched('BTCUSDT'), isFalse);
      await notifier.toggleWatchlist('BTCUSDT');
      expect(notifier.isWatched('BTCUSDT'), isTrue);
      await notifier.toggleWatchlist('BTCUSDT');
      expect(notifier.isWatched('BTCUSDT'), isFalse);
    });
  });
}
