import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';

// ── Data models ──────────────────────────────────────────────────────────────
class _DocArticle {
  final String title;
  final String content;
  bool expanded = false;

  _DocArticle({required this.title, required this.content});
}

class _DocSection {
  final IconData icon;
  final Color color;
  final String title;
  final List<_DocArticle> articles;

  const _DocSection({
    required this.icon,
    required this.color,
    required this.title,
    required this.articles,
  });
}

// ── Static data (crypto-pulse–flavoured) ─────────────────────────────────────
final List<_DocSection> _sections = [
  _DocSection(
    icon: LucideIcons.rocket,
    color: const Color(0xFF6C6BFF),
    title: 'Getting Started',
    articles: [
      _DocArticle(
        title: 'What is Crypto Pulse?',
        content:
            'Crypto Pulse is a real-time cryptocurrency market tracker. '
            'It streams live prices from major exchanges, gives you AI-powered market insights, '
            'and lets you build a personalised watchlist to follow the coins you care about.',
      ),
      _DocArticle(
        title: 'Creating Your Account',
        content:
            'Tap Sign Up on the login screen, enter your name, email and a password '
            '(min. 6 characters). A confirmation email will be sent — click the link to activate '
            'your account, then sign in.',
      ),
      _DocArticle(
        title: 'Navigating the App',
        content:
            'The bottom navigation bar has four tabs:\n'
            '• Pulse – live market dashboard with top movers.\n'
            '• Insights – AI-powered market mood, volatility gauge and top gainers/losers.\n'
            '• Watchlist – track selected coins with sparkline charts.\n'
            '• Settings – manage your account, notifications and preferences.',
      ),
    ],
  ),
  _DocSection(
    icon: LucideIcons.layoutDashboard,
    color: const Color(0xFF00FFFF),
    title: 'Dashboard',
    articles: [
      _DocArticle(
        title: 'Market Pulse Card',
        content:
            'The Market Pulse card shows combined 24h trading volume across all tracked coins. '
            'Toggle between 1D, 1W and 1M intervals. The embedded chart uses live BTC kline data as a proxy '
            'for overall market momentum.',
      ),
      _DocArticle(
        title: 'Top Movers',
        content:
            'Top Movers lists coins with the largest absolute price change in the last 24 hours. '
            'A left-edge accent bar colour indicates direction — coral for losers, '
            'mint for gainers, purple for Ethereum, and cyan for Solana.',
      ),
      _DocArticle(
        title: 'Filtering the Market',
        content:
            'Tap the "All Markets" pill to filter by Top Gainers or Top Losers. '
            'An active filter badge appears at the top of the list — tap "Clear ×" to reset.',
      ),
    ],
  ),
  _DocSection(
    icon: LucideIcons.trendingUp,
    color: const Color(0xFFC8D8CC),
    title: 'Insights',
    articles: [
      _DocArticle(
        title: 'Market Mood',
        content:
            'Market Mood is calculated from the ratio of gainers to losers across all tracked coins. '
            'If more than 60% are up it shows BULLISH; below 40% shows BEARISH; otherwise NEUTRAL.',
      ),
      _DocArticle(
        title: 'Volatility Index',
        content:
            'Volatility Index is the average absolute 24h price-change percentage across all coins, '
            'scaled to 0–100. Below 30 = Low, 30–60 = Moderate, above 60 = High.',
      ),
      _DocArticle(
        title: 'AI Protocol',
        content:
            'The AI Protocol card surfaces an automatically generated insight sentence based on live '
            'market data. Tap VIEW TOP GAINERS to jump to the gainers list, or CHECK VOLATILITY to '
            'scroll to the gauge.',
      ),
    ],
  ),
  _DocSection(
    icon: LucideIcons.star,
    color: const Color(0xFFFFD45A),
    title: 'Watchlist',
    articles: [
      _DocArticle(
        title: 'Adding Coins',
        content:
            'Tap any coin on the Dashboard to open its detail page. '
            'Tap the bookmark icon to add it to your Watchlist. '
            'Your selections are saved locally and persist between sessions.',
      ),
      _DocArticle(
        title: 'Sparkline Charts',
        content:
            'Each watchlist card includes a 24-point sparkline showing recent price movement. '
            'The line colour matches the coin\'s sentiment — green (bullish), red (bearish) or purple (neutral).',
      ),
      _DocArticle(
        title: 'Removing Coins',
        content:
            'Tap the bookmark icon on a watchlist card to remove that coin. '
            'The card will disappear immediately and your preference is saved.',
      ),
    ],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────
class DocumentationScreen extends StatefulWidget {
  const DocumentationScreen({super.key});

  @override
  State<DocumentationScreen> createState() => _DocumentationScreenState();
}

class _DocumentationScreenState extends State<DocumentationScreen> {
  String _query = '';

  // Mutable article lists per section (so expansion can be toggled)
  late final List<List<_DocArticle>> _articleLists;

  @override
  void initState() {
    super.initState();
    _articleLists = _sections
        .map(
          (s) => s.articles
              .map((a) => _DocArticle(title: a.title, content: a.content))
              .toList(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final lowerQuery = _query.toLowerCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 22),
          color: AppColors.onSurface,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Documentation',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.containerPadding,
          8,
          AppSpacing.containerPadding,
          120,
        ),
        children: [
          // ── Search ───────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: AppColors.canvasLevel1,
              borderRadius: AppRadius.mdRadius,
            ),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: AppColors.onSurface),
              decoration: InputDecoration(
                hintText: 'Search docs...',
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
          const SizedBox(height: 24),

          // ── Sections ─────────────────────────────────────────────────
          ..._sections.asMap().entries.map((sEntry) {
            final sIdx = sEntry.key;
            final section = sEntry.value;
            final articles = _articleLists[sIdx];

            // Filter articles by query
            final filtered = lowerQuery.isEmpty
                ? articles
                : articles
                      .where(
                        (a) =>
                            a.title.toLowerCase().contains(lowerQuery) ||
                            a.content.toLowerCase().contains(lowerQuery),
                      )
                      .toList();

            if (filtered.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: section.color.withValues(alpha: 0.15),
                        borderRadius: AppRadius.smRadius,
                      ),
                      child: Icon(section.icon, size: 18, color: section.color),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      section.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${filtered.length} articles',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Article accordion cards
                ...filtered.map((article) {
                  return _ArticleCard(
                    article: article,
                    query: lowerQuery,
                    onToggle: () =>
                        setState(() => article.expanded = !article.expanded),
                  );
                }),
                const SizedBox(height: 24),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ── Article accordion card ────────────────────────────────────────────────────
class _ArticleCard extends StatelessWidget {
  final _DocArticle article;
  final String query;
  final VoidCallback onToggle;

  const _ArticleCard({
    required this.article,
    required this.query,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: article.expanded
              ? AppColors.deepPurple.withValues(alpha: 0.08)
              : AppColors.canvasLevel1,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(
            color: article.expanded
                ? AppColors.deepPurple.withValues(alpha: 0.4)
                : AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      article.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    article.expanded
                        ? LucideIcons.chevronUp
                        : LucideIcons.chevronDown,
                    size: 18,
                    color: article.expanded
                        ? AppColors.deepPurple
                        : AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            if (article.expanded) ...[
              Divider(
                height: 1,
                color: AppColors.outlineVariant.withValues(alpha: 0.4),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Text(
                  article.content,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.65,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
