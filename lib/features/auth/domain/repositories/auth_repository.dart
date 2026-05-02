import 'package:crypto_pulse/features/auth/domain/entities/app_user.dart';

abstract interface class AuthRepository {
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;
  Future<void> signUp({required String email, required String password, String? name});
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
}
