import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';
import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const AppScaffold({super.key, required this.child, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Needed for floating nav bar
      body: child,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.canvasLevel1,
            borderRadius: AppRadius.fullRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(
                icon: LucideIcons.activity,
                label: 'Pulse',
                isActive: currentPath == RoutePaths.home,
                onTap: () => context.goNamed(RouteNames.home),
              ),
              _NavItem(
                icon: LucideIcons.barChart2,
                label: 'Insights',
                isActive: currentPath == RoutePaths.insights,
                onTap: () => context.goNamed(RouteNames.insights),
              ),
              _NavItem(
                icon: LucideIcons.star,
                label: 'Watchlist',
                isActive: currentPath == RoutePaths.watchlist,
                onTap: () => context.goNamed(RouteNames.watchlist),
              ),
              _NavItem(
                icon: LucideIcons.user,
                label: 'Profile',
                isActive: currentPath == RoutePaths.profile,
                onTap: () => context.goNamed(RouteNames.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.cyanHighlight.withOpacity(0.1) : Colors.transparent,
          borderRadius: AppRadius.fullRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.cyanHighlight : AppColors.onSurfaceVariant,
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.cyanHighlight,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
