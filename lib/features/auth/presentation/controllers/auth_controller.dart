import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_pulse/features/auth/domain/entities/app_user.dart';
import 'package:crypto_pulse/features/auth/data/repositories/supabase_auth_repository.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AppUser?>(() => AuthController());

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
      await ref.read(supabaseAuthRepositoryProvider).signIn(email: email, password: password);
      return null;
    } catch (e) {
      return _cleanError(e);
    }
  }

  Future<String?> signUp(String email, String password, String? name) async {
    try {
      await ref.read(supabaseAuthRepositoryProvider).signUp(
            email: email,
            password: password,
            name: name,
          );
      return null;
    } catch (e) {
      return _cleanError(e);
    }
  }

  Future<void> signOut() async {
    await ref.read(supabaseAuthRepositoryProvider).signOut();
  }

  String _cleanError(Object e) {
    final msg = e.toString();
    if (msg.contains('Invalid login credentials')) return 'Invalid email or password.';
    if (msg.contains('User already registered')) return 'An account with this email already exists.';
    if (msg.contains('Password should be at least')) return 'Password must be at least 6 characters.';
    if (msg.contains('Unable to validate email')) return 'Please enter a valid email address.';
    return 'Something went wrong. Please try again.';
  }
}
