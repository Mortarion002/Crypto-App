import 'package:flutter/material.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MarketMoodCard extends StatelessWidget {
  final String headline;
  final bool isBullish;

  const MarketMoodCard({super.key, required this.headline, required this.isBullish});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isBullish 
            ? [AppColors.mint.withValues(alpha: 0.2), AppColors.canvasLevel1]
            : [AppColors.vibrantCoral.withValues(alpha: 0.2), AppColors.canvasLevel1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: isBullish ? AppColors.mint.withValues(alpha: 0.1) : AppColors.vibrantCoral.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MARKET MOOD',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            headline,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }
}
