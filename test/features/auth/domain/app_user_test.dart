import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_pulse/features/auth/domain/entities/app_user.dart';

void main() {
  group('AppUser', () {
    test('constructs with all fields', () {
      const user = AppUser(id: 'abc-123', email: 'test@example.com', name: 'Alice');
      expect(user.id, 'abc-123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Alice');
    });

    test('name is optional (nullable)', () {
      const user = AppUser(id: '1', email: 'test@example.com');
      expect(user.name, isNull);
    });

    test('displayName returns name when name is set', () {
      const user = AppUser(id: '1', email: 'test@example.com', name: 'Alice');
      expect(user.displayName, 'Alice');
    });

    test('displayName falls back to email prefix when name is null', () {
      const user = AppUser(id: '1', email: 'john.doe@example.com');
      expect(user.displayName, 'john.doe');
    });

    test('displayName handles simple single-word email prefix', () {
      const user = AppUser(id: '1', email: 'admin@crypto.io');
      expect(user.displayName, 'admin');
    });

    test('displayName prefers empty name string over email prefix', () {
      const user = AppUser(id: '1', email: 'test@example.com', name: '');
      // empty string is still non-null, so it's returned as-is
      expect(user.displayName, '');
    });
  });
}
