import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/profile/presentation/screens/settings_screen.dart';
import 'package:crypto_pulse/features/auth/presentation/controllers/auth_controller.dart';
import 'package:crypto_pulse/features/auth/domain/entities/app_user.dart';
import 'package:crypto_pulse/core/providers/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthController extends AsyncNotifier<AppUser?> with Mock implements AuthController {
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
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
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

    testWidgets('SettingsScreen shows sign out dialog when tapping Sign Out', (tester) async {
      final user = AppUser(id: '1', email: 'test@example.com', name: 'Test User');
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
      expect(find.text('You will need to sign in again to access your watchlist and settings.'), findsOneWidget);
      
      // Clear any pending timers from animations
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
