import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: CryptoPulseApp(),
    ),
  );
}

class CryptoPulseApp extends ConsumerWidget {
  const CryptoPulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Crypto Pulse',
      theme: AppTheme.darkTheme,
      home: const PlaceholderScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Pulse'),
      ),
      body: const Center(
        child: Text('Market Pulse Setup'),
      ),
    );
  }
}
