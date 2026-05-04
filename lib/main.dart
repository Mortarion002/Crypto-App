import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto_pulse/core/config/env.dart';
import 'package:crypto_pulse/core/theme/app_theme.dart';
import 'package:crypto_pulse/app/router/app_router.dart';
import 'package:crypto_pulse/core/providers/shared_prefs_provider.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  assert(
    Env.supabaseAnonKey.isNotEmpty,
    'SUPABASE_ANON_KEY not set — run with: flutter run --dart-define-from-file=.env.json',
  );

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  final sharedPreferences = await SharedPreferences.getInstance();

  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const CryptoPulseApp(),
    ),
  );
}

class CryptoPulseApp extends ConsumerWidget {
  const CryptoPulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Crypto Pulse',
      theme: AppTheme.darkTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
