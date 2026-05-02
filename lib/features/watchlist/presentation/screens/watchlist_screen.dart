import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_pulse/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:crypto_pulse/features/market/presentation/controllers/market_controller.dart';
import 'package:crypto_pulse/features/market/presentation/widgets/coin_card.dart';
import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlist = ref.watch(watchlistControllerProvider);
    final marketState = ref.watch(marketControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: marketState.when(
        data: (coins) {
          final watchedCoins = coins.where((c) => watchlist.contains(c.symbol)).toList();

          if (watchedCoins.isEmpty) {
            return Center(
              child: Text(
                'Your watchlist is empty.\nGo to Market Pulse to add coins!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.containerPadding),
            itemCount: watchedCoins.length + 1, // +1 for navbar padding
            itemBuilder: (context, index) {
              if (index == watchedCoins.length) {
                return const SizedBox(height: 100);
              }
              final coin = watchedCoins[index];
              return Dismissible(
                key: Key(coin.symbol),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  ref.read(watchlistControllerProvider.notifier).toggleWatchlist(coin.symbol);
                },
                child: CoinCard(
                  coin: coin,
                  onTap: () {
                    context.pushNamed(
                      RouteNames.coinDetail,
                      pathParameters: {'symbol': coin.symbol},
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
