import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/features/market/presentation/controllers/market_controller.dart';
import 'package:crypto_pulse/features/insights/presentation/controllers/insights_controller.dart';
import 'package:crypto_pulse/features/market/presentation/widgets/coin_card.dart';
import 'package:crypto_pulse/features/market/presentation/widgets/market_mood_card.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MarketScreen extends ConsumerWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketState = ref.watch(marketControllerProvider);
    final insightsState = ref.watch(insightsControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Trigger refresh
            ref.invalidate(marketControllerProvider);
          },
          color: AppColors.primary,
          backgroundColor: AppColors.canvasLevel1,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.containerPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),
                    // Market Mood Header
                    insightsState.when(
                      data: (insights) => MarketMoodCard(
                        headline: insights.marketHeadline,
                        isBullish: insights.topGainers.length >= insights.topLosers.length,
                      ),
                      loading: () => const _MoodCardSkeleton(),
                      error: (_, __) => const MarketMoodCard(
                        headline: 'Market data unavailable.',
                        isBullish: false,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionMargin),
                    
                    Text(
                      'MARKET PULSE',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              
              // Coin List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
                sliver: marketState.when(
                  data: (coins) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == coins.length) {
                            return const SizedBox(height: 100); // Bottom padding for nav bar
                          }
                          final coin = coins[index];
                          return CoinCard(
                            coin: coin,
                            onTap: () {
                              context.pushNamed(
                                RouteNames.coinDetail,
                                pathParameters: {'symbol': coin.symbol},
                              );
                            },
                          ).animate().fadeIn(duration: 400.ms, delay: (index * 50).ms).slideX(begin: 0.1, end: 0);
                        },
                        childCount: coins.length + 1,
                      ),
                    );
                  },
                  loading: () => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const _CoinCardSkeleton(),
                      childCount: 5,
                    ),
                  ),
                  error: (error, _) => SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Failed to load market data.',
                        style: TextStyle(color: AppColors.error),
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
}

class _MoodCardSkeleton extends StatelessWidget {
  const _MoodCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.canvasLevel1,
      highlightColor: AppColors.surfaceBright,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _CoinCardSkeleton extends StatelessWidget {
  const _CoinCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.canvasLevel1,
      highlightColor: AppColors.surfaceBright,
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
