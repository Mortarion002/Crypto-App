import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/core/config/preference_keys.dart';
import 'package:crypto_pulse/core/providers/shared_prefs_provider.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';
import 'package:crypto_pulse/features/auth/presentation/controllers/auth_controller.dart';
import 'package:crypto_pulse/features/market/presentation/controllers/market_controller.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).asData?.value;

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
            _Header(
              userInitial: (user?.displayName.isNotEmpty ?? false)
                  ? user!.displayName.substring(0, 1)
                  : null,
            ),
            const SizedBox(height: 32),
            Text(
              'Settings',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            _ActionRow(
              icon: LucideIcons.user,
              label: 'Profile',
              subtitle: user?.email ?? 'View account details',
              color: AppColors.cyanHighlight,
              onTap: () => context.pushNamed(RouteNames.profile),
            ),
            const SizedBox(height: 12),
            _SettingsRow(
              icon: LucideIcons.moon,
              label: 'Theme',
              subtitle: 'High-Contrast Dark Mode',
              value: true,
              onChanged: null,
            ),
            const SizedBox(height: 12),
            _SettingsRow(
              icon: LucideIcons.refreshCw,
              label: 'Data Refresh',
              subtitle: 'Live 30s Auto-Refresh',
              value: _liveRefresh,
              onChanged: (value) async {
                setState(() => _liveRefresh = value);
                await ref
                    .read(sharedPreferencesProvider)
                    .setBool(PreferenceKeys.liveRefresh, value);
                ref.invalidate(marketControllerProvider);
              },
            ),
            const SizedBox(height: 24),
            if (user == null)
              _ActionRow(
                icon: LucideIcons.logIn,
                label: 'Sign In',
                color: AppColors.cyanHighlight,
                onTap: () => context.goNamed(RouteNames.login),
              )
            else
              _ActionRow(
                icon: LucideIcons.logOut,
                label: 'Sign Out',
                color: AppColors.vibrantCoral,
                onTap: () async {
                  await ref.read(authControllerProvider.notifier).signOut();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String? userInitial;

  const _Header({required this.userInitial});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainerHigh,
            border: Border.all(color: AppColors.outline, width: 1),
          ),
          child: Center(
            child: Text(
              userInitial?.toUpperCase() ?? '',
              style: const TextStyle(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w800,
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
        const SizedBox(width: 44),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.canvasLevel1,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Row(
        children: [
          _IconBox(icon: icon, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
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
            activeThumbColor: AppColors.cyanHighlight,
            activeTrackColor: AppColors.cyanHighlight.withValues(alpha: 0.3),
            inactiveThumbColor: AppColors.onSurfaceVariant,
            inactiveTrackColor: AppColors.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.canvasLevel1,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Row(
          children: [
            _IconBox(icon: icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
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
            Icon(LucideIcons.chevronRight, size: 18, color: color),
          ],
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconBox({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.smRadius,
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }
}
