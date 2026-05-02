import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto_pulse/core/providers/shared_prefs_provider.dart';

final watchlistControllerProvider =
    NotifierProvider<WatchlistController, List<String>>(() => WatchlistController());

class WatchlistController extends Notifier<List<String>> {
  static const _key = 'user_watchlist';

  @override
  List<String> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final local = prefs.getStringList(_key) ?? [];
    _mergeFromCloud(local);
    return local;
  }

  Future<void> toggleWatchlist(String symbol) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final list = List<String>.from(state);

    if (list.contains(symbol)) {
      list.remove(symbol);
      _cloudRemove(symbol);
    } else {
      list.add(symbol);
      _cloudAdd(symbol);
    }

    await prefs.setStringList(_key, list);
    state = list;
  }

  bool isWatched(String symbol) => state.contains(symbol);

  // ── Cloud sync (fire-and-forget) ─────────────────────────────────────────

  void _mergeFromCloud(List<String> local) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    try {
      final rows = await Supabase.instance.client
          .from('watchlist_items')
          .select('symbol')
          .eq('user_id', user.id);
      final cloud = (rows as List).map((e) => e['symbol'] as String).toList();
      final merged = {...local, ...cloud}.toList();
      if (merged.length != local.length) {
        final prefs = ref.read(sharedPreferencesProvider);
        await prefs.setStringList(_key, merged);
        state = merged;
      }
    } catch (_) {}
  }

  void _cloudAdd(String symbol) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    Supabase.instance.client
        .from('watchlist_items')
        .upsert({'user_id': user.id, 'symbol': symbol})
        .then((_) {}, onError: (_) {});
  }

  void _cloudRemove(String symbol) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    Supabase.instance.client
        .from('watchlist_items')
        .delete()
        .eq('user_id', user.id)
        .eq('symbol', symbol)
        .then((_) {}, onError: (_) {});
  }
}
