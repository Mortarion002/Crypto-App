import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_pulse/app/router/route_names.dart';

void main() {
  group('RouteNames', () {
    test('all name constants are non-empty strings', () {
      expect(RouteNames.onboarding, isNotEmpty);
      expect(RouteNames.login, isNotEmpty);
      expect(RouteNames.signup, isNotEmpty);
      expect(RouteNames.home, isNotEmpty);
      expect(RouteNames.insights, isNotEmpty);
      expect(RouteNames.watchlist, isNotEmpty);
      expect(RouteNames.profile, isNotEmpty);
      expect(RouteNames.coinDetail, isNotEmpty);
    });

    test('all route names are unique', () {
      final names = [
        RouteNames.onboarding,
        RouteNames.login,
        RouteNames.signup,
        RouteNames.home,
        RouteNames.insights,
        RouteNames.watchlist,
        RouteNames.profile,
        RouteNames.coinDetail,
      ];
      expect(names.toSet().length, equals(names.length),
          reason: 'Duplicate route names found');
    });

    test('expected name values', () {
      expect(RouteNames.onboarding, 'onboarding');
      expect(RouteNames.login, 'login');
      expect(RouteNames.signup, 'signup');
      expect(RouteNames.home, 'home');
      expect(RouteNames.insights, 'insights');
      expect(RouteNames.watchlist, 'watchlist');
      expect(RouteNames.profile, 'profile');
      expect(RouteNames.coinDetail, 'coinDetail');
    });
  });

  group('RoutePaths', () {
    test('all paths start with /', () {
      final paths = [
        RoutePaths.onboarding,
        RoutePaths.login,
        RoutePaths.signup,
        RoutePaths.home,
        RoutePaths.insights,
        RoutePaths.watchlist,
        RoutePaths.profile,
        RoutePaths.coinDetail,
      ];
      for (final path in paths) {
        expect(path, startsWith('/'),
            reason: '"$path" should start with /');
      }
    });

    test('exact path values are correct', () {
      expect(RoutePaths.onboarding, '/onboarding');
      expect(RoutePaths.login, '/auth/login');
      expect(RoutePaths.signup, '/auth/signup');
      expect(RoutePaths.home, '/home');
      expect(RoutePaths.insights, '/insights');
      expect(RoutePaths.watchlist, '/watchlist');
      expect(RoutePaths.profile, '/profile');
      expect(RoutePaths.coinDetail, '/coin/:symbol');
    });

    test('auth routes are nested under /auth/', () {
      expect(RoutePaths.login, startsWith('/auth/'));
      expect(RoutePaths.signup, startsWith('/auth/'));
    });

    test('coinDetail path contains :symbol parameter', () {
      expect(RoutePaths.coinDetail, contains(':symbol'));
    });

    test('all paths are unique', () {
      final paths = [
        RoutePaths.onboarding,
        RoutePaths.login,
        RoutePaths.signup,
        RoutePaths.home,
        RoutePaths.insights,
        RoutePaths.watchlist,
        RoutePaths.profile,
        RoutePaths.coinDetail,
      ];
      expect(paths.toSet().length, equals(paths.length),
          reason: 'Duplicate route paths found');
    });

    test('main shell routes do not start with /auth', () {
      final shellRoutes = [
        RoutePaths.home,
        RoutePaths.insights,
        RoutePaths.watchlist,
        RoutePaths.profile,
      ];
      for (final path in shellRoutes) {
        expect(path, isNot(startsWith('/auth')),
            reason: '$path should not be an auth route');
      }
    });
  });
}
