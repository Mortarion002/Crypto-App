import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_pulse/core/config/env.dart';

void main() {
  group('Env', () {
    test('supabaseUrl has a default value (not empty)', () {
      // Without --dart-define, supabaseUrl falls back to the default value
      expect(Env.supabaseUrl, isNotEmpty);
    });

    test('supabaseUrl default is a parseable HTTPS URL', () {
      final uri = Uri.tryParse(Env.supabaseUrl);
      expect(uri, isNotNull);
      expect(uri!.scheme, 'https');
      expect(uri.host, isNotEmpty);
    });

    test('supabaseUrl default points to the project domain', () {
      expect(Env.supabaseUrl, contains('supabase.co'));
    });
  });
}
