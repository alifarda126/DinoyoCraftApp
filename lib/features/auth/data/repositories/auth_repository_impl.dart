// Auth repository impl — datasource + penyimpanan sesi (AuthSession)
import '../../../../core/services/auth_session.dart';
import '../../domain/entities/auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;

  AuthRepositoryImpl({AuthRemoteDatasource? datasource})
      : remote = datasource ?? const AuthRemoteDatasource();

  @override
  Future<AuthUser> login({required String email, required String password}) async {
    final model = await remote.login(email: email, password: password);
    await _persist(model);
    return model.toEntity();
  }

  @override
  Future<bool> registerCustomer({
    required String name,
    required String email,
    required String password,
    String? username,
    String? phone,
  }) {
    return remote.registerCustomer(
      name: name,
      email: email,
      password: password,
      username: username,
      phone: phone,
    );
  }

  @override
  Future<AuthUser> registerCustomerGoogle({
    required String name,
    required String email,
    String? username,
    String? phone,
    String? googleId,
    String? avatarUrl,
    String? idToken,
  }) async {
    final model = await remote.registerCustomerGoogle(
      name: name,
      email: email,
      username: username,
      phone: phone,
      googleId: googleId,
      avatarUrl: avatarUrl,
      idToken: idToken,
    );
    await _persist(model);
    return model.toEntity();
  }

  @override
  Future<AuthUser> verifyRegisterOtp({required String email, required String otp}) async {
    final model = await remote.verifyRegisterOtp(email: email, otp: otp);
    await _persist(model);
    return model.toEntity();
  }

  @override
  Future<void> resendRegisterOtp({required String email, String? name}) =>
      remote.resendRegisterOtp(email: email, name: name);

  @override
  Future<AuthUser> googleLogin({required String credential, bool isRegister = false}) async {
    final model = await remote.googleLogin(credential: credential, isRegister: isRegister);
    await _persist(model);
    return model.toEntity();
  }

  @override
  Future<void> forgotPassword({required String email}) =>
      remote.forgotPassword(email: email);

  @override
  Future<void> verifyOtp({required String email, required String otp}) =>
      remote.verifyOtp(email: email, otp: otp);

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) =>
      remote.resetPassword(email: email, otp: otp, newPassword: newPassword);

  @override
  Future<Map<String, dynamic>> fetchProfile() => remote.fetchProfile();

  @override
  Future<void> syncFcmToken({required String fcmToken, String platform = 'android'}) =>
      remote.syncFcmToken(fcmToken: fcmToken, platform: platform);

  /// Simpan token + refresh token + data user ke sesi terpusat.
  Future<void> _persist(AuthModel model) async {
    await AuthSession.signIn(
      token: model.token!,
      refreshToken: model.refreshToken,
      user: model.toStorage(),
    );
  }
}
