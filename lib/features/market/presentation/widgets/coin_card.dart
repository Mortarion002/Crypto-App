import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crypto_pulse/features/market/domain/entities/coin.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CoinCard extends StatelessWidget {
  final Coin coin;
  final VoidCallback onTap;

  const CoinCard({super.key, required this.coin, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final percentFormat = NumberFormat.decimalPatternDigits(decimalDigits: 2);
    final isUp = coin.isUp;
    final color = isUp ? AppColors.mint : AppColors.vibrantCoral;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.cardGap),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.canvasLevel1,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Row(
          children: [
            // Coin Icon Placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceBright,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  coin.symbol.substring(0, 1),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Coin details
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
            // Price info
            Column(
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
                      color: color,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${percentFormat.format(coin.priceChangePercent24h.abs())}%',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: color,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
