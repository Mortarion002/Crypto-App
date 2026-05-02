import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/core/providers/shared_prefs_provider.dart';

final watchlistControllerProvider = NotifierProvider<WatchlistController, List<String>>(() {
  return WatchlistController();
});

class WatchlistController extends Notifier<List<String>> {
  static const _key = 'user_watchlist';

  @override
  List<String> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> toggleWatchlist(String symbol) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final currentList = List<String>.from(state);

    if (currentList.contains(symbol)) {
      currentList.remove(symbol);
    } else {
      currentList.add(symbol);
    }

    await prefs.setStringList(_key, currentList);
    state = currentList;
  }

  bool isWatched(String symbol) {
    return state.contains(symbol);
  }
}
