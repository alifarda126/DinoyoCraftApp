// Auth repository abstraction (domain layer)
import '../entities/auth.dart';

abstract class AuthRepository {
  Future<AuthUser> login({required String email, required String password});
  Future<bool> registerCustomer({
    required String name,
    required String email,
    required String password,
    String? username,
    String? phone,
  });
  Future<AuthUser> registerCustomerGoogle({
    required String name,
    required String email,
    String? username,
    String? phone,
    String? googleId,
    String? avatarUrl,
    String? idToken,
  });
  Future<AuthUser> verifyRegisterOtp({required String email, required String otp});
  Future<void> resendRegisterOtp({required String email, String? name});
  Future<AuthUser> googleLogin({required String credential, bool isRegister = false});
  Future<void> forgotPassword({required String email});
  Future<void> verifyOtp({required String email, required String otp});
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
  Future<Map<String, dynamic>> fetchProfile();
  Future<void> syncFcmToken({required String fcmToken, String platform});
}
