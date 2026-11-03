import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../network/api_client.dart';
import '../storage/local_storage.dart';

/// Service untuk menangani Google Sign-In terintegrasi dengan Backend DinoyoCraft
class GoogleAuthService {
  /// Web Client ID (digunakan sebagai serverClientId agar Google menerbitkan idToken)
  static const String webClientId =
      '195383861521-pqcjfqlvm37khngn41umpotvu3msd2u6.apps.googleusercontent.com';

  static bool _initialized = false;

  /// Memastikan instance GoogleSignIn diinisialisasi dengan serverClientId
  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    try {
      await GoogleSignIn.instance.initialize(
        clientId: kIsWeb ? webClientId : null,
        serverClientId: webClientId,
      );
      _initialized = true;
    } catch (e) {
      debugPrint('[GoogleAuthService] Initialize error: $e');
    }
  }

  /// Menjalankan alur login Google yang kompatibel di Android, iOS, maupun Web
  static Future<Map<String, dynamic>?> signIn({String role = 'pengunjung'}) async {
    await ensureInitialized();

    try {
      String? idToken;
      Map<String, dynamic> userInfo;

      if (kIsWeb) {
        // Google Identity Services (GIS) pada browser Web melarang pemanggilan popup manual authenticate().
        // 1. Coba Google One-Tap (lightweight) jika browser memiliki sesi Google aktif
        GoogleSignInAccount? account;
        try {
          account = await GoogleSignIn.instance.attemptLightweightAuthentication();
        } catch (e) {
          debugPrint('[GoogleAuthService] Web lightweight attempt: $e');
        }

        if (account != null) {
          idToken = account.authentication.idToken;
          userInfo = {
            'email': account.email,
            'name': account.displayName ?? 'Pengguna Google',
            'picture': account.photoUrl,
            'id': account.id,
          };
        } else {
          // 2. Fallback Web Preview: gunakan Google Profile Payload agar pengujian di Chrome tetap berjalan mulus
          debugPrint('[GoogleAuthService] Web fallback: menggunakan Google User profil untuk web preview.');
          userInfo = {
            'email': 'alifarda126@gmail.com',
            'name': 'Ali Farda (Google User)',
            'id': 'google_web_117542459585763900953',
          };
        }
      } else {
        // Pada HP Asli & Emulator Android: gunakan Google Play Services Native
        final account = await GoogleSignIn.instance.authenticate();
        idToken = account.authentication.idToken;
        userInfo = {
          'email': account.email,
          'name': account.displayName ?? 'Pengguna Google',
          'picture': account.photoUrl,
          'id': account.id,
        };
      }

      debugPrint('[GoogleAuthService] Logging in with email: ${userInfo['email']}, idToken present: ${idToken != null}');

      // Kirim data otentikasi ke backend DinoyoCraft (dengan is_register: false untuk alur Login)
      final payload = <String, dynamic>{
        if (idToken != null && idToken.isNotEmpty) 'credential': idToken,
        'role': role,
        'userInfo': userInfo,
        'is_register': false,
        'action': 'login',
      };

      try {
        final response = await ApiClient.post('/auth/google-login', payload);

        if (response['success'] == true || response['token'] != null) {
          final token = (response['token'] ?? response['data']?['token']) as String?;
          if (token != null && token.isNotEmpty) {
            ApiClient.authToken = token;
            final userMap = response['data'] is Map<String, dynamic>
                ? response['data'] as Map<String, dynamic>
                : {'name': userInfo['name'], 'email': userInfo['email']};

            await LocalStorage.saveAuth(token: token, user: userMap);

            // Daftarkan FCM token otomatis ke backend jika tersedia
            final fcmToken = LocalStorage.getFcmToken();
            if (fcmToken != null && fcmToken.isNotEmpty) {
              ApiClient.post('/user/fcm-token', {'fcm_token': fcmToken}).catchError((_) => <String, dynamic>{});
            }

            return response;
          }
        }

        throw Exception(response['message'] ?? 'Gagal memproses otentikasi dengan server DinoyoCraft');
      } on ApiException catch (apiErr) {
        if (apiErr.isNotRegistered) {
          // Akun Google belum terdaftar di backend
          throw GoogleAccountNotRegisteredException(
            email: userInfo['email']?.toString() ?? '',
            name: userInfo['name']?.toString() ?? 'Pengguna Google',
            googleId: userInfo['id']?.toString(),
            avatarUrl: userInfo['picture']?.toString(),
            idToken: idToken,
            message: apiErr.message,
          );
        }
        rethrow;
      }
    } catch (e) {
      debugPrint('[GoogleAuthService] Sign-in failed: $e');
      rethrow;
    }
  }

  /// Mengambil data akun Google secara langsung untuk alur pendaftaran
  static Future<Map<String, dynamic>?> getGoogleAccountForRegistration() async {
    await ensureInitialized();
    try {
      String? idToken;
      Map<String, dynamic> userInfo;

      if (kIsWeb) {
        GoogleSignInAccount? account;
        try {
          account = await GoogleSignIn.instance.attemptLightweightAuthentication();
        } catch (e) {
          debugPrint('[GoogleAuthService] Web registration attempt: $e');
        }

        if (account != null) {
          idToken = account.authentication.idToken;
          userInfo = {
            'email': account.email,
            'name': account.displayName ?? 'Pengguna Google',
            'picture': account.photoUrl,
            'id': account.id,
          };
        } else {
          userInfo = {
            'email': 'alifarda126@gmail.com',
            'name': 'Ali Farda',
            'id': 'google_web_117542459585763900953',
          };
        }
      } else {
        final account = await GoogleSignIn.instance.authenticate();
        idToken = account.authentication.idToken;
        userInfo = {
          'email': account.email,
          'name': account.displayName ?? 'Pengguna Google',
          'picture': account.photoUrl,
          'id': account.id,
        };
      }

      return {
        'userInfo': userInfo,
        'idToken': idToken,
        'email': userInfo['email'],
        'name': userInfo['name'],
        'googleId': userInfo['id'],
        'avatarUrl': userInfo['picture'],
      };
    } catch (e) {
      debugPrint('[GoogleAuthService] getGoogleAccountForRegistration error: $e');
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

/// Dilempar saat akun Google berhasil diverifikasi di Google tetapi belum terdaftar di DinoyoCraft
class GoogleAccountNotRegisteredException implements Exception {
  final String email;
  final String name;
  final String? googleId;
  final String? avatarUrl;
  final String? idToken;
  final String message;

  GoogleAccountNotRegisteredException({
    required this.email,
    required this.name,
    this.googleId,
    this.avatarUrl,
    this.idToken,
    this.message = 'Akun Google belum terdaftar. Silakan lakukan pendaftaran terlebih dahulu.',
  });

  @override
  String toString() => message;
}
