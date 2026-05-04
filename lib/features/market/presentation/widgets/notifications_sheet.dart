import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';

class NotifData {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
  final bool isNew;

  const NotifData({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
    required this.isNew,
  });
}

const kNotifications = [
  NotifData(
    icon: LucideIcons.trendingUp,
    color: AppColors.mint,
    title: 'BTC Spike Alert',
    body: 'Bitcoin just broke \$65,000. Up 4.2% in the last hour.',
    time: '2m ago',
    isNew: true,
  ),
  NotifData(
    icon: LucideIcons.triangleAlert,
    color: AppColors.vibrantCoral,
    title: 'High Volatility',
    body: 'Market volatility is High (72). Expect rapid price swings.',
    time: '15m ago',
    isNew: true,
  ),
  NotifData(
    icon: LucideIcons.bell,
    color: AppColors.deepPurple,
    title: 'Watchlist Update',
    body: 'ETH and SOL are showing bullish patterns on your 1H chart.',
    time: '1h ago',
    isNew: false,
  ),
  NotifData(
    icon: LucideIcons.check,
    color: AppColors.cyanHighlight,
    title: 'Security Sync',
    body: 'Your watchlist has been successfully synced to the cloud.',
    time: '3h ago',
    isNew: false,
  ),
];

class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

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
                    ...kNotifications.map((item) => NotifRow(item: item)),
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

class NotifRow extends StatelessWidget {
  final NotifData item;
  const NotifRow({super.key, required this.item});

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
