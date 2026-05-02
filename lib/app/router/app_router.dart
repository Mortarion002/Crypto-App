import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/core/widgets/app_scaffold.dart';
import 'package:crypto_pulse/features/market/presentation/screens/market_screen.dart';
import 'package:crypto_pulse/features/insights/presentation/screens/insights_screen.dart';
import 'package:crypto_pulse/features/coin_detail/presentation/screens/coin_detail_screen.dart';
import 'package:crypto_pulse/features/watchlist/presentation/screens/watchlist_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppScaffold(
            currentPath: state.uri.path,
            child: child,
          );
        },
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
            builder: (context, state) => const PlaceholderScreen(title: 'Profile'),
          ),
        ],
      ),
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

class PlaceholderScreen extends StatelessWidget {
  final String title;
  
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Screen: $title')),
    );
  }
}

