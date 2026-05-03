import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/app/router/router_refresh_notifier.dart';
import 'package:crypto_pulse/core/widgets/app_scaffold.dart';
import 'package:crypto_pulse/features/market/presentation/screens/market_screen.dart';
import 'package:crypto_pulse/features/insights/presentation/screens/insights_screen.dart';
import 'package:crypto_pulse/features/coin_detail/presentation/screens/coin_detail_screen.dart';
import 'package:crypto_pulse/features/watchlist/presentation/screens/watchlist_screen.dart';
import 'package:crypto_pulse/features/profile/presentation/screens/profile_screen.dart';
import 'package:crypto_pulse/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:crypto_pulse/features/auth/presentation/screens/login_screen.dart';
import 'package:crypto_pulse/features/auth/presentation/screens/signup_screen.dart';

final _routerRefreshProvider = Provider<RouterRefreshNotifier>((ref) {
  final notifier = RouterRefreshNotifier();
  ref.onDispose(notifier.dispose);
  return notifier;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(_routerRefreshProvider);

  return GoRouter(
    refreshListenable: refresh,
    redirect: (context, state) {
      final isLoggedIn = Supabase.instance.client.auth.currentSession != null;

      final loc = state.matchedLocation;
      final isOnboarding = loc == RoutePaths.onboarding;
      final isAuthRoute = loc == RoutePaths.login || loc == RoutePaths.signup;

      if (!isLoggedIn) {
        // Allow onboarding and auth routes; send everything else to onboarding
        return (isOnboarding || isAuthRoute) ? null : RoutePaths.onboarding;
      }
      // Logged in — bounce away from onboarding/auth back to home
      if (isOnboarding || isAuthRoute) return RoutePaths.home;
      return null;
    },
    initialLocation: RoutePaths.home,
    routes: [
      // ── Onboarding ─────────────────────────────────────────────────
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ── Auth ───────────────────────────────────────────────────────
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.signup,
        name: RouteNames.signup,
        builder: (context, state) => const SignupScreen(),
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

      // ── Coin detail (outside shell) ────────────────────────────────
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
