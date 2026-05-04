import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/features/auth/presentation/controllers/auth_controller.dart';
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

// ── Market filter ─────────────────────────────────────────────────────────────
enum _MarketFilter {
  all,
  gainers,
  losers;

  String get label {
    switch (this) {
      case _MarketFilter.all:
        return 'All Markets';
      case _MarketFilter.gainers:
        return 'Top Gainers';
      case _MarketFilter.losers:
        return 'Top Losers';
    }
  }

  List<Coin> apply(List<Coin> coins) {
    switch (this) {
      case _MarketFilter.all:
        return coins;
      case _MarketFilter.gainers:
        return coins.where((c) => c.isUp).toList()
          ..sort(
            (a, b) => b.priceChangePercent24h.compareTo(
              a.priceChangePercent24h,
            ),
          );
      case _MarketFilter.losers:
        return coins.where((c) => !c.isUp).toList()
          ..sort(
            (a, b) => a.priceChangePercent24h.compareTo(
              b.priceChangePercent24h,
            ),
          );
    }
  }
}

// ── Notification data model ──────────────────────────────────────────────────
class _NotifData {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
  final bool isNew;

  const _NotifData({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
    required this.isNew,
  });
}

const _kNotifications = [
  _NotifData(
    icon: LucideIcons.trendingUp,
    color: AppColors.mint,
    title: 'BTC surged +5.2% in 24h',
    body: 'Bitcoin broke resistance at \$67,000 with high volume.',
    time: '2m ago',
    isNew: true,
  ),
  _NotifData(
    icon: LucideIcons.triangleAlert,
    color: AppColors.yellow,
    title: 'High volatility detected',
    body: 'Average market movement exceeds 5% — exercise caution.',
    time: '15m ago',
    isNew: true,
  ),
  _NotifData(
    icon: LucideIcons.bell,
    color: AppColors.cyanHighlight,
    title: 'SOL added to watchlist',
    body: 'Solana is now tracked. Current price: \$142.30.',
    time: '1h ago',
    isNew: false,
  ),
  _NotifData(
    icon: LucideIcons.trendingUp,
    color: AppColors.deepPurple,
    title: 'Market mood: BULLISH',
    body: 'Gainers now outnumber losers by 2× across tracked coins.',
    time: '3h ago',
    isNew: false,
  ),
  _NotifData(
    icon: LucideIcons.trendingDown,
    color: AppColors.vibrantCoral,
    title: 'ETH down -3.1% in 24h',
    body: 'Ethereum continues its correction from the weekly high.',
    time: '5h ago',
    isNew: false,
  ),
];

// ── Market Screen ─────────────────────────────────────────────────────────────
class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  _MarketFilter _filter = _MarketFilter.all;

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(
        current: _filter,
        onSelect: (f) {
          setState(() => _filter = f);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final marketState = ref.watch(marketControllerProvider);
    final insightsState = ref.watch(insightsControllerProvider);
    final user = ref.watch(authControllerProvider).asData?.value;
    final displayName = (user?.displayName.trim().isNotEmpty ?? false)
        ? user!.displayName
        : 'there';
    final btcKlines = ref.watch(
      coinDetailProvider(CoinDetailParams(symbol: 'BTCUSDT', interval: '1d')),
    );

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
                    AppSpacing.containerPadding,
                    16,
                    AppSpacing.containerPadding,
                    0,
                  ),
                  child: _Header(
                    unreadCount: 2,
                    onSearch: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const _SearchSheet(),
                    ),
                    onAlerts: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: false,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const _NotificationsSheet(),
                    ),
                  ),
                ),
              ),

              // ── Greeting + market selector ────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.containerPadding,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, $displayName!',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Here is your market pulse.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                      _MarketSelector(
                        label: _filter.label,
                        onTap: _showFilterSheet,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Alert card (shown when high volatility) ──────────────
              SliverToBoxAdapter(
                child:
                    insightsState.whenOrNull(
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
                    horizontal: AppSpacing.containerPadding,
                  ),
                  child: btcKlines.when(
                    data: (klines) => _MarketPulseCard(klines: klines),
                    loading: () => _shimmerCard(200),
                    error: (_, _) => _MarketPulseCard(klines: const []),
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.sectionMargin),
              ),

              // ── Section header ────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerPadding,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _filter == _MarketFilter.all
                            ? 'Top Movers'
                            : _filter.label,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      // Active filter badge (shown when not All)
                      if (_filter != _MarketFilter.all)
                        GestureDetector(
                          onTap: () => setState(
                            () => _filter = _MarketFilter.all,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.vibrantCoral.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: AppRadius.fullRadius,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Clear',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelSmall?.copyWith(
                                    color: AppColors.vibrantCoral,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  LucideIcons.x,
                                  size: 12,
                                  color: AppColors.vibrantCoral,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // ── Coin tiles ────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerPadding,
                ),
                sliver: marketState.when(
                  data: (coins) {
                    final displayed = _filter.apply(coins);
                    if (displayed.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text(
                              'No ${_filter.label.toLowerCase()} right now.',
                              style: TextStyle(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == displayed.length) {
                          return const SizedBox(height: 100);
                        }
                        return _CoinTile(
                              coin: displayed[index],
                              accentColor: _coinColor(displayed[index].symbol),
                              onTap: () => context.pushNamed(
                                RouteNames.coinDetail,
                                pathParameters: {
                                  'symbol': displayed[index].symbol,
                                },
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: (index * 60).ms)
                            .slideX(begin: 0.08, end: 0);
                      }, childCount: displayed.length + 1),
                    );
                  },
                  loading: () => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, _) => _CoinTileSkeleton(),
                      childCount: 5,
                    ),
                  ),
                  error: (_, _) => SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Failed to load market data.',
                        style: TextStyle(color: AppColors.vibrantCoral),
                      ),
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
        color: Colors.white,
        borderRadius: AppRadius.lgRadius,
      ),
    ),
  );
}

