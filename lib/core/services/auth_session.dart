import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
import '../storage/local_storage.dart';

/// Sesi autentikasi terpusat tunggal (singleton + ChangeNotifier).
///
/// Semua perubahan sesi (login, update profil, logout) lewat sini agar
/// router guard & UI yang mendengarkan ikut diperbarui.
class AuthSession extends ChangeNotifier {
  AuthSession._();

  static final AuthSession instance = AuthSession._();

  static String? get token => LocalStorage.getToken();
  static String? get refreshToken => LocalStorage.getRefreshToken();
  static Map<String, dynamic>? get user => LocalStorage.getUser();
  static bool get isLoggedIn => LocalStorage.isLoggedIn;

  /// Simpan sesi baru (login manual / Google / auto-login setelah OTP).
  static Future<void> signIn({
    required String token,
    String? refreshToken,
    Map<String, dynamic>? user,
  }) async {
    await LocalStorage.saveAuth(
      token: token,
      refreshToken: refreshToken,
      user: user,
    );
    ApiClient.authToken = token;
    instance.notifyListeners();
  }

  /// Perbarui data profil user yang tersimpan (mis. setelah GET /auth/profile).
  static Future<void> updateUser(Map<String, dynamic> user) async {
    await LocalStorage.saveUser(user);
    instance.notifyListeners();
  }

  /// Hapus sesi (logout / refresh token ditolak).
  static Future<void> signOut() async {
    await LocalStorage.clearAuth();
    ApiClient.authToken = null;
    instance.notifyListeners();
  }
}
