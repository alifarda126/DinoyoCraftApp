// Auth model — mapping JSON response backend ke entity
import '../../domain/entities/auth.dart';

class AuthModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final String? storeName;
  final bool? isVerified;
  final String? token;
  final String? refreshToken;

  const AuthModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.storeName,
    this.isVerified,
    this.token,
    this.refreshToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: (json['id'] is int) ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'pengunjung',
      avatarUrl: json['avatar_url']?.toString(),
      storeName: json['store_name']?.toString(),
      isVerified: json['is_verified'] is bool
          ? json['is_verified'] as bool
          : (json['is_verified'] == null ? null : '${json['is_verified']}' == '1' || '${json['is_verified']}' == 'true'),
      token: json['token']?.toString(),
      refreshToken: json['refresh_token']?.toString(),
    );
  }

  AuthUser toEntity() => AuthUser(
        id: id,
        name: name,
        email: email,
        role: role,
        avatarUrl: avatarUrl,
        storeName: storeName,
        isVerified: isVerified,
      );

  /// Representasi user untuk disimpan ke LocalStorage (bentuk JSON backend).
  Map<String, dynamic> toStorage() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (storeName != null) 'store_name': storeName,
        if (isVerified != null) 'is_verified': isVerified,
      };
}