// ── Header ───────────────────────────────────────────────────────────────────
class _Header extends ConsumerWidget {
  final VoidCallback onSearch;
  final VoidCallback onAlerts;
  final int unreadCount;

  const _Header({
    required this.onSearch,
    required this.onAlerts,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).asData?.value;
    final displayName = (user?.displayName.trim().isNotEmpty ?? false)
        ? user!.displayName
        : 'U';
    final firstLetter = displayName[0].toUpperCase();

    return Row(
      children: [
        // Profile avatar with first letter
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.vibrantCoral.withValues(alpha: 0.2),
            border: Border.all(color: AppColors.vibrantCoral.withValues(alpha: 0.5), width: 1),
          ),
          child: Center(
            child: Text(
              firstLetter,
              style: const TextStyle(
                color: AppColors.vibrantCoral,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const Spacer(),
        // Centered CRYPTO PULSE
        Text(
          'CRYPTO PULSE',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.vibrantCoral,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const Spacer(),
        // Search
        IconButton(
          icon: const Icon(LucideIcons.search, size: 20),
          color: AppColors.onSurfaceVariant,
          onPressed: onSearch,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 12),
        // Bell with unread badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(LucideIcons.bell, size: 20),
              color: AppColors.onSurfaceVariant,
              onPressed: onAlerts,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            if (unreadCount > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: AppColors.vibrantCoral,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.background,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ── Market selector pill ──────────────────────────────────────────────────────
class _MarketSelector extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MarketSelector({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: AppRadius.fullRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              LucideIcons.chevronDown,
              size: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Alert card ────────────────────────────────────────────────────────────────
class _AlertCard extends StatelessWidget {
  final MarketInsights insights;
  const _AlertCard({required this.insights});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.containerPadding,
        0,
        AppSpacing.containerPadding,
        16,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(
            color: AppColors.yellow.withValues(alpha: 0.5),
            width: 1,
          ),
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
              child: const Icon(
                LucideIcons.triangleAlert,
                size: 18,
                color: AppColors.yellow,
              ),
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

// ── Market Pulse card ─────────────────────────────────────────────────────────
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
    final allCoins =
        ref.watch(marketControllerProvider).asData?.value ?? [];

    final isUp =
        insightsState.whenOrNull(
          data: (i) => i.marketMood == MarketMood.bullish,
        ) ??
        true;

    final changeLabel =
        insightsState.whenOrNull(
          data: (i) {
            if (i.topGainers.isNotEmpty) {
              final pct = i.topGainers.first.priceChangePercent24h
                  .toStringAsFixed(2);
              return '+$pct%';
            }
            return '';
          },
        ) ??
        '';

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

    final totalVol = allCoins.fold(0.0, (double s, c) => s + c.volume24h);

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
                    Row(
                      children: _intervals.map((iv) {
                        final sel = iv == _interval;
                        return GestureDetector(
                          onTap: () => setState(() => _interval = iv),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
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
                        Text(
                          totalVol > 0
                              ? NumberFormat.compactCurrency(
                                  symbol: '\$',
                                ).format(totalVol)
                              : '--',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
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
                          horizontal: 10,
                          vertical: 4,
                        ),
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
                              color: isUp
                                  ? AppColors.mint
                                  : AppColors.vibrantCoral,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              changeLabel,
                              style: TextStyle(
                                color: isUp
                                    ? AppColors.mint
                                    : AppColors.vibrantCoral,
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

// ── Coin tile ─────────────────────────────────────────────────────────────────
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
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final percentFormat = NumberFormat.decimalPatternDigits(decimalDigits: 2);

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
                        isUp
                            ? LucideIcons.trendingUp
                            : LucideIcons.trendingDown,
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

// ── Coin tile skeleton ────────────────────────────────────────────────────────
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

// ── Filter Sheet ──────────────────────────────────────────────────────────────
class _FilterSheet extends StatelessWidget {
  final _MarketFilter current;
  final ValueChanged<_MarketFilter> onSelect;

  const _FilterSheet({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'FILTER MARKET',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          // Options
          ..._MarketFilter.values.map(
            (f) => _FilterOption(
              filter: f,
              isSelected: f == current,
              onTap: () => onSelect(f),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final _MarketFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    switch (filter) {
      case _MarketFilter.all:
        return LucideIcons.layoutGrid;
      case _MarketFilter.gainers:
        return LucideIcons.trendingUp;
      case _MarketFilter.losers:
        return LucideIcons.trendingDown;
    }
  }

  Color get _color {
    switch (filter) {
      case _MarketFilter.all:
        return AppColors.onSurfaceVariant;
      case _MarketFilter.gainers:
        return AppColors.mint;
      case _MarketFilter.losers:
        return AppColors.vibrantCoral;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? _color.withValues(alpha: 0.08)
              : Colors.transparent,
          border: Border(
            top: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: isSelected ? 0.15 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, size: 16, color: _color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                filter.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? AppColors.onSurface
                      : AppColors.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                LucideIcons.check,
                size: 18,
                color: _color,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Search Sheet ──────────────────────────────────────────────────────────────
class _SearchSheet extends ConsumerStatefulWidget {
  const _SearchSheet();

  @override
  ConsumerState<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends ConsumerState<_SearchSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coins = ref.watch(marketControllerProvider).asData?.value ?? [];
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? coins
        : coins
              .where(
                (c) =>
                    c.symbol.toLowerCase().contains(q) ||
                    c.name.toLowerCase().contains(q),
              )
              .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.87,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Search row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: (v) => setState(() => _query = v),
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search coins...',
                      hintStyle: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 15,
                      ),
                      prefixIcon: const Icon(
                        LucideIcons.search,
                        size: 18,
                        color: AppColors.onSurfaceVariant,
                      ),
                      filled: true,
                      fillColor: AppColors.canvasLevel1,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide(
                          color: AppColors.vibrantCoral.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.vibrantCoral,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Result count
          if (q.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                '${filtered.length} result${filtered.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ),

          // List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.search,
                          size: 44,
                          color: AppColors.outlineVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No coins match "$_query"',
                          style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final coin = filtered[index];
                      return _CoinTile(
                        coin: coin,
                        accentColor: _coinColor(coin.symbol),
                        onTap: () {
                          final router = GoRouter.of(context);
                          Navigator.pop(context);
                          router.pushNamed(
                            RouteNames.coinDetail,
                            pathParameters: {'symbol': coin.symbol},
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Notifications Sheet ───────────────────────────────────────────────────────
class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NOTIFICATIONS',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.vibrantCoral.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Text(
                      '2 NEW',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.vibrantCoral,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable notification rows
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ..._kNotifications.map((item) => _NotifRow(item: item)),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifRow extends StatelessWidget {
  final _NotifData item;
  const _NotifRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon bubble
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 16, color: item.color),
          ),
          const SizedBox(width: 14),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    if (item.isNew)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.vibrantCoral,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  item.body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.time,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.outline,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
