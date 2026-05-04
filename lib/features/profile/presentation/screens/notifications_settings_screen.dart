import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';

// ── State ────────────────────────────────────────────────────────────────────
class _AlertItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  bool enabled;

  _AlertItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.enabled,
  });
}

class _ChannelItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  bool enabled;

  _ChannelItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.enabled,
  });
}

// ── Screen ───────────────────────────────────────────────────────────────────
class NotificationsSettingsScreen extends ConsumerStatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  ConsumerState<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends ConsumerState<NotificationsSettingsScreen> {
  bool _notificationsOn = true;
  int _digestIndex = 2; // Daily
  final _digestLabels = ['Real-time', 'Hourly', 'Daily', 'Weekly'];

  final List<_AlertItem> _alerts = [
    _AlertItem(
      icon: LucideIcons.alertCircle,
      color: const Color(0xFFFF5D52),
      title: 'Price Alerts',
      subtitle: 'Sudden spikes and crashes',
      enabled: true,
    ),
    _AlertItem(
      icon: LucideIcons.trendingUp,
      color: const Color(0xFF6C6BFF),
      title: 'Top Gainer Alerts',
      subtitle: 'Coins up >5% in 24h',
      enabled: true,
    ),
    _AlertItem(
      icon: LucideIcons.trendingDown,
      color: const Color(0xFFFFB4AB),
      title: 'Top Loser Alerts',
      subtitle: 'Coins down >5% in 24h',
      enabled: true,
    ),
    _AlertItem(
      icon: LucideIcons.activity,
      color: const Color(0xFFFFD45A),
      title: 'Volatility Alerts',
      subtitle: 'High market turbulence',
      enabled: false,
    ),
    _AlertItem(
      icon: LucideIcons.star,
      color: const Color(0xFFC8D8CC),
      title: 'Watchlist Updates',
      subtitle: 'Changes to tracked coins',
      enabled: true,
    ),
    _AlertItem(
      icon: LucideIcons.dollarSign,
      color: const Color(0xFF00FFFF),
      title: 'Volume Surges',
      subtitle: 'Unusual trading volume spikes',
      enabled: true,
    ),
    _AlertItem(
      icon: LucideIcons.calendar,
      color: AppColors.onSurfaceVariant,
      title: 'Market Digest',
      subtitle: 'Daily market summary report',
      enabled: false,
    ),
  ];

  final List<_ChannelItem> _channels = [
    _ChannelItem(
      icon: LucideIcons.smartphone,
      color: const Color(0xFF4CAF50),
      title: 'Push Notifications',
      subtitle: 'Real-time alerts on this device',
      enabled: true,
    ),
    _ChannelItem(
      icon: LucideIcons.mail,
      color: AppColors.onSurfaceVariant,
      title: 'Email',
      subtitle: 'Sent to your account email',
      enabled: false,
    ),
    _ChannelItem(
      icon: LucideIcons.hash,
      color: const Color(0xFF4CAF50),
      title: 'In-App Banner',
      subtitle: 'Overlay alerts while browsing',
      enabled: true,
    ),
  ];

  int get _activeCount => _alerts.where((a) => a.enabled).length;

