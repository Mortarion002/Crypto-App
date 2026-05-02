class AppUser {
  final String id;
  final String email;
  final String? name;

  const AppUser({required this.id, required this.email, this.name});

  String get displayName => name ?? email.split('@').first;
}
