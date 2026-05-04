import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/features/auth/presentation/controllers/auth_controller.dart';
import 'package:crypto_pulse/features/insights/presentation/controllers/insights_controller.dart';
import 'package:crypto_pulse/features/market/domain/entities/coin.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsState = ref.watch(insightsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: insightsState.when(
          data: (insights) => _InsightsBody(insights: insights),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              'Error loading insights.',
              style: TextStyle(color: AppColors.vibrantCoral),
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightsBody extends StatefulWidget {
  final MarketInsights insights;
  const _InsightsBody({required this.insights});

  @override
  State<_InsightsBody> createState() => _InsightsBodyState();
}

class _InsightsBodyState extends State<_InsightsBody> {
  final _scrollController = ScrollController();
  final _volatilityKey = GlobalKey();
  final _gainersKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // ── Header ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.containerPadding,
              16,
              AppSpacing.containerPadding,
              0,
            ),
            child: _InsightsHeader(
              onSearch: () => context.goNamed(RouteNames.watchlist),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // ── Market Mood card ─────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.containerPadding,
            ),
            child: _MarketMoodCard(insights: widget.insights),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // ── Volatility gauge ─────────────────────────────────────────────
        SliverToBoxAdapter(
          key: _volatilityKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.containerPadding,
            ),
            child: _VolatilityCard(insights: widget.insights),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // ── AI Protocol insight card ─────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.containerPadding,
            ),
            child: _InsightProtocolCard(
              insights: widget.insights,
              onViewGainers: () => _scrollToKey(_gainersKey),
              onCheckVolatility: () => _scrollToKey(_volatilityKey),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // ── Top Gainers ──────────────────────────────────────────────────
        if (widget.insights.topGainers.isNotEmpty) ...[
          SliverToBoxAdapter(
            key: _gainersKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerPadding,
              ),
              child: _SectionHeader(
                icon: LucideIcons.trendingUp,
                label: 'Top Gainers',
                color: AppColors.mint,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.containerPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _MoverTile(
                  coin: widget.insights.topGainers[i],
                  isGainer: true,
                ).animate().fadeIn(delay: (i * 80).ms),
                childCount: widget.insights.topGainers.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],

        // ── Top Losers ───────────────────────────────────────────────────
        if (widget.insights.topLosers.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerPadding,
              ),
              child: _SectionHeader(
                icon: LucideIcons.trendingDown,
                label: 'Top Losers',
                color: AppColors.vibrantCoral,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.containerPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _MoverTile(
                  coin: widget.insights.topLosers[i],
                  isGainer: false,
                ).animate().fadeIn(delay: (i * 80).ms),
                childCount: widget.insights.topLosers.length,
              ),
            ),
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────
class _InsightsHeader extends ConsumerWidget {
  final VoidCallback onSearch;

  const _InsightsHeader({required this.onSearch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).asData?.value;
    final displayName = (user?.displayName.trim().isNotEmpty ?? false)
        ? user!.displayName
        : 'U';
    final firstLetter = displayName[0].toUpperCase();

    return Row(
      children: [
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
          onPressed: onSearch,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

// ── Market Mood card ─────────────────────────────────────────────────────────
class _MarketMoodCard extends StatelessWidget {
  final MarketInsights insights;
  const _MarketMoodCard({required this.insights});

  @override
  Widget build(BuildContext context) {
    final Color moodColor;
    switch (insights.marketMood) {
      case MarketMood.bullish:
        moodColor = AppColors.mint;
      case MarketMood.bearish:
        moodColor = AppColors.vibrantCoral;
      case MarketMood.neutral:
        moodColor = AppColors.deepPurple;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.canvasLevel1,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: moodColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Market Mood',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              // LIVE badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: AppRadius.fullRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'LIVE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            insights.marketHeadline,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: moodColor,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            insights.marketSubtext,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.05, end: 0);
  }
}

// ── Volatility gauge ─────────────────────────────────────────────────────────
class _VolatilityCard extends StatelessWidget {
  final MarketInsights insights;
  const _VolatilityCard({required this.insights});

  @override
  Widget build(BuildContext context) {
    final String levelLabel;
    switch (insights.volatilityLevel) {
      case VolatilityLevel.low:
        levelLabel = 'Low';
      case VolatilityLevel.moderate:
        levelLabel = 'Moderate';
      case VolatilityLevel.high:
        levelLabel = 'High';
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.canvasLevel1,
        borderRadius: AppRadius.lgRadius,
      ),
      child: Column(
        children: [
          Text(
            'Volatility',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(
              painter: _VolatilityGaugePainter(
                value: insights.volatilityIndex / 100,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      insights.volatilityIndex.toStringAsFixed(0),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.yellow,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'INDEX',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.yellow.withValues(alpha: 0.15),
              borderRadius: AppRadius.fullRadius,
            ),
            child: Text(
              levelLabel.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.yellow,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
  }
}

// ── Gauge painter ────────────────────────────────────────────────────────────
class _VolatilityGaugePainter extends CustomPainter {
  final double value; // 0.0–1.0

  const _VolatilityGaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const startAngle = math.pi * 0.75;
    const sweepTotal = math.pi * 1.5;

    // Track
    final trackPaint = Paint()
      ..color = AppColors.surfaceContainerHighest
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal,
      false,
      trackPaint,
    );

    // Value arc
    final valuePaint = Paint()
      ..color = AppColors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal * value,
      false,
      valuePaint,
    );

    // Needle
    final needleAngle = startAngle + sweepTotal * value;
    final needleEnd = Offset(
      center.dx + (radius - 6) * math.cos(needleAngle),
      center.dy + (radius - 6) * math.sin(needleAngle),
    );
    final needleStart = Offset(
      center.dx + 12 * math.cos(needleAngle + math.pi),
      center.dy + 12 * math.sin(needleAngle + math.pi),
    );

    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(needleStart, needleEnd, needlePaint);

    // Dot at needle base
    canvas.drawCircle(center, 6, Paint()..color = AppColors.deepPurple);
  }

  @override
  bool shouldRepaint(_VolatilityGaugePainter old) => old.value != value;
}

// ── AI Protocol card ─────────────────────────────────────────────────────────
class _InsightProtocolCard extends StatelessWidget {
  final MarketInsights insights;
  final VoidCallback onViewGainers;
  final VoidCallback onCheckVolatility;

  const _InsightProtocolCard({
    required this.insights,
    required this.onViewGainers,
    required this.onCheckVolatility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.canvasLevel1,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.deepPurple.withValues(alpha: 0.2),
                  borderRadius: AppRadius.smRadius,
                ),
                child: const Icon(
                  LucideIcons.bot,
                  size: 18,
                  color: AppColors.deepPurple,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'AI PROTOCOL',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: AppRadius.smRadius,
            ),
            child: Text(
              insights.insightText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurface,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ActionPill(
                label: 'VIEW TOP GAINERS',
                icon: LucideIcons.trendingUp,
                color: AppColors.mint,
                onTap: onViewGainers,
              ),
              _ActionPill(
                label: 'CHECK VOLATILITY',
                icon: LucideIcons.activity,
                color: AppColors.yellow,
                onTap: onCheckVolatility,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }
}

class _ActionPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionPill({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
          borderRadius: AppRadius.fullRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section header ───────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

// ── Mover tile ───────────────────────────────────────────────────────────────
class _MoverTile extends ConsumerWidget {
  final Coin coin;
  final bool isGainer;
  const _MoverTile({required this.coin, required this.isGainer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = isGainer ? AppColors.mint : AppColors.vibrantCoral;
    final symbol = coin.symbol.replaceAll('USDT', '');
    final pctSign = isGainer ? '+' : '';

    return GestureDetector(
      onTap: () => context.pushNamed(
        RouteNames.coinDetail,
        pathParameters: {'symbol': coin.symbol},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.cardGap),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.canvasLevel1,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  symbol.substring(0, 1),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name + symbol
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
                    symbol,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Percentage
            Text(
              '$pctSign${coin.priceChangePercent24h.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
