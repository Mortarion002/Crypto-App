import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/features/market/presentation/controllers/market_controller.dart';
import 'package:crypto_pulse/features/insights/presentation/controllers/insights_controller.dart';
import 'package:crypto_pulse/features/coin_detail/presentation/controllers/coin_detail_controller.dart';
import 'package:crypto_pulse/features/market/domain/entities/coin.dart';
import 'package:crypto_pulse/features/coin_detail/domain/entities/kline_point.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';

// Per-coin accent color
Color _coinColor(String symbol) {
  switch (symbol) {
    case 'BTCUSDT':
      return AppColors.vibrantCoral;
    case 'ETHUSDT':
      return AppColors.deepPurple;
    case 'SOLUSDT':
      return AppColors.cyanHighlight;
    case 'BNBUSDT':
      return AppColors.yellow;
    case 'ADAUSDT':
      return AppColors.mint;
    case 'XRPUSDT':
      return AppColors.primary;
    default:
      return AppColors.onSurfaceVariant;
  }
}

class MarketScreen extends ConsumerWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketState = ref.watch(marketControllerProvider);
    final insightsState = ref.watch(insightsControllerProvider);
    final btcKlines = ref.watch(
        coinDetailProvider(CoinDetailParams(symbol: 'BTCUSDT', interval: '1d')));

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(marketControllerProvider),
          color: AppColors.vibrantCoral,
          backgroundColor: AppColors.canvasLevel1,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── Header ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.containerPadding, 16, AppSpacing.containerPadding, 0),
                  child: _Header(),
                ),
              ),

              // ── Greeting + market selector ────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.containerPadding, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, Aman!',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Here is your market pulse.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                      _MarketSelector(),
                    ],
                  ),
                ),
              ),

              // ── Alert card (shown when high volatility) ──────────────
              SliverToBoxAdapter(
                child: insightsState.whenOrNull(
                      data: (insights) =>
                          insights.volatilityLevel == VolatilityLevel.high
                              ? _AlertCard(insights: insights)
                              : const SizedBox.shrink(),
                    ) ??
                    const SizedBox.shrink(),
              ),

              // ── Market Pulse card ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.containerPadding),
                  child: btcKlines.when(
                    data: (klines) => _MarketPulseCard(klines: klines),
                    loading: () => _shimmerCard(200),
                    error: (_, __) => _MarketPulseCard(klines: const []),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sectionMargin)),

              // ── Top Movers header ─────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.containerPadding),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Top Movers',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // ── Coin tiles ────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.containerPadding),
                sliver: marketState.when(
                  data: (coins) => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == coins.length) {
                          return const SizedBox(height: 100);
                        }
                        return _CoinTile(
                          coin: coins[index],
                          accentColor: _coinColor(coins[index].symbol),
                          onTap: () => context.pushNamed(
                            RouteNames.coinDetail,
                            pathParameters: {'symbol': coins[index].symbol},
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: (index * 60).ms)
                            .slideX(begin: 0.08, end: 0);
                      },
                      childCount: coins.length + 1,
                    ),
                  ),
                  loading: () => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, __) => _CoinTileSkeleton(),
                      childCount: 5,
                    ),
                  ),
                  error: (e, _) => SliverToBoxAdapter(
                    child: Center(
                      child: Text('Failed to load market data.',
                          style: TextStyle(color: AppColors.vibrantCoral)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerCard(double height) => Shimmer.fromColors(
        baseColor: AppColors.canvasLevel1,
        highlightColor: AppColors.surfaceBright,
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: AppRadius.lgRadius),
        ),
      );
}

// ── Header ──────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainerHigh,
            border: Border.all(color: AppColors.outline, width: 1),
          ),
          child: const Icon(LucideIcons.user, size: 18, color: AppColors.onSurfaceVariant),
        ),
        const Spacer(),
        Text(
          'CRYPTO PULSE',
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
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: const Icon(LucideIcons.bell, size: 20),
          color: AppColors.onSurfaceVariant,
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

// ── Market selector pill ─────────────────────────────────────────────────────
class _MarketSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.fullRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Crypto Market',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: 4),
          const Icon(LucideIcons.chevronDown,
              size: 14, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}

// ── Alert card ───────────────────────────────────────────────────────────────
class _AlertCard extends StatelessWidget {
  final MarketInsights insights;
  const _AlertCard({required this.insights});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.containerPadding, 0, AppSpacing.containerPadding, 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: AppColors.yellow.withValues(alpha: 0.5), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.yellow.withValues(alpha: 0.15),
                borderRadius: AppRadius.smRadius,
              ),
              child: const Icon(LucideIcons.triangleAlert,
                  size: 18, color: AppColors.yellow),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MARKET SHIFT DETECTED',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.yellow,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    insights.marketSubtext,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0),
    );
  }
}