  @override
  Widget build(BuildContext context) {
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
          'Notifications',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.containerPadding,
          16,
          AppSpacing.containerPadding,
          120,
        ),
        children: [
          // ── Master toggle ─────────────────────────────────────────────
          _MasterToggleCard(
            enabled: _notificationsOn,
            activeCount: _activeCount,
            onChanged: (v) => setState(() => _notificationsOn = v),
          ),

          const SizedBox(height: 28),

          // ── Alert categories ─────────────────────────────────────────
          _SectionLabel(
            label: 'ALERT CATEGORIES',
            trailing: '$_activeCount of ${_alerts.length} active',
          ),
          const SizedBox(height: 10),
          _GroupCard(
            children: _alerts.asMap().entries.map((e) {
              final idx = e.key;
              final item = e.value;
              return _ToggleRow(
                icon: item.icon,
                iconColor: item.color,
                title: item.title,
                subtitle: item.subtitle,
                value: _notificationsOn && item.enabled,
                divider: idx < _alerts.length - 1,
                onChanged: _notificationsOn
                    ? (v) => setState(() => item.enabled = v)
                    : null,
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // ── Delivery channels ─────────────────────────────────────────
          const _SectionLabel(label: 'DELIVERY CHANNELS'),
          const SizedBox(height: 10),
          _GroupCard(
            children: _channels.asMap().entries.map((e) {
              final idx = e.key;
              final item = e.value;
              return _ToggleRow(
                icon: item.icon,
                iconColor: item.color,
                title: item.title,
                subtitle: item.subtitle,
                value: _notificationsOn && item.enabled,
                divider: idx < _channels.length - 1,
                onChanged: _notificationsOn
                    ? (v) => setState(() => item.enabled = v)
                    : null,
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // ── Digest schedule ───────────────────────────────────────────
          const _SectionLabel(label: 'DIGEST SCHEDULE'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.canvasLevel1,
              borderRadius: AppRadius.mdRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: AppRadius.smRadius,
                      ),
                      child: const Icon(
                        LucideIcons.fileText,
                        size: 18,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Email digest frequency',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: _digestLabels.asMap().entries.map((e) {
                    final selected = e.key == _digestIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _digestIndex = e.key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(
                            right: e.key < _digestLabels.length - 1 ? 6 : 0,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.deepPurple
                                : AppColors.surfaceContainerHigh,
                            borderRadius: AppRadius.smRadius,
                          ),
                          child: Center(
                            child: Text(
                              e.value,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: selected
                                        ? Colors.white
                                        : AppColors.onSurfaceVariant,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ── Quiet hours ───────────────────────────────────────────────
          const _SectionLabel(label: 'QUIET HOURS'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.canvasLevel1,
              borderRadius: AppRadius.mdRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: AppRadius.smRadius,
                          ),
                          child: const Icon(
                            LucideIcons.moon,
                            size: 18,
                            color: AppColors.deepPurple,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Quiet Hours',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.deepPurple.withValues(alpha: 0.15),
                        borderRadius: AppRadius.fullRadius,
                        border: Border.all(
                          color: AppColors.deepPurple.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        '10:00 PM – 7:00 AM',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.deepPurple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Non-critical notifications are held until quiet hours end. Price alerts and critical events always come through.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
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

// ── Master toggle card ───────────────────────────────────────────────────────
class _MasterToggleCard extends StatelessWidget {
  final bool enabled;
  final int activeCount;
  final ValueChanged<bool> onChanged;

  const _MasterToggleCard({
    required this.enabled,
    required this.activeCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: enabled
            ? AppColors.deepPurple.withValues(alpha: 0.18)
            : AppColors.canvasLevel1,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(
          color: enabled
              ? AppColors.deepPurple.withValues(alpha: 0.5)
              : AppColors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: enabled
                  ? AppColors.deepPurple.withValues(alpha: 0.25)
                  : AppColors.surfaceContainerHigh,
              borderRadius: AppRadius.smRadius,
            ),
            child: Icon(
              LucideIcons.bell,
              size: 20,
              color: enabled ? AppColors.deepPurple : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enabled ? 'Notifications On' : 'Notifications Off',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  '$activeCount alert types active',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: onChanged,
            activeTrackColor: AppColors.deepPurple,
            activeThumbColor: Colors.white,
            inactiveThumbColor: AppColors.onSurfaceVariant,
            inactiveTrackColor: AppColors.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}

// ── Shared group card ────────────────────────────────────────────────────────
class _GroupCard extends StatelessWidget {
  final List<Widget> children;
  const _GroupCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvasLevel1,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Column(children: children),
    );
  }
}

// ── Single toggle row ─────────────────────────────────────────────────────────
class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final bool divider;
  final ValueChanged<bool>? onChanged;

  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.divider,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: AppRadius.smRadius,
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: AppColors.deepPurple,
                activeThumbColor: Colors.white,
                inactiveThumbColor: AppColors.onSurfaceVariant,
                inactiveTrackColor: AppColors.surfaceContainerHighest,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
        if (divider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 66,
            color: AppColors.outlineVariant.withValues(alpha: 0.4),
          ),
      ],
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final String? trailing;
  const _SectionLabel({required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
