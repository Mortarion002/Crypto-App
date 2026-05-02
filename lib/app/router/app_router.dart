import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_pulse/app/router/route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.home,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const PlaceholderScreen(title: 'Home'),
      ),
      GoRoute(
        path: RoutePaths.insights,
        name: RouteNames.insights,
        builder: (context, state) => const PlaceholderScreen(title: 'Insights'),
      ),
      GoRoute(
        path: RoutePaths.watchlist,
        name: RouteNames.watchlist,
        builder: (context, state) => const PlaceholderScreen(title: 'Watchlist'),
      ),
      GoRoute(
        path: RoutePaths.profile,
        name: RouteNames.profile,
        builder: (context, state) => const PlaceholderScreen(title: 'Profile'),
      ),
      GoRoute(
        path: RoutePaths.coinDetail,
        name: RouteNames.coinDetail,
        builder: (context, state) {
          final symbol = state.pathParameters['symbol']!;
          return PlaceholderScreen(title: 'Coin Detail: $symbol');
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
