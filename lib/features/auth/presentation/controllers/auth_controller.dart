import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/auth/domain/entities/app_user.dart';
import 'package:crypto_pulse/features/auth/data/repositories/supabase_auth_repository.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, AppUser?>(
  () => AuthController(),
);

class AuthSubmitResult {
  final String? error;
  final String? message;

  const AuthSubmitResult._({this.error, this.message});

  const AuthSubmitResult.success([String? message]) : this._(message: message);

  const AuthSubmitResult.failure(String error) : this._(error: error);

  bool get isSuccess => error == null;
}

class AuthController extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    final repo = ref.read(supabaseAuthRepositoryProvider);
    final sub = repo.authStateChanges.listen((user) {
      state = AsyncValue.data(user);
    });
    ref.onDispose(sub.cancel);
    return repo.currentUser;
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await ref
          .read(supabaseAuthRepositoryProvider)
          .signIn(email: email, password: password);
      return null;
    } catch (e) {
      return _cleanError(e);
    }
  }

  Future<AuthSubmitResult> signUp(
    String email,
    String password,
    String? name,
  ) async {
    try {
      final result = await ref
          .read(supabaseAuthRepositoryProvider)
          .signUp(email: email, password: password, name: name);
      if (result.signedIn) return const AuthSubmitResult.success();
      return const AuthSubmitResult.success(
        'Account created. Check your email to confirm it, then sign in.',
      );
    } catch (e) {
      return AuthSubmitResult.failure(_cleanError(e));
    }
  }

  Future<void> signOut() async {
    await ref.read(supabaseAuthRepositoryProvider).signOut();
  }

  String _cleanError(Object e) {
    final msg = e.toString();
    if (msg.contains('Invalid login credentials')) {
      return 'Invalid email or password.';
    }
    if (msg.contains('Email not confirmed')) {
      return 'Please confirm your email before signing in.';
    }
    if (msg.contains('over_email_send_rate_limit') ||
        msg.contains('email rate limit')) {
      return 'Too many signup attempts. Please wait a few minutes and try again.';
    }
    if (msg.contains('User already registered')) {
      return 'An account with this email already exists.';
    }
    if (msg.contains('Password should be at least')) {
      return 'Password must be at least 6 characters.';
    }
    if (msg.contains('Unable to validate email')) {
      return 'Please enter a valid email address.';
    }
    return 'Something went wrong. Please try again.';
  }
}
