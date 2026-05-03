import 'package:crypto_pulse/features/auth/domain/entities/app_user.dart';

class SignUpResult {
  final bool signedIn;

  const SignUpResult({required this.signedIn});
}

abstract interface class AuthRepository {
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;
  Future<SignUpResult> signUp({
    required String email,
    required String password,
    String? name,
  });
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
}
