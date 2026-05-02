import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto_pulse/features/auth/domain/entities/app_user.dart';
import 'package:crypto_pulse/features/auth/domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

  @override
  Stream<AppUser?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((event) => _fromUser(event.session?.user));

  @override
  AppUser? get currentUser => _fromUser(_client.auth.currentUser);

  @override
  Future<void> signUp({required String email, required String password, String? name}) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: name != null && name.isNotEmpty ? {'name': name} : null,
    );
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
