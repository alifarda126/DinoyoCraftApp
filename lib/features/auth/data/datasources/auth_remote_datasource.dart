// Auth remote datasource — panggilan HTTP mentah ke /api/auth/*
import '../../../../core/network/api_client.dart';
import '../models/auth_model.dart';

class AuthRemoteDatasource {
  const AuthRemoteDatasource();

  /// Login manual (email + password). Melempar ApiException saat gagal.
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    final res = await ApiClient.post('/auth/login', {
      'email': email,
      'password': password,
    });
    return _requireData(res, 'login');
  }

  /// Registrasi customer manual → OTP dikirim ke email.
  /// Return true jika server meminta verifikasi OTP (requires_otp).
  Future<bool> registerCustomer({
    required String name,
    required String email,
    required String password,
    String? username,
    String? phone,
  }) async {
    final res = await ApiClient.post('/auth/register-customer', {
      'name': name,
      if (username != null && username.isNotEmpty) 'username': username,
      'email': email,
      'password': password,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    });
    return res['requires_otp'] == true ||
        (res['data'] is Map && (res['data'] as Map)['requires_otp'] == true);
  }

  /// Registrasi via Google (isGoogleAuth) → langsung aktif + token.
  Future<AuthModel> registerCustomerGoogle({
    required String name,
    required String email,
    String? username,
    String? phone,
    String? googleId,
    String? avatarUrl,
    String? idToken,
  }) async {
    final res = await ApiClient.post('/auth/register-customer', {
      'name': name,
      if (username != null && username.isNotEmpty) 'username': username,
      'email': email,
      'phone': phone,
      'isGoogleAuth': true,
      'google_id': ?googleId,
      'avatar_url': ?avatarUrl,
      'credential': ?idToken,
    });
    return _requireData(res, 'registrasi Google');
  }

  /// Verifikasi OTP registrasi → auto-login (token diterima).
  Future<AuthModel> verifyRegisterOtp({
    required String email,
    required String otp,
  }) async {
    final res = await ApiClient.post('/auth/verify-register-otp', {
      'email': email,
      'otp': otp,
    });
    return _requireData(res, 'verifikasi OTP');
  }

  /// Kirim ulang OTP registrasi.
  Future<void> resendRegisterOtp({required String email, String? name}) async {
    await ApiClient.post('/auth/resend-register-otp', {
      'email': email,
      if (name != null && name.isNotEmpty) 'name': name,
    });
  }

  /// Login via Google idToken (credential). Melempar ApiException dengan
  /// isNotRegistered == true bila akun belum terdaftar.
  Future<AuthModel> googleLogin({
    required String credential,
    bool isRegister = false,
  }) async {
    final res = await ApiClient.post(
      isRegister ? '/auth/google-register' : '/auth/google-login',
      {'credential': credential},
    );
    return _requireData(res, 'login Google');
  }

  Future<void> forgotPassword({required String email}) async {
    await ApiClient.post('/auth/forgot-password', {'email': email});
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    await ApiClient.post('/auth/verify-otp', {'email': email, 'otp': otp});
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await ApiClient.post('/auth/reset-password', {
      'email': email,
      'otp': otp,
      'newPassword': newPassword,
    });
  }

  /// Profil lengkap dari server (GET /auth/profile).
  Future<Map<String, dynamic>> fetchProfile() async {
    final res = await ApiClient.get('/auth/profile');
    final data = res['data'];
    if (data is Map<String, dynamic>) return data;
    throw ApiException(statusCode: 200, message: 'Data profil tidak valid');
  }

  Future<void> syncFcmToken({required String fcmToken, String platform = 'android'}) async {
    await ApiClient.post('/auth/fcm-token', {
      'fcm_token': fcmToken,
      'platform': platform,
    });
  }

  // ── Helper ──────────────────────────────────────────────────────────────
  AuthModel _requireData(Map<String, dynamic> res, String action) {
    if (res['success'] != true) {
      throw ApiException(
        statusCode: 400,
        message: res['message']?.toString() ?? '$action gagal',
        rawResponse: res,
      );
    }
    final data = res['data'];
    if (data is! Map<String, dynamic> || (data['token'] ?? '').toString().isEmpty) {
      throw ApiException(
        statusCode: 500,
        message: 'Respons $action tidak berisi token',
        rawResponse: res,
      );
    }
    return AuthModel.fromJson(data);
  }
}
