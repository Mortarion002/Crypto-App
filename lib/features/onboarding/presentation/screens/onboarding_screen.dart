import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pageCount = 4;

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) context.goNamed(RouteNames.home);
  }

  void _next() {
    if (_page < _pageCount - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _pageCount - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: indicators + skip ────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  // Progress dots
                  Row(
                    children: List.generate(_pageCount, (i) {
                      final active = i == _page;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 6),
                        width: active ? 28 : 18,
                        height: 4,
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.vibrantCoral
                              : AppColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                  const Spacer(),
                  if (!isLast)
                    GestureDetector(
                      onTap: _finish,
                      child: Text(
                        'SKIP',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Pages ─────────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (p) => setState(() => _page = p),
                children: const [
                  _Page1(),
                  _Page2(),
                  _Page3(),
                  _Page4(),
                ],
              ),
            ),

            // ── CTA button ────────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(24, 12, 24, 28),
              child: GestureDetector(
                onTap: _next,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: AppColors.vibrantCoral,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLast ? 'GET STARTED' : 'CONTINUE',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          letterSpacing: 1.5,
                        ),
                      ),
                      if (!isLast) ...[
                        const SizedBox(width: 8),
                        const Icon(LucideIcons.arrowRight,
                            size: 16, color: Colors.white),
                      ],
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

// ── Page 1: Read the market before it moves ──────────────────────────────────
class _Page1 extends StatelessWidget {
  const _Page1();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Graphic
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6B1F1F),
                    Color(0xFF3D0D5C),
                    Color(0xFF1A0A2E),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Animated wave lines
                  ...List.generate(6, (i) {
                    final offset = i * 18.0;
                    return Positioned(
                      top: 30 + offset,
                      left: -20,
                      right: -20,
                      child: CustomPaint(
                        size: const Size(double.infinity, 30),
                        painter: _WavePainter(
                          color: Color.lerp(
                            AppColors.vibrantCoral,
                            AppColors.deepPurple,
                            i / 6,
                          )!
                              .withValues(alpha: 0.6 - i * 0.08),
                          offset: i * 0.5,
                        ),
                      ),
                    );
                  }),
                  // "LIVE FEED ACTIVE" badge
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LIVE FEED ACTIVE',
                          style: TextStyle(
                            color: AppColors.cyanHighlight,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 50,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.cyanHighlight,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Sound wave button
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: const Icon(LucideIcons.audioLines,
                          size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms),
          ),

          const SizedBox(height: 28),

          // Text
          Text(
            'READ THE\nMARKET\nBEFORE IT\nMOVES',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 0.95,
                  letterSpacing: -1,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Track live crypto sentiment, volatility, and momentum in one clean dashboard.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Page 2: Live prices. Clear signals. ──────────────────────────────────────
class _Page2 extends StatelessWidget {
  const _Page2();

  static const _cards = [
    _CardData('BITCOIN', 'BTC', 'Bullish', Color(0xFFC8F5E0), Color(0xFF1A4A2E)),
    _CardData('ETHEREUM', 'ETH', 'Neutral', Color(0xFFD4C8FF), Color(0xFF2A1F5C)),
    _CardData('SOLANA', 'SOL', 'Bearish', Color(0xFFFFD0CC), Color(0xFF4A1F1F)),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Stacked cards graphic
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(_cards.length, (i) {
                final card = _cards[i];
                final offset = (i - 1) * 20.0;
                final rotation = (i - 1) * 0.05;
                return Transform.translate(
                  offset: Offset(offset, -(i * 12.0)),
                  child: Transform.rotate(
                    angle: rotation,
                    child: _StyledCard(data: card),
                  ),
                )
                    .animate()
                    .fadeIn(delay: (i * 150).ms, duration: 500.ms)
                    .slideY(begin: 0.2, end: 0);
              }),
            ),
          ),

          const SizedBox(height: 28),

          Text(
            'LIVE PRICES.\nCLEAR SIGNALS.',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 0.95,
                  letterSpacing: -1,
                  color: AppColors.inverseSurface,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Every coin is classified as Bullish, Bearish, or Neutral based on real market movement.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Page 3: Follow the coins that matter ─────────────────────────────────────
class _Page3 extends StatelessWidget {
  const _Page3();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Graphic: stacked watchlist cards
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background card
                Positioned(
                  top: 40,
                  child: Transform.rotate(
                    angle: -0.08,
                    child: _WatchlistPreviewCard(
                      symbol: 'BTC',
                      name: 'BITCOIN',
                      price: '\$64,230',
                      color: AppColors.surfaceContainerHigh,
                    ),
                  ),
                ),
                // Foreground card
                _WatchlistPreviewCard(
                  symbol: 'SOL',
                  name: 'SOLANA',
                  price: '\$142.80',
                  color: AppColors.surfaceContainerHighest,
                  showChart: true,
                ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Text(
            'FOLLOW THE\nCOINS THAT\nMATTER',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 0.95,
                  letterSpacing: -1,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Build a personal watchlist and keep your favorite assets one tap away.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Page 4: Turn noise into insight ──────────────────────────────────────────
class _Page4 extends StatelessWidget {
  const _Page4();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Graphic: volatility gauge card
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.canvasLevel1,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.gauge,
                          size: 18, color: AppColors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        'MARKET VOLATILITY',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                              letterSpacing: 1.0,
                            ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.vibrantCoral.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.trendingUp,
                                size: 11, color: Colors.white),
                            const SizedBox(width: 4),
                            const Text('SURGE',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SizedBox(
                      width: 160,
                      child: CustomPaint(
                        painter: _LargeGaugePainter(value: 0.72),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                'High',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: AppColors.yellow,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Bottom movers row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('TOP GAINER',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                          letterSpacing: 0.6)),
                              const SizedBox(height: 4),
                              Text('SOL',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w800)),
                              Text('+12.4%',
                                  style: TextStyle(
                                      color: AppColors.mint,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('TOP LOSER',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                          letterSpacing: 0.6)),
                              const SizedBox(height: 4),
                              Text('ETH',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w800)),
                              Text('-4.2%',
                                  style: TextStyle(
                                      color: AppColors.vibrantCoral,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms),
          ),

          const SizedBox(height: 28),

          Text(
            'TURN NOISE\nINTO INSIGHT',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 0.95,
                  letterSpacing: -1,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'See gainers, losers, volatility, and market mood without reading endless charts.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _CardData {
  final String name;
  final String symbol;
  final String sentiment;
  final Color bg;
  final Color fg;
  const _CardData(this.name, this.symbol, this.sentiment, this.bg, this.fg);
}

class _StyledCard extends StatelessWidget {
  final _CardData data;
  const _StyledCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration:
                    BoxDecoration(color: data.fg, shape: BoxShape.circle),
                child: Center(
                  child: Text(data.symbol[0],
                      style: TextStyle(
                          color: data.bg,
                          fontWeight: FontWeight.w900,
                          fontSize: 14)),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.name,
                      style: TextStyle(
                          color: data.fg,
                          fontWeight: FontWeight.w700,
                          fontSize: 12)),
                  Text(data.symbol,
                      style: TextStyle(color: data.fg.withValues(alpha: 0.6), fontSize: 10)),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: data.fg.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999)),
                child: Text(data.sentiment,
                    style: TextStyle(
                        color: data.fg,
                        fontWeight: FontWeight.w700,
                        fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WatchlistPreviewCard extends StatelessWidget {
  final String symbol;
  final String name;
  final String price;
  final Color color;
  final bool showChart;

  const _WatchlistPreviewCard({
    required this.symbol,
    required this.name,
    required this.price,
    required this.color,
    this.showChart = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    shape: BoxShape.circle),
                child: Center(
                  child: Text(symbol[0],
                      style: const TextStyle(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w900,
                          fontSize: 14)),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 11)),
                  Text(symbol,
                      style: const TextStyle(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w800,
                          fontSize: 14)),
                ],
              ),
              const Spacer(),
              if (showChart)
                Icon(LucideIcons.star,
                    size: 18, color: AppColors.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            price,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 22,
              letterSpacing: -0.5,
            ),
          ),
          if (showChart) ...[
            const SizedBox(height: 10),
            // Mini bar chart preview
            Row(
              children: List.generate(8, (i) {
                final heights = [0.4, 0.6, 0.5, 0.7, 0.8, 0.65, 0.9, 1.0];
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    height: 24 * heights[i],
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Wave painter ──────────────────────────────────────────────────────────────
class _WavePainter extends CustomPainter {
  final Color color;
  final double offset;
  const _WavePainter({required this.color, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    const waves = 3;
    final waveWidth = size.width / waves;

    path.moveTo(0, size.height / 2);
    for (var i = 0; i < waves; i++) {
      final x = i * waveWidth;
      path.cubicTo(
        x + waveWidth * 0.25,
        size.height * (0.1 + offset * 0.3),
        x + waveWidth * 0.75,
        size.height * (0.9 - offset * 0.3),
        x + waveWidth,
        size.height / 2,
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter old) => false;
}

// ── Large gauge painter for page 4 ───────────────────────────────────────────
class _LargeGaugePainter extends CustomPainter {
  final double value;
  const _LargeGaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.6);
    final radius = size.width / 2 - 8;
    const startAngle = math.pi * 0.75;
    const sweepTotal = math.pi * 1.5;

    final track = Paint()
      ..color = AppColors.surfaceContainerHighest
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepTotal, false, track);

    final arc = Paint()
      ..color = AppColors.deepPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepTotal * value, false, arc);

    // Needle
    final needleAngle = startAngle + sweepTotal * value;
    final ne = Offset(center.dx + (radius - 4) * math.cos(needleAngle),
        center.dy + (radius - 4) * math.sin(needleAngle));
    final ns = Offset(center.dx + 8 * math.cos(needleAngle + math.pi),
        center.dy + 8 * math.sin(needleAngle + math.pi));

    canvas.drawLine(
        ns,
        ne,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round);

    canvas.drawCircle(center, 5, Paint()..color = AppColors.deepPurple);
  }

  @override
  bool shouldRepaint(_LargeGaugePainter old) => old.value != value;
}
