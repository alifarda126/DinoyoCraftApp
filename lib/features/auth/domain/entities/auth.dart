// Auth entity — user yang sedang login (domain layer)
class AuthUser {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final String? storeName;
  final bool? isVerified;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.storeName,
    this.isVerified,
  });
}
