import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../network/api_client.dart';
import '../storage/local_storage.dart';

/// Service untuk menangani Google Sign-In terintegrasi dengan Backend DinoyoCraft
class GoogleAuthService {
  /// Web Client ID (digunakan sebagai serverClientId agar Google menerbitkan idToken)
  static const String webClientId =
      '379734738528-dc5htqtqu1k8qn5khubul347aghuka6r.apps.googleusercontent.com';

  static bool _initialized = false;

  /// Memastikan instance GoogleSignIn diinisialisasi dengan serverClientId
  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId: webClientId,
      );
      _initialized = true;
    } catch (e) {
      debugPrint('[GoogleAuthService] Initialize error: $e');
    }
  }

  /// Menjalankan alur login interaktif dengan Google
  static Future<Map<String, dynamic>?> signIn({String role = 'pengunjung'}) async {
    await ensureInitialized();

    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;

      debugPrint('[GoogleAuthService] Google Authenticated: ${account.email}, idToken present: ${idToken != null}');

      // Kirim idToken dan metadata profil ke backend DinoyoCraft
      final payload = <String, dynamic>{
        'credential': idToken,
        'role': role,
        'userInfo': {
          'email': account.email,
          'name': account.displayName ?? 'Pengguna Google',
          'picture': account.photoUrl,
          'id': account.id,
        },
      };

      final response = await ApiClient.post('/auth/google-login', payload);

      if (response['success'] == true || response['token'] != null) {
        final token = (response['token'] ?? response['data']?['token']) as String?;
        if (token != null && token.isNotEmpty) {
          ApiClient.authToken = token;
          final userMap = response['data'] is Map<String, dynamic>
              ? response['data'] as Map<String, dynamic>
              : {'name': account.displayName, 'email': account.email};

          await LocalStorage.saveAuth(token: token, user: userMap);

          // Daftarkan FCM token otomatis ke backend jika sudah ada di LocalStorage
          final fcmToken = LocalStorage.getFcmToken();
          if (fcmToken != null && fcmToken.isNotEmpty) {
            ApiClient.post('/user/fcm-token', {'fcm_token': fcmToken}).catchError((_) => <String, dynamic>{});
          }

          return response;
        }
      }

      throw Exception(response['message'] ?? 'Gagal memproses otentikasi dengan server DinoyoCraft');
    } catch (e) {
      debugPrint('[GoogleAuthService] Sign-in failed: $e');
      rethrow;
    }
  }

  /// Logout akun Google dan bersihkan sesi lokal
  static Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      debugPrint('[GoogleAuthService] Sign-out error: $e');
    }
    await LocalStorage.clearAuth();
    ApiClient.authToken = null;
  }
}
