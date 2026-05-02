import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/core/widgets/app_scaffold.dart';
import 'package:crypto_pulse/features/market/presentation/screens/market_screen.dart';
import 'package:crypto_pulse/features/insights/presentation/screens/insights_screen.dart';
import 'package:crypto_pulse/features/coin_detail/presentation/screens/coin_detail_screen.dart';
import 'package:crypto_pulse/features/watchlist/presentation/screens/watchlist_screen.dart';
import 'package:crypto_pulse/features/profile/presentation/screens/profile_screen.dart';
import 'package:crypto_pulse/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:crypto_pulse/core/providers/shared_prefs_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  final onboardingDone = prefs.getBool('onboarding_complete') ?? false;

  return GoRouter(
    initialLocation: onboardingDone ? RoutePaths.home : RoutePaths.onboarding,
    routes: [
      // ── Onboarding (outside shell, no nav bar) ─────────────────────
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ── Main shell with bottom nav ─────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AppScaffold(
          currentPath: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: RoutePaths.home,
            name: RouteNames.home,
            builder: (context, state) => const MarketScreen(),
          ),
          GoRoute(
            path: RoutePaths.insights,
            name: RouteNames.insights,
            builder: (context, state) => const InsightsScreen(),
          ),
          GoRoute(
            path: RoutePaths.watchlist,
            name: RouteNames.watchlist,
            builder: (context, state) => const WatchlistScreen(),
          ),
          GoRoute(
            path: RoutePaths.profile,
            name: RouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // ── Coin detail (outside shell, no nav bar) ────────────────────
      GoRoute(
        path: RoutePaths.coinDetail,
        name: RouteNames.coinDetail,
        builder: (context, state) {
          final symbol = state.pathParameters['symbol']!;
          return CoinDetailScreen(symbol: symbol);
        },
      ),
    ],
  );
});

// Helper: call this after completing onboarding to mark it done.
Future<void> markOnboardingComplete() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('onboarding_complete', true);
}
