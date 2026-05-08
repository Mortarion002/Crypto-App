import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/profile/presentation/screens/settings_screen.dart';
import 'package:crypto_pulse/features/profile/presentation/screens/delete_account_screen.dart';
import 'package:crypto_pulse/features/profile/presentation/screens/market_preferences_screen.dart';
import 'package:crypto_pulse/features/auth/presentation/controllers/auth_controller.dart';
import 'package:crypto_pulse/features/auth/domain/entities/app_user.dart';
import 'package:crypto_pulse/core/providers/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthController extends AsyncNotifier<AppUser?>
    with Mock
    implements AuthController {
  AppUser? _user;
  void setUser(AppUser? user) => _user = user;

  @override
  Future<AppUser?> build() async => _user;
}

void main() {
  SharedPreferences? prefs;

  group('SettingsScreen Widget Tests', () {
    late MockAuthController mockAuthController;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    setUp(() {
      mockAuthController = MockAuthController();
    });

    Widget createSettingsScreen() {
      return ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(() => mockAuthController),
          sharedPreferencesProvider.overrideWithValue(prefs!),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      );
    }

    testWidgets('SettingsScreen displays title', (tester) async {
      mockAuthController.setUser(null);

      await tester.pumpWidget(createSettingsScreen());
      await tester.pumpAndSettle();

      expect(find.text('CRYPTO PULSE'), findsOneWidget);
    });

    testWidgets('SettingsScreen displays section headers', (tester) async {
      mockAuthController.setUser(null);

      await tester.pumpWidget(createSettingsScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.text('ACCOUNT'), findsOneWidget);
      expect(find.text('PREFERENCES'), findsOneWidget);

      final marketDataLabel = find.text('MARKET DATA');
      await tester.scrollUntilVisible(marketDataLabel, 100);
      expect(marketDataLabel, findsOneWidget);

      final supportLabel = find.text('SUPPORT');
      await tester.scrollUntilVisible(supportLabel, 100);
      expect(supportLabel, findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('SettingsScreen shows sign out dialog when tapping Sign Out', (
      tester,
    ) async {
      final user = AppUser(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );
      mockAuthController.setUser(user);

      await tester.pumpWidget(createSettingsScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      final signOutTile = find.text('Sign Out');
      await tester.scrollUntilVisible(signOutTile, 100);
      await tester.tap(signOutTile);
      await tester.pumpAndSettle();

      expect(find.text('Sign Out?'), findsOneWidget);
      expect(
        find.text(
          'You will need to sign in again to access your watchlist and settings.',
        ),
        findsOneWidget,
      );

      // Clear any pending timers from animations
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('SettingsScreen opens Security detail screen', (tester) async {
      mockAuthController.setUser(null);

      await tester.pumpWidget(createSettingsScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Security'));
      await tester.pumpAndSettle();

      expect(find.text('Security score: 82'), findsOneWidget);
      expect(find.text('Two-Factor Authentication'), findsOneWidget);
    });

    testWidgets('SettingsScreen opens Data Source detail screen', (
      tester,
    ) async {
      mockAuthController.setUser(null);

      await tester.pumpWidget(createSettingsScreen());
      await tester.pumpAndSettle();

      final dataSourceTile = find.text('Data Source');
      await tester.scrollUntilVisible(dataSourceTile, 250);
      await tester.pumpAndSettle();
      await tester.ensureVisible(dataSourceTile);
      await tester.pumpAndSettle();
      await tester.tap(dataSourceTile.hitTestable());
      await tester.pumpAndSettle();

      expect(find.text('Binance Public API'), findsOneWidget);
      expect(find.text('Ticker latency'), findsOneWidget);
    });

    testWidgets('MarketPreferencesScreen switches currency selection', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MarketPreferencesScreen(
            initialMode: MarketPreferencesMode.currency,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Default display: USD'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'Set').first);
      await tester.pumpAndSettle();

      expect(find.text('Default display: EUR'), findsOneWidget);
    });

    testWidgets('DeleteAccountScreen is simulated and gated', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DeleteAccountScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Deletion preview only'), findsOneWidget);
      expect(find.text('Preview Delete Request'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Preview Delete Request'),
      );
      expect(button.onPressed, isNull);
    });
  });
}
