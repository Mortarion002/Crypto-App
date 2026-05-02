import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/insights/presentation/controllers/insights_controller.dart';
import 'package:crypto_pulse/features/market/presentation/widgets/coin_card.dart';
import 'package:crypto_pulse/features/market/presentation/widgets/market_mood_card.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsState = ref.watch(insightsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: insightsState.when(
        data: (insights) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.containerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarketMoodCard(
                  headline: insights.marketHeadline,
                  isBullish: insights.topGainers.length >= insights.topLosers.length,
                ),
                const SizedBox(height: AppSpacing.sectionMargin),
                
                Text(
                  'TOP MOVERS',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                
                ...insights.topGainers.map((c) => CoinCard(coin: c, onTap: () {})),
                ...insights.topLosers.map((c) => CoinCard(coin: c, onTap: () {})),
                
                const SizedBox(height: 100), // Nav bar padding
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
