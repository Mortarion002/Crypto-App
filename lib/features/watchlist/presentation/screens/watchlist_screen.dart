import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:crypto_pulse/features/watchlist/data/sparkline_provider.dart';
import 'package:crypto_pulse/features/market/presentation/controllers/market_controller.dart';
import 'package:crypto_pulse/features/market/domain/entities/coin.dart';
import 'package:crypto_pulse/features/coin_detail/domain/entities/kline_point.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';

String _sentimentLabel(Coin coin) {
  if (coin.priceChangePercent24h > 2) return 'BULLISH';
  if (coin.priceChangePercent24h < -2) return 'BEARISH';
  return 'NEUTRAL';
}

Color _sentimentColor(Coin coin) {
  if (coin.priceChangePercent24h > 2) return AppColors.mint;
  if (coin.priceChangePercent24h < -2) return AppColors.vibrantCoral;
  return AppColors.deepPurple;
}

class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  final _searchFocusNode = FocusNode();
  String _query = '';

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watchlist = ref.watch(watchlistControllerProvider);
    final marketState = ref.watch(marketControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.containerPadding,
                16,
                AppSpacing.containerPadding,
                0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceContainerHigh,
                      border: Border.all(color: AppColors.outline, width: 1),
                    ),
                    child: const Icon(
                      LucideIcons.user,
                      size: 18,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'WATCHLIST',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.vibrantCoral,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(LucideIcons.search, size: 20),
                    color: AppColors.onSurfaceVariant,
                    onPressed: _searchFocusNode.requestFocus,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // ── Search bar ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.containerPadding,
                16,
                AppSpacing.containerPadding,
                0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.canvasLevel1,
                  borderRadius: AppRadius.mdRadius,
                ),
                child: TextField(
                  focusNode: _searchFocusNode,
                  onChanged: (v) => setState(() => _query = v.toLowerCase()),
                  style: const TextStyle(color: AppColors.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Search coins...',
                    hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
                    prefixIcon: const Icon(
                      LucideIcons.search,
                      size: 18,
                      color: AppColors.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── List ───────────────────────────────────────────────────
            Expanded(
              child: marketState.when(
                data: (coins) {
                  final watchedCoins = coins
                      .where((c) => watchlist.contains(c.symbol))
                      .where(
                        (c) =>
                            _query.isEmpty ||
                            c.name.toLowerCase().contains(_query) ||
                            c.symbol.toLowerCase().contains(_query),
                      )
                      .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.containerPadding,
                    ),
                    itemCount: watchedCoins.length + 1,
                    itemBuilder: (context, index) {
                      if (index == watchedCoins.length) {
                        return _EmptyStateFooter(
                          hasCoins: watchedCoins.isNotEmpty,
                        );
                      }
                      return _WatchlistTile(
                        coin: watchedCoins[index],
                        onTap: () => context.pushNamed(
                          RouteNames.coinDetail,
                          pathParameters: {
                            'symbol': watchedCoins[index].symbol,
                          },
                        ),
                        onRemove: () => ref
                            .read(watchlistControllerProvider.notifier)
                            .toggleWatchlist(watchedCoins[index].symbol),
                      ).animate().fadeIn(
                        duration: 350.ms,
                        delay: (index * 60).ms,
                      );
                    },
                  );
                },
                loading: () => ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.containerPadding,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, _) => _TileSkeleton(),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'Failed to load.',
                    style: TextStyle(color: AppColors.vibrantCoral),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Watchlist tile with sparkline ────────────────────────────────────────────
class _WatchlistTile extends ConsumerWidget {
  final Coin coin;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _WatchlistTile({
    required this.coin,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sparklineState = ref.watch(coinSparklineProvider(coin.symbol));
    final sentimentColor = _sentimentColor(coin);
    final isUp = coin.isUp;
    final changeColor = isUp ? AppColors.mint : AppColors.vibrantCoral;
    final displaySymbol = coin.symbol.replaceAll('USDT', '');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.cardGap),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.canvasLevel1,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Column(
          children: [
            // Top row: icon+name+symbol | price+%
            Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: sentimentColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      displaySymbol.substring(0, 1),
                      style: TextStyle(
                        color: sentimentColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Symbol + name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displaySymbol,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        coin.name,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Price + change
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${_formatPrice(coin.currentPrice)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isUp
                              ? LucideIcons.trendingUp
                              : LucideIcons.trendingDown,
                          size: 12,
                          color: changeColor,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${isUp ? '+' : ''}${coin.priceChangePercent24h.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: changeColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Sparkline
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: sparklineState.when(
                data: (klines) =>
                    _Sparkline(klines: klines, color: sentimentColor),
                loading: () => Shimmer.fromColors(
                  baseColor: AppColors.canvasLevel1,
                  highlightColor: AppColors.surfaceBright,
                  child: Container(
                    height: 48,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),

            // Bottom row: sentiment | bookmark
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SENTIMENT: ${_sentimentLabel(coin)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: sentimentColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                GestureDetector(
                  onTap: onRemove,
                  child: const Icon(
                    LucideIcons.bookmark,
                    size: 18,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return price.toStringAsFixed(2);
    } else if (price >= 1) {
      return price.toStringAsFixed(4);
    } else {
      return price.toStringAsFixed(6);
    }
  }
}

// ── Sparkline ────────────────────────────────────────────────────────────────
class _Sparkline extends StatelessWidget {
  final List<KlinePoint> klines;
  final Color color;

  const _Sparkline({required this.klines, required this.color});

  @override
  Widget build(BuildContext context) {
    if (klines.isEmpty) return const SizedBox.shrink();

    final spots = klines
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.close))
        .toList();

    double minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final range = (maxY - minY).abs();
    if (range == 0) {
      minY -= 1;
      maxY += 1;
    } else {
      minY -= range * 0.1;
      maxY += range * 0.1;
    }

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state footer ───────────────────────────────────────────────────────
class _EmptyStateFooter extends StatelessWidget {
  final bool hasCoins;
  const _EmptyStateFooter({required this.hasCoins});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!hasCoins) ...[
          const SizedBox(height: 60),
          const Icon(
            LucideIcons.packageOpen,
            size: 48,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No coins saved yet.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track the assets you care about most.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.goNamed(RouteNames.home),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: AppRadius.fullRadius,
              ),
              child: Text(
                'Explore Market',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ] else ...[
          // Footer card when list has items but ends
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.canvasLevel1,
              borderRadius: AppRadius.mdRadius,
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.4),
                style: BorderStyle.solid,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  LucideIcons.packageOpen,
                  size: 32,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(height: 10),
                Text(
                  'No more coins saved',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Discover and track new assets\nto build your portfolio.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                const Icon(
                  LucideIcons.plus,
                  size: 20,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 100),
      ],
    );
  }
}

// ── Tile skeleton ────────────────────────────────────────────────────────────
class _TileSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.canvasLevel1,
      highlightColor: AppColors.surfaceBright,
      child: Container(
        height: 140,
        margin: const EdgeInsets.only(bottom: AppSpacing.cardGap),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.mdRadius,
        ),
      ),
    );
  }
}
