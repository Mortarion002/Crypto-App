import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';
import 'package:crypto_pulse/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).asData?.value;
    final displayName = user?.displayName ?? 'Profile';
    final initial = displayName.isNotEmpty ? displayName.substring(0, 1) : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.containerPadding,
            16,
            AppSpacing.containerPadding,
            32,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.arrowLeft,
                        size: 18,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'PROFILE',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.vibrantCoral,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 48),
              Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 132,
                        height: 132,
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: user == null
                              ? const Icon(
                                  LucideIcons.user,
                                  size: 56,
                                  color: AppColors.onSurfaceVariant,
                                )
                              : Text(
                                  initial.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.onSurface,
                                    fontSize: 52,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                        ),
                      ),
                      Container(
                        width: 146,
                        height: 146,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.cyanHighlight,
                            width: 3,
                          ),
                        ),
                      ),
                    ],
                  )
                  .animate()
                  .fadeIn(duration: 350.ms)
                  .scale(begin: const Offset(0.94, 0.94)),
              const SizedBox(height: 20),
              Text(
                displayName.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
              ),
              if (user != null) ...[
                const SizedBox(height: 6),
                Text(
                  user.email,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
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
              _InfoTile(
                icon: LucideIcons.mail,
                label: 'Email',
                value: user?.email ?? 'Not signed in',
              ),
              const SizedBox(height: 12),
              _InfoTile(
                icon: LucideIcons.shieldCheck,
                label: 'Account Status',
                value: user != null ? 'Connected' : 'Signed out',
              ),
              if (user != null) ...[
                const SizedBox(height: 24),
                _SignOutButton(
                  onTap: () async {
                    await ref.read(authControllerProvider.notifier).signOut();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.canvasLevel1,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.cyanHighlight),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SignOutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.canvasLevel1,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Row(
          children: [
            const Icon(
              LucideIcons.logOut,
              size: 20,
              color: AppColors.vibrantCoral,
            ),
            const SizedBox(width: 12),
            Text(
              'Sign Out',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.vibrantCoral,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