// ── Market Pulse card ────────────────────────────────────────────────────────
class _MarketPulseCard extends ConsumerStatefulWidget {
  final List<KlinePoint> klines;
  const _MarketPulseCard({required this.klines});

  @override
  ConsumerState<_MarketPulseCard> createState() => _MarketPulseCardState();
}

class _MarketPulseCardState extends ConsumerState<_MarketPulseCard> {
  String _interval = '1D';

  static const _intervals = ['1D', '1W', '1M'];

  @override
  Widget build(BuildContext context) {
    final insightsState = ref.watch(insightsControllerProvider);
    final isUp = insightsState.whenOrNull(
          data: (i) => i.marketMood == MarketMood.bullish,
        ) ??
        true;

    final changeLabel = insightsState.whenOrNull(
          data: (i) {
            if (i.topGainers.isNotEmpty) {
              final pct =
                  i.topGainers.first.priceChangePercent24h.toStringAsFixed(2);
              return '+$pct%';
            }
            return '';
          },
        ) ??
        '';

    // Build chart spots from klines
    final spots = widget.klines.isNotEmpty
        ? widget.klines
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.close))
            .toList()
        : [const FlSpot(0, 0), const FlSpot(1, 1)];

    double minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    minY -= range * 0.1;
    maxY += range * 0.1;

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2B2B8A), Color(0xFF1A1A60), Color(0xFF0F0F3D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lgRadius,
      ),
      child: Stack(
        children: [
          // Chart background
          if (widget.klines.isNotEmpty)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: AppRadius.lgRadius,
                child: LineChart(
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
                        color: Colors.white.withValues(alpha: 0.6),
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Content overlay
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MARKET PULSE',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                    ),
                    // Interval pills
                    Row(
                      children: _intervals.map((iv) {
                        final sel = iv == _interval;
                        return GestureDetector(
                          onTap: () => setState(() => _interval = iv),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: sel
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.1),
                              borderRadius: AppRadius.fullRadius,
                            ),
                            child: Text(
                              iv,
                              style: TextStyle(
                                color: sel
                                    ? const Color(0xFF1A1A60)
                                    : Colors.white.withValues(alpha: 0.7),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        insightsState.when(
                          data: (i) {
                            final totalVol = i.topGainers.isEmpty && i.topLosers.isEmpty
                                ? '--'
                                : NumberFormat.compactCurrency(symbol: '\$').format(
                                    i.topGainers.fold(0.0, (s, c) => s + c.volume24h) +
                                        i.topLosers.fold(0.0, (s, c) => s + c.volume24h),
                                  );
                            return Text(
                              totalVol,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                              ),
                            );
                          },
                          loading: () => const Text('--',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800)),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                        Text(
                          'Combined Volume',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    if (changeLabel.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isUp
                              ? AppColors.mint.withValues(alpha: 0.25)
                              : AppColors.vibrantCoral.withValues(alpha: 0.25),
                          borderRadius: AppRadius.fullRadius,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isUp
                                  ? LucideIcons.trendingUp
                                  : LucideIcons.trendingDown,
                              size: 12,
                              color: isUp ? AppColors.mint : AppColors.vibrantCoral,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              changeLabel,
                              style: TextStyle(
                                color:
                                    isUp ? AppColors.mint : AppColors.vibrantCoral,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0);
  }
}

// ── Coin tile ────────────────────────────────────────────────────────────────
class _CoinTile extends StatelessWidget {
  final Coin coin;
  final Color accentColor;
  final VoidCallback onTap;

  const _CoinTile({
    required this.coin,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = coin.isUp;
    final changeColor = isUp ? AppColors.mint : AppColors.vibrantCoral;
    final currencyFormat =
        NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final percentFormat =
        NumberFormat.decimalPatternDigits(decimalDigits: 2);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.cardGap),
        decoration: BoxDecoration(
          color: AppColors.canvasLevel1,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Row(
          children: [
            // Accent border
            Container(
              width: 4,
              height: 72,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Coin icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  coin.symbol.replaceAll('USDT', '').substring(0, 1),
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Name + ticker
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    coin.symbol.replaceAll('USDT', ''),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),

            // Price + change
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat.format(coin.currentPrice),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isUp ? LucideIcons.trendingUp : LucideIcons.trendingDown,
                        size: 12,
                        color: changeColor,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${isUp ? '+' : ''}${percentFormat.format(coin.priceChangePercent24h)}%',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: changeColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skeletons ────────────────────────────────────────────────────────────────
class _CoinTileSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.canvasLevel1,
      highlightColor: AppColors.surfaceBright,
      child: Container(
        height: 72,
        margin: const EdgeInsets.only(bottom: AppSpacing.cardGap),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.mdRadius,
        ),
      ),
    );
  }
}
