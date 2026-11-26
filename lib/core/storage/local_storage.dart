import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Penyimpanan lokal untuk Token JWT, Sesi User, dan FCM Token.
abstract final class LocalStorage {
  static const String _fileName = 'dinoyocraft_auth.json';

  static String? _cachedToken;
  static String? _cachedRefreshToken;
  static Map<String, dynamic>? _cachedUser;
  static String? _cachedFcmToken;
  static String? _cachedLocale;
  static bool _cachedOrderNotif = true;
  static bool _cachedWhatsAppNotif = true;
  static String? _cachedLastBaseHost;
  static String? _cachedLastDeviceUserId;

  static Future<File> _getFile() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      return File('${docDir.path}/$_fileName');
    } catch (_) {
      try {
        final supportDir = await getApplicationSupportDirectory();
        return File('${supportDir.path}/$_fileName');
      } catch (_) {
        return File('${Directory.systemTemp.path}/$_fileName');
      }
    }
  }

  /// Inisialisasi awal saat aplikasi mulai
  static Future<void> init() async {
    if (kIsWeb) return;
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
        final data = jsonDecode(content) as Map<String, dynamic>;
        _cachedToken = data['token'] as String?;
        _cachedRefreshToken = data['refresh_token'] as String?;
        _cachedUser = data['user'] as Map<String, dynamic>?;
        _cachedFcmToken = data['fcm_token'] as String?;
        _cachedLocale = data['locale'] as String?;
        _cachedLastBaseHost = data['last_base_host'] as String?;
        _cachedLastDeviceUserId = data['last_device_user_id']?.toString();
        if (data['order_notification'] is bool) {
          _cachedOrderNotif = data['order_notification'] as bool;
        }
        if (data['whatsapp_notification'] is bool) {
          _cachedWhatsAppNotif = data['whatsapp_notification'] as bool;
        }
        }
      }
    } catch (e) {
      debugPrint('[LocalStorage] Error reading auth file: $e');
    }
  }

  static String? getToken() => _cachedToken;

  static String? getRefreshToken() => _cachedRefreshToken;

  static Map<String, dynamic>? getUser() => _cachedUser;

  static String? getFcmToken() => _cachedFcmToken;

  static bool get isLoggedIn => _cachedToken != null && _cachedToken!.isNotEmpty;

  static Future<void> saveAuth({
    required String token,
    String? refreshToken,
    Map<String, dynamic>? user,
  }) async {
    _cachedToken = token;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      _cachedRefreshToken = refreshToken;
    }
    if (user != null) _cachedUser = user;
    await _persist();
  }

  /// Simpan/perbarui data user saja (mis. setelah fetch /auth/profile)
  /// tanpa menyentuh token.
  static Future<void> saveUser(Map<String, dynamic> user) async {
    _cachedUser = user;
    await _persist();
  }

  static Future<void> saveFcmToken(String fcmToken) async {
    _cachedFcmToken = fcmToken;
    await _persist();
  }

  static String? getLocale() => _cachedLocale;
  static bool getOrderNotification() => _cachedOrderNotif;
  static bool getWhatsAppNotification() => _cachedWhatsAppNotif;
  static String? getLastBaseHost() => _cachedLastBaseHost;
  static String? getLastDeviceUserId() => _cachedLastDeviceUserId;

  static Future<void> saveLastDeviceUserId(String userId) async {
    final trimmed = userId.trim();
    if (trimmed.isEmpty || _cachedLastDeviceUserId == trimmed) return;
    _cachedLastDeviceUserId = trimmed;
    await _persist();
  }

  static Future<void> saveLastBaseHost(String host) async {
    final normalized = host.trim().replaceAll(RegExp(r'/+$'), '');
    if (normalized.isEmpty || _cachedLastBaseHost == normalized) return;
    _cachedLastBaseHost = normalized;
    await _persist();
  }

  static Future<void> savePreferences({
    String? locale,
    bool? orderNotification,
    bool? whatsAppNotification,
  }) async {
    if (locale != null) _cachedLocale = locale;
    if (orderNotification != null) _cachedOrderNotif = orderNotification;
    if (whatsAppNotification != null) _cachedWhatsAppNotif = whatsAppNotification;
    await _persist();
  }

  static Future<void> clearAuth() async {
    _cachedToken = null;
    _cachedRefreshToken = null;
    _cachedUser = null;
    await _persist();
  }

  static Future<void> _persist() async {
    if (kIsWeb) return;
    try {
      final file = await _getFile();
      final parent = file.parent;
      if (!parent.existsSync()) {
        parent.createSync(recursive: true);
      }
      final payload = {
        'token': _cachedToken,
        'refresh_token': _cachedRefreshToken,
        'user': _cachedUser,
        'fcm_token': _cachedFcmToken,
        'locale': _cachedLocale,
        'order_notification': _cachedOrderNotif,
        'whatsapp_notification': _cachedWhatsAppNotif,
        'last_base_host': _cachedLastBaseHost,
        'last_device_user_id': _cachedLastDeviceUserId,
        'saved_at': DateTime.now().toIso8601String(),
      };
      await file.writeAsString(jsonEncode(payload), flush: true);
    } catch (e) {
      debugPrint('[LocalStorage] Error persisting auth: $e');
    }
  }
}
