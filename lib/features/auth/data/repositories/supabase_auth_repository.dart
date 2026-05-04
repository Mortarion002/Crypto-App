import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto_pulse/features/auth/domain/entities/app_user.dart';
import 'package:crypto_pulse/features/auth/domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

  @override
  Stream<AppUser?> get authStateChanges => _client.auth.onAuthStateChange.map(
    (event) => _fromUser(event.session?.user),
  );

  @override
  AppUser? get currentUser => _fromUser(_client.auth.currentUser);

  @override
  Future<SignUpResult> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: name != null && name.isNotEmpty ? {'name': name} : null,
    );

    // Session granted immediately — email confirmation is disabled on this project.
    if (response.session != null || _client.auth.currentSession != null) {
      return const SignUpResult(signedIn: true);
    }

    // No session yet. Try signing in immediately — this succeeds when the
    // Supabase project does not require email confirmation but signUp still
    // returns a null session (e.g. certain auth config states).
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (_client.auth.currentSession != null) {
        return const SignUpResult(signedIn: true);
      }
    } catch (_) {
      // Sign-in failed — email confirmation is required. Fall through.
    }

    return const SignUpResult(signedIn: false);
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  AppUser? _fromUser(User? user) {
    if (user == null) return null;
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] as String?,
    );
  }
}

final supabaseAuthRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository(Supabase.instance.client);
});
