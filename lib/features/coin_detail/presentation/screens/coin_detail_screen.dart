import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:crypto_pulse/features/market/presentation/controllers/market_controller.dart';
import 'package:crypto_pulse/features/coin_detail/presentation/controllers/coin_detail_controller.dart';
import 'package:crypto_pulse/features/coin_detail/domain/entities/kline_point.dart';
import 'package:crypto_pulse/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';

class CoinDetailScreen extends ConsumerStatefulWidget {
  final String symbol;
  const CoinDetailScreen({super.key, required this.symbol});

  @override
  ConsumerState<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends ConsumerState<CoinDetailScreen> {
  String _interval = '1d';

  static const _intervalLabels = ['1H', '4H', '1D', '1W'];
  static const _intervalValues = ['1h', '4h', '1d', '1w'];

  @override
  Widget build(BuildContext context) {
    final marketState = ref.watch(marketControllerProvider);
    final coin = marketState.value?.firstWhere(
      (c) => c.symbol == widget.symbol,
      orElse: () => marketState.value!.first,
    );

    final params = CoinDetailParams(symbol: widget.symbol, interval: _interval);
    final klineState = ref.watch(coinDetailProvider(params));
    final isWatched = ref.watch(watchlistControllerProvider
        .select((list) => list.contains(widget.symbol)));

    if (coin == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isUp = coin.isUp;
    final accentColor = isUp ? AppColors.mint : AppColors.vibrantCoral;
    final currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final pct = NumberFormat.decimalPatternDigits(decimalDigits: 2);

    // Volatility: (high-low)/price * 100
    final volPct = coin.currentPrice > 0
        ? (coin.high24h - coin.low24h) / coin.currentPrice * 100
        : 0.0;
    final String volLabel;
    if (volPct < 2) {
      volLabel = 'Low (${volPct.toStringAsFixed(1)}%)';
    } else if (volPct < 5) {
      volLabel = 'Moderate (${volPct.toStringAsFixed(1)}%)';
    } else {
      volLabel = 'High (${volPct.toStringAsFixed(1)}%)';
    }

    // Sentiment bar value 0.0–1.0 centred at 0.5
    final sentimentValue =
        ((coin.priceChangePercent24h + 10) / 20).clamp(0.0, 1.0);
    final bullPct = (sentimentValue * 100).round();

    final displaySymbol = widget.symbol.replaceAll('USDT', '');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: back + title ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerPadding, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.arrowLeft,
                            size: 18, color: AppColors.onSurface),
                      ),
                    ),
                  ),
                  Text(
                    coin.name.toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                  ),
                ],
              ),
            ),

            // ── Interval selector (top) ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerPadding, vertical: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.canvasLevel1,
                  borderRadius: AppRadius.fullRadius,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_intervalLabels.length, (i) {
                    final sel = _intervalValues[i] == _interval;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _interval = _intervalValues[i]),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.surfaceContainerHighest
                                : Colors.transparent,
                            borderRadius: AppRadius.fullRadius,
                          ),
                          child: Center(
                            child: Text(
                              _intervalLabels[i],
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: sel
                                        ? AppColors.onSurface
                                        : AppColors.onSurfaceVariant,
                                    fontWeight: sel
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // ── Scrollable body ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.containerPadding),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // ── Price card with mini-chart ─────────────────────
                    _PriceCard(
                      coin: coin,
                      accentColor: accentColor,
                      isUp: isUp,
                      currency: currency,
                      pct: pct,
                      klineState: klineState,
                    ),

                    const SizedBox(height: 16),

                    // ── Market sentiment bar ───────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.canvasLevel1,
                        borderRadius: AppRadius.mdRadius,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MARKET SENTIMENT',
                            style:
                                Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      letterSpacing: 1.2,
                                    ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Text(
                                'Bearish',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: AppColors.vibrantCoral),
                              ),
                              const Spacer(),
                              Text(
                                'Bullish',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: AppColors.mint),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '$bullPct%',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: accentColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: AppRadius.fullRadius,
                            child: SizedBox(
                              height: 8,
                              child: LinearProgressIndicator(
                                value: sentimentValue,
                                backgroundColor: AppColors.vibrantCoral
                                    .withValues(alpha: 0.35),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.mint),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── 2×2 stats grid ─────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: LucideIcons.arrowUpToLine,
                            label: '24H HIGH',
                            value: currency.format(coin.high24h),
                            iconColor: AppColors.mint,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: LucideIcons.arrowDownToLine,
                            label: '24H LOW',
                            value: currency.format(coin.low24h),
                            iconColor: AppColors.vibrantCoral,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: LucideIcons.layers,
                            label: 'VOLUME',
                            value:
                                '${NumberFormat.compact().format(coin.volume24h)} $displaySymbol',
                            iconColor: AppColors.deepPurple,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: LucideIcons.activity,
                            label: 'VOLATILITY',
                            value: volLabel,
                            iconColor: AppColors.yellow,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // ── Watchlist button (pinned bottom) ───────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.containerPadding,
                  12,
                  AppSpacing.containerPadding,
                  20),
              child: GestureDetector(
                onTap: () => ref
                    .read(watchlistControllerProvider.notifier)
                    .toggleWatchlist(widget.symbol),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: isWatched
                        ? AppColors.surfaceContainerHigh
                        : AppColors.cyanHighlight,
                    borderRadius: AppRadius.fullRadius,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isWatched
                            ? LucideIcons.bookmarkCheck
                            : LucideIcons.bookmarkPlus,
                        size: 20,
                        color: isWatched
                            ? AppColors.onSurfaceVariant
                            : AppColors.canvasLevel0,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isWatched ? 'SAVED TO WATCHLIST' : 'ADD TO WATCHLIST',
                        style: TextStyle(
                          color: isWatched
                              ? AppColors.onSurfaceVariant
                              : AppColors.canvasLevel0,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
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

// ── Price card ───────────────────────────────────────────────────────────────
class _PriceCard extends StatelessWidget {
  final dynamic coin;
  final Color accentColor;
  final bool isUp;
  final NumberFormat currency;
  final NumberFormat pct;
  final AsyncValue<List<KlinePoint>> klineState;

  const _PriceCard({
    required this.coin,
    required this.accentColor,
    required this.isUp,
    required this.currency,
    required this.pct,
    required this.klineState,
  });

  @override
  Widget build(BuildContext context) {
    final spots = klineState.whenOrNull(
          data: (klines) => klines.isEmpty
              ? null
              : klines
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.close))
                  .toList(),
        ) ??
        [const FlSpot(0, 0)];

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.canvasLevel1,
        borderRadius: AppRadius.mdRadius,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Mini sparkline background
          if (spots.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 100,
              child: LineChart(
                LineChartData(
                  minY: minY - (maxY - minY) * 0.3,
                  maxY: maxY + (maxY - minY) * 0.1,
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: const LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: AppColors.deepPurple.withValues(alpha: 0.7),
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.deepPurple.withValues(alpha: 0.35),
                            AppColors.deepPurple.withValues(alpha: 0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Price content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LIVE PRICE',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        currency.format(coin.currentPrice),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                      ),
                    ),
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.85),
                        borderRadius: AppRadius.fullRadius,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isUp
                                ? LucideIcons.trendingUp
                                : LucideIcons.trendingDown,
                            size: 13,
                            color: isUp
                                ? AppColors.canvasLevel0
                                : Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${isUp ? '+' : ''}${pct.format(coin.priceChangePercent24h)}%',
                            style: TextStyle(
                              color: isUp
                                  ? AppColors.canvasLevel0
                                  : Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '24H VOLUME',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 1.0,
                          ),
                    ),
                    Text(
                      NumberFormat.compactCurrency(symbol: '\$')
                          .format(coin.volume24h),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat card ────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.canvasLevel1,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 10),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.0,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
