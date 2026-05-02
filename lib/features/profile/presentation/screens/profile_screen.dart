import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:crypto_pulse/core/providers/shared_prefs_provider.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';
import 'package:crypto_pulse/features/auth/presentation/controllers/auth_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late bool _darkMode;
  late bool _liveRefresh;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(sharedPreferencesProvider);
    _darkMode = prefs.getBool('pref_dark_mode') ?? true;
    _liveRefresh = prefs.getBool('pref_live_refresh') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authControllerProvider);
    final user = authAsync.asData?.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.containerPadding, 16,
                    AppSpacing.containerPadding, 0),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainerHigh,
                        border: Border.all(color: AppColors.outline, width: 1),
                      ),
                      child: const Icon(LucideIcons.user,
                          size: 18, color: AppColors.onSurfaceVariant),
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
                ),
              ),

              const SizedBox(height: 32),

              // ── Avatar with cyan ring ──────────────────────────────
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 108,
                    height: 108,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: user != null
                          ? Text(
                              user.displayName.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                              ),
                            )
                          : const Icon(LucideIcons.user,
                              size: 52, color: AppColors.onSurfaceVariant),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.cyanHighlight, width: 2.5),
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.9, 0.9)),

              const SizedBox(height: 16),

              // ── Name ───────────────────────────────────────────────
              Text(
                user?.displayName.toUpperCase() ?? '—',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),

              if (user != null) ...[
                const SizedBox(height: 6),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],

              const SizedBox(height: 10),

              // ── Status badge ───────────────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: AppRadius.fullRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: user != null
                            ? AppColors.mint
                            : AppColors.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user != null ? 'SUPABASE CONNECTED' : 'NOT SIGNED IN',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: user != null
                                ? AppColors.mint
                                : AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // ── Settings section ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.containerPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),

                    _SettingsRow(
                      icon: LucideIcons.moon,
                      label: 'Theme',
                      subtitle: 'Editorial Dark Mode',
                      value: _darkMode,
                      onChanged: (v) async {
                        setState(() => _darkMode = v);
                        await ref
                            .read(sharedPreferencesProvider)
                            .setBool('pref_dark_mode', v);
                      },
                    ),

                    const SizedBox(height: 10),

                    _SettingsRow(
                      icon: LucideIcons.refreshCw,
                      label: 'Data Refresh',
                      subtitle: 'Live 30s Auto-Refresh',
                      value: _liveRefresh,
                      onChanged: (v) async {
                        setState(() => _liveRefresh = v);
                        await ref
                            .read(sharedPreferencesProvider)
                            .setBool('pref_live_refresh', v);
                      },
                    ),

                    const SizedBox(height: 24),

                    if (user == null) ...[
                      _ActionRow(
                        icon: LucideIcons.logIn,
                        label: 'Sign In',
                        color: AppColors.cyanHighlight,
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                    ],

                    if (user != null) ...[
                      _ActionRow(
                        icon: LucideIcons.logOut,
                        label: 'Sign Out',
                        color: AppColors.vibrantCoral,
                        onTap: () async {
                          await ref
                              .read(authControllerProvider.notifier)
                              .signOut();
                        },
                      ),
                      const SizedBox(height: 10),
                    ],

                    const SizedBox(height: 48),

                    // ── Footer ────────────────────────────────────────
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHigh,
                              borderRadius: AppRadius.smRadius,
                            ),
                            child: const Icon(LucideIcons.terminal,
                                size: 20, color: AppColors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'CRYPTO PULSE COMMAND CENTER',
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      letterSpacing: 0.8,
                                    ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Build 1.0.0 • High-Contrast Edition',
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.outlineVariant,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Settings row ─────────────────────────────────────────────────────────────
class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: AppRadius.smRadius,
            ),
            child: Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
                Text(subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        )),
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

// ── Action row ───────────────────────────────────────────────────────────────
class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
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
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
