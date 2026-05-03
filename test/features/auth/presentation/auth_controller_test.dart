import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/auth/domain/entities/app_user.dart';
import 'package:crypto_pulse/features/auth/domain/repositories/auth_repository.dart';
import 'package:crypto_pulse/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:crypto_pulse/features/auth/presentation/controllers/auth_controller.dart';

// ── Fake repository ──────────────────────────────────────────────────────────

class FakeAuthRepository implements AuthRepository {
  AppUser? _currentUser;
  final String? _signInError;
  final String? _signUpError;
  final _streamCtrl = StreamController<AppUser?>.broadcast();

  FakeAuthRepository({
    AppUser? initialUser,
    String? signInError,
    String? signUpError,
  })  : _currentUser = initialUser,
        _signInError = signInError,
        _signUpError = signUpError;

  @override
  Stream<AppUser?> get authStateChanges => _streamCtrl.stream;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Future<void> signIn({required String email, required String password}) async {
    if (_signInError != null) throw Exception(_signInError);
    _currentUser = AppUser(id: 'test-id', email: email);
    _streamCtrl.add(_currentUser);
  }

  @override
  Future<void> signUp(
      {required String email, required String password, String? name}) async {
    if (_signUpError != null) throw Exception(_signUpError);
    _currentUser = AppUser(id: 'test-id', email: email, name: name);
    _streamCtrl.add(_currentUser);
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _streamCtrl.add(null);
  }

  void close() => _streamCtrl.close();
}

ProviderContainer _makeContainer(FakeAuthRepository repo) {
  return ProviderContainer(
    overrides: [supabaseAuthRepositoryProvider.overrideWithValue(repo)],
  );
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  group('AuthController — initial state', () {
    test('is null when no user is logged in', () async {
      final container = _makeContainer(FakeAuthRepository());
      addTearDown(container.dispose);

      final user = await container.read(authControllerProvider.future);
      expect(user, isNull);
    });

    test('returns current user when already logged in', () async {
      final user = AppUser(id: '1', email: 'logged@in.com', name: 'Dev');
      final container = _makeContainer(FakeAuthRepository(initialUser: user));
      addTearDown(container.dispose);

      final result = await container.read(authControllerProvider.future);
      expect(result, isNotNull);
      expect(result!.email, 'logged@in.com');
      expect(result.name, 'Dev');
    });
  });

  group('AuthController.signIn', () {
    test('returns null on success', () async {
      final container = _makeContainer(FakeAuthRepository());
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);
      final error = await container
          .read(authControllerProvider.notifier)
          .signIn('user@test.com', 'pass123');

      expect(error, isNull);
    });

    test('maps "Invalid login credentials" to friendly message', () async {
      final repo =
          FakeAuthRepository(signInError: 'Invalid login credentials');
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);
      final error = await container
          .read(authControllerProvider.notifier)
          .signIn('user@test.com', 'wrongpass');

      expect(error, 'Invalid email or password.');
    });

    test('maps "Unable to validate email" to friendly message', () async {
      final repo =
          FakeAuthRepository(signInError: 'Unable to validate email address');
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);
      final error = await container
          .read(authControllerProvider.notifier)
          .signIn('notanemail', 'pass');

      expect(error, 'Please enter a valid email address.');
    });

    test('returns generic message for unknown errors', () async {
      final repo =
          FakeAuthRepository(signInError: 'Some unexpected server meltdown');
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);
      final error = await container
          .read(authControllerProvider.notifier)
          .signIn('user@test.com', 'pass');

      expect(error, 'Something went wrong. Please try again.');
    });
  });

  group('AuthController.signUp', () {
    test('returns null on success', () async {
      final container = _makeContainer(FakeAuthRepository());
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);
      final error = await container
          .read(authControllerProvider.notifier)
          .signUp('new@user.com', 'pass123', 'New User');

      expect(error, isNull);
    });

    test('maps "User already registered" to friendly message', () async {
      final repo =
          FakeAuthRepository(signUpError: 'User already registered');
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);
      final error = await container
          .read(authControllerProvider.notifier)
          .signUp('existing@test.com', 'pass123', null);

      expect(error, 'An account with this email already exists.');
    });

    test('maps "Password should be at least" to friendly message', () async {
      final repo = FakeAuthRepository(
          signUpError: 'Password should be at least 6 characters');
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);
      final error = await container
          .read(authControllerProvider.notifier)
          .signUp('user@test.com', 'abc', null);

      expect(error, 'Password must be at least 6 characters.');
    });

    test('passes optional name correctly to repository', () async {
      final repo = FakeAuthRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);
      await container
          .read(authControllerProvider.notifier)
          .signUp('user@test.com', 'pass123', 'Aman');

      expect(repo.currentUser?.name, 'Aman');
    });

    test('accepts null name for anonymous signup', () async {
      final repo = FakeAuthRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);
      final error = await container
          .read(authControllerProvider.notifier)
          .signUp('user@test.com', 'pass123', null);

      expect(error, isNull);
      expect(repo.currentUser?.name, isNull);
    });
  });

  group('AuthController.signOut', () {
    test('state becomes null after sign out', () async {
      final user = AppUser(id: '1', email: 'test@test.com', name: 'Test');
      final container = _makeContainer(FakeAuthRepository(initialUser: user));
      addTearDown(container.dispose);

      final before = await container.read(authControllerProvider.future);
      expect(before, isNotNull);

      await container.read(authControllerProvider.notifier).signOut();
      await Future<void>.delayed(Duration.zero); // let stream tick

      final after =
          container.read(authControllerProvider).asData?.value;
      expect(after, isNull);
    });
  });
}
