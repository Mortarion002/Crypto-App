import 'package:crypto_pulse/core/config/preference_keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PreferenceKeys', () {
    test('liveRefresh key remains stable for persisted settings', () {
      expect(PreferenceKeys.liveRefresh, 'pref_live_refresh');
    });
  });
}
