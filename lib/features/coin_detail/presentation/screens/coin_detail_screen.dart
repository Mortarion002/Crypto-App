import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_pulse/features/market/presentation/controllers/market_controller.dart';
import 'package:crypto_pulse/features/coin_detail/presentation/controllers/coin_detail_controller.dart';
import 'package:crypto_pulse/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:crypto_pulse/features/coin_detail/presentation/widgets/coin_price_chart.dart';
import 'package:crypto_pulse/features/coin_detail/presentation/widgets/chart_interval_selector.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CoinDetailScreen extends ConsumerStatefulWidget {
  final String symbol;

  const CoinDetailScreen({super.key, required this.symbol});

  @override
  ConsumerState<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends ConsumerState<CoinDetailScreen> {
  String _selectedInterval = '1h';

  @override
  Widget build(BuildContext context) {
    // Read the current coin details from the market state
    final marketState = ref.watch(marketControllerProvider);
    final coin = marketState.value?.firstWhere((c) => c.symbol == widget.symbol);

    final params = CoinDetailParams(symbol: widget.symbol, interval: _selectedInterval);
    final klineState = ref.watch(coinDetailProvider(params));
    
    final isWatched = ref.watch(watchlistControllerProvider.select((list) => list.contains(widget.symbol)));

    if (coin == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Coin not found')),
      );
    }

    final isUp = coin.isUp;
    final color = isUp ? AppColors.mint : AppColors.vibrantCoral;
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final percentFormat = NumberFormat.decimalPatternDigits(decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
        title: Text('${coin.name} (${coin.symbol.replaceAll('USDT', '')})'),
        actions: [
          IconButton(
            icon: Icon(
              LucideIcons.star,
              color: isWatched ? AppColors.cyanHighlight : null,
              // Filled star not directly available in standard Lucide Icons without custom drawing, 
              // so using color to indicate active state
            ), 
            onPressed: () {
              ref.read(watchlistControllerProvider.notifier).toggleWatchlist(coin.symbol);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currencyFormat.format(coin.currentPrice),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isUp ? LucideIcons.trendingUp : LucideIcons.trendingDown,
                  color: color,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '${percentFormat.format(coin.priceChangePercent24h.abs())}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '  Past 24h',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sectionMargin),
            
            // Chart Area
            klineState.when(
              data: (klines) => CoinPriceChart(klines: klines, isBullish: isUp),
              loading: () => const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SizedBox(
                height: 300,
                child: Center(child: Text('Failed to load chart: $e')),
              ),
            ),
            
            const SizedBox(height: 24),
            
            ChartIntervalSelector(
              selectedInterval: _selectedInterval,
              onIntervalSelected: (interval) {
                setState(() {
                  _selectedInterval = interval;
                });
              },
            ),

            const SizedBox(height: AppSpacing.sectionMargin),
            Text(
              'MARKET STATS',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _buildStatRow('24h High', currencyFormat.format(coin.high24h)),
            _buildStatRow('24h Low', currencyFormat.format(coin.low24h)),
            _buildStatRow('24h Volume', currencyFormat.format(coin.volume24h)),
            
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
