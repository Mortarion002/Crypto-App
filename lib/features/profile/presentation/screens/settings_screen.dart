import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/core/config/preference_keys.dart';
import 'package:crypto_pulse/core/providers/shared_prefs_provider.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';
import 'package:crypto_pulse/features/auth/presentation/controllers/auth_controller.dart';
import 'package:crypto_pulse/features/market/presentation/controllers/market_controller.dart';
import 'package:crypto_pulse/features/profile/presentation/screens/notifications_settings_screen.dart';
import 'package:crypto_pulse/features/profile/presentation/screens/documentation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late bool _liveRefresh;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(sharedPreferencesProvider);
    _liveRefresh = prefs.getBool(PreferenceKeys.liveRefresh) ?? true;
  }

  void _push(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).asData?.value;
    final displayName = (user?.displayName.trim().isNotEmpty ?? false)
        ? user!.displayName
        : 'User';
    final initial = displayName[0].toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.containerPadding,
            20,
            AppSpacing.containerPadding,
            120,
          ),
          children: [
            // ── Top bar ──────────────────────────────────────────────────
            _TopBar(initial: initial, displayName: displayName),

            const SizedBox(height: 28),

            // ── Profile card ─────────────────────────────────────────────
            _ProfileCard(
              initial: initial,
              displayName: displayName,
              email: user?.email ?? '',
              onTap: () => context.pushNamed(RouteNames.profile),
            ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),

            const SizedBox(height: 28),

            // ══ ACCOUNT ──────────────────────────────────────────────────
            _SectionLabel(label: 'ACCOUNT'),
            const SizedBox(height: 10),
            _SettingsGroup(
              children: [
                _RowTile(
                  icon: LucideIcons.user,
                  iconColor: AppColors.cyanHighlight,
                  title: 'Profile',
                  subtitle: 'Manage your personal information',
                  onTap: () => context.pushNamed(RouteNames.profile),
                ),
                _DividerLine(),
                _RowTile(
                  icon: LucideIcons.keyRound,
                  iconColor: AppColors.yellow,
                  title: 'Security',
                  subtitle: 'Password and authentication',
                  onTap: () => _showComingSoon(context, 'Security'),
                ),
                _DividerLine(),
                _RowTile(
                  icon: LucideIcons.link,
                  iconColor: AppColors.deepPurple,
                  title: 'Connected Accounts',
                  subtitle: 'Linked wallets and exchanges',
                  onTap: () => _showComingSoon(context, 'Connected Accounts'),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 50.ms),

            const SizedBox(height: 24),

            // ══ PREFERENCES ──────────────────────────────────────────────
            _SectionLabel(label: 'PREFERENCES'),
            const SizedBox(height: 10),
            _SettingsGroup(
              children: [
                _RowTile(
                  icon: LucideIcons.bell,
                  iconColor: AppColors.vibrantCoral,
                  title: 'Notifications',
                  subtitle: 'Configure alerts and digests',
                  onTap: () => _push(const NotificationsSettingsScreen()),
                ),
                _DividerLine(),
                _SwitchTile(
                  icon: LucideIcons.moon,
                  iconColor: AppColors.deepPurple,
                  title: 'Theme',
                  subtitle: 'Dark Mode (Default)',
                  value: true,
                  onChanged: null,
                  trailing: const Icon(
                    LucideIcons.check,
                    size: 16,
                    color: AppColors.mint,
                  ),
                ),
                _DividerLine(),
                _SwitchTile(
                  icon: LucideIcons.refreshCw,
                  iconColor: AppColors.mint,
                  title: 'Live Data Refresh',
                  subtitle: _liveRefresh ? 'Auto-refresh every 30s' : 'Manual refresh only',
                  value: _liveRefresh,
                  onChanged: (v) async {
                    setState(() => _liveRefresh = v);
                    await ref
                        .read(sharedPreferencesProvider)
                        .setBool(PreferenceKeys.liveRefresh, v);
                    ref.invalidate(marketControllerProvider);
                  },
                ),
                _DividerLine(),
                _RowTile(
                  icon: LucideIcons.languages,
                  iconColor: AppColors.onSurfaceVariant,
                  title: 'Language & Region',
                  subtitle: 'English (US) · USD',
                  onTap: () => _showComingSoon(context, 'Language & Region'),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

            const SizedBox(height: 24),

            // ══ MARKET DATA ───────────────────────────────────────────────
            _SectionLabel(label: 'MARKET DATA'),
            const SizedBox(height: 10),
            _SettingsGroup(
              children: [
                _RowTile(
                  icon: LucideIcons.barChart2,
                  iconColor: AppColors.vibrantCoral,
                  title: 'Default Currency',
                  subtitle: 'USD – US Dollar',
                  onTap: () => _showComingSoon(context, 'Default Currency'),
                ),
                _DividerLine(),
                _RowTile(
                  icon: LucideIcons.clock,
                  iconColor: AppColors.yellow,
                  title: 'Chart Interval',
                  subtitle: '1 Day (1D) default',
                  onTap: () => _showComingSoon(context, 'Chart Interval'),
                ),
                _DividerLine(),
                _RowTile(
                  icon: LucideIcons.server,
                  iconColor: AppColors.cyanHighlight,
                  title: 'Data Source',
                  subtitle: 'Binance Public API',
                  onTap: () => _showComingSoon(context, 'Data Source'),
                  showArrow: false,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.mint.withValues(alpha: 0.2),
                      borderRadius: AppRadius.fullRadius,
                    ),
                    child: Text(
                      'LIVE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.mint,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

            const SizedBox(height: 24),

            // ══ SUPPORT ───────────────────────────────────────────────────
            _SectionLabel(label: 'SUPPORT'),
            const SizedBox(height: 10),
            _SettingsGroup(
              children: [
                _RowTile(
                  icon: LucideIcons.fileText,
                  iconColor: AppColors.onSurfaceVariant,
                  title: 'Documentation',
                  subtitle: 'Guides, FAQs and tutorials',
                  onTap: () => _push(const DocumentationScreen()),
                ),
                _DividerLine(),
                _RowTile(
                  icon: LucideIcons.messageCircle,
                  iconColor: AppColors.deepPurple,
                  title: 'Send Feedback',
                  subtitle: 'Help us improve Crypto Pulse',
                  onTap: () => _showComingSoon(context, 'Send Feedback'),
                ),
                _DividerLine(),
                _RowTile(
                  icon: LucideIcons.info,
                  iconColor: AppColors.onSurfaceVariant,
                  title: 'About',
                  subtitle: 'Version 1.0.0',
                  onTap: () => _showAbout(context),
                  showArrow: false,
                  trailing: Text(
                    'v1.0.0',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

            const SizedBox(height: 24),

            // ══ DANGER ZONE ───────────────────────────────────────────────
            _SectionLabel(label: 'ACCOUNT ACTIONS'),
            const SizedBox(height: 10),
            _SettingsGroup(
              children: [
                if (user == null)
                  _RowTile(
                    icon: LucideIcons.logIn,
                    iconColor: AppColors.cyanHighlight,
                    title: 'Sign In',
                    onTap: () => context.goNamed(RouteNames.login),
                  )
                else ...[
                  _RowTile(
                    icon: LucideIcons.logOut,
                    iconColor: AppColors.vibrantCoral,
                    title: 'Sign Out',
                    subtitle: 'Signed in as ${user.email}',
                    onTap: () => _confirmSignOut(context),
                  ),
                  _DividerLine(),
                  _RowTile(
                    icon: LucideIcons.trash2,
                    iconColor: AppColors.vibrantCoral,
                    title: 'Delete Account',
                    subtitle: 'Permanently remove your data',
                    onTap: () => _showComingSoon(context, 'Delete Account'),
                  ),
                ],
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.canvasLevel1,
        content: Text(
          '$feature — coming soon!',
          style: const TextStyle(color: AppColors.onSurface),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.canvasLevel1,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        title: const Text(
          'Crypto Pulse',
          style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              'Real-time crypto market tracker powered by the Binance public API.',
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppColors.vibrantCoral)),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.canvasLevel1,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        title: const Text(
          'Sign Out?',
          style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w800),
        ),
        content: Text(
          'You will need to sign in again to access your watchlist and settings.',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authControllerProvider.notifier).signOut();
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.vibrantCoral, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final String initial;
  final String displayName;

  const _TopBar({required this.initial, required this.displayName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.vibrantCoral.withValues(alpha: 0.2),
            border: Border.all(
              color: AppColors.vibrantCoral.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              initial,
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
        const SizedBox(width: 36),
      ],
    );
  }
}

// ── Profile card ──────────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final String initial;
  final String displayName;
  final String email;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.initial,
    required this.displayName,
    required this.email,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.canvasLevel1,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(
            color: AppColors.vibrantCoral.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.vibrantCoral.withValues(alpha: 0.2),
                border: Border.all(
                  color: AppColors.vibrantCoral.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: AppColors.vibrantCoral,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.onSurfaceVariant,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ── Group card ────────────────────────────────────────────────────────────────
class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

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

// ── Divider ───────────────────────────────────────────────────────────────────
class _DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 66,
      color: AppColors.outlineVariant.withValues(alpha: 0.4),
    );
  }
}

// ── Arrow tile ────────────────────────────────────────────────────────────────
class _RowTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showArrow;
  final Widget? trailing;

  const _RowTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.showArrow = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: AppRadius.smRadius,
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
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
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (showArrow && trailing == null)
              Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: AppColors.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Switch tile ───────────────────────────────────────────────────────────────
class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? trailing;

  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: AppRadius.smRadius,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
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
          if (trailing != null)
            trailing!
          else
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
    );
  }
}
