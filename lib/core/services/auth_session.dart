import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
import '../../data/mock_data.dart';
import '../app_settings.dart';
import '../app_text.dart';
import '../storage/local_storage.dart';
import 'fcm_service.dart';

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

  /// Memformat ID akun customer dari database dengan prefix #DNC (contoh: #DNC-0012).
  static String formatCustomerId([dynamic rawId]) {
    final val = rawId ?? user?['id'] ?? user?['userId'];
    final parsed = int.tryParse(val?.toString() ?? '');
    if (parsed != null && parsed > 0) {
      final padded = parsed.toString().padLeft(4, '0');
      return '#DNC-$padded';
    }
    return '#DNC-0001';
  }

  /// Simpan sesi baru (login manual / Google / auto-login setelah OTP).
  static Future<void> signIn({
    required String token,
    String? refreshToken,
    Map<String, dynamic>? user,
  }) async {
    final prevDeviceUserId = LocalStorage.getLastDeviceUserId();
    final newUserId = (user?['id'] ?? user?['userId'])?.toString().trim();

    await LocalStorage.saveAuth(
      token: token,
      refreshToken: refreshToken,
      user: user,
    );
    if (newUserId != null && newUserId.isNotEmpty) {
      await LocalStorage.saveLastDeviceUserId(newUserId);
    }
    ApiClient.authToken = token;
    if (user != null && user.containsKey('two_factor_enabled')) {
      final raw = user['two_factor_enabled'];
      AppSettings.instance.setTwoFactor(raw == true || raw == 1 || raw == '1');
    }
    MockData.userProfilePhotoPath = null;
    MockData.userProfilePhotoBytes = null;
    unawaited(MockData.fetchCartFromBackend());
    instance.notifyListeners();

    // Jika pada HP yang sama terjadi login menggunakan akun berbeda dari sesi sebelumnya,
    // tampilkan push notifikasi keamanan di bagian atas layar.
    if (prevDeviceUserId != null &&
        prevDeviceUserId.isNotEmpty &&
        newUserId != null &&
        newUserId.isNotEmpty &&
        prevDeviceUserId != newUserId) {
      final accountLabel = (user?['username'] ??
              user?['name'] ??
              user?['email'] ??
              'Akun Baru')
          .toString()
          .trim();
      unawaited(
        FcmService.instance.showSecuritySystemNotification(
          title: 'Login Akun Baru di Perangkat Ini'.tr,
          body:
              '${'Akun'.tr} $accountLabel ${'baru saja masuk pada perangkat ini.'.tr}',
          route: '/settings?open=devices',
          dedupKey: 'security:same_phone_switch:$newUserId',
          data: {
            'type': 'security',
            'subtype': 'same_phone_login',
            'route': '/settings?open=devices',
          },
        ),
      );
    }
  }

  /// Perbarui data profil user yang tersimpan (mis. setelah GET /auth/profile).
  static Future<void> updateUser(
    Map<String, dynamic> user, {
    bool notify = true,
  }) async {
    await LocalStorage.saveUser(user);
    if (user.containsKey('two_factor_enabled')) {
      final raw = user['two_factor_enabled'];
      final enabled = raw == true || raw == 1 || raw == '1';
      if (notify) {
        AppSettings.instance.setTwoFactor(enabled);
      } else {
        AppSettings.instance.twoFactorEnabled = enabled;
      }
    }
    if (notify) {
      instance.notifyListeners();
    }
  }

  /// Hapus sesi (logout / refresh token ditolak).
  static Future<void> signOut() async {
    await LocalStorage.clearAuth();
    ApiClient.authToken = null;
    MockData.userProfilePhotoPath = null;
    MockData.userProfilePhotoBytes = null;
    MockData.clearLocalCartOnly();
    instance.notifyListeners();
  }
}
