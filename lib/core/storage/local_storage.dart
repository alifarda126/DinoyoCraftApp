import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Penyimpanan lokal untuk Token JWT, Sesi User, dan FCM Token.
abstract final class LocalStorage {
  static const String _fileName = 'dinoyocraft_auth.json';

  static String? _cachedToken;
  static Map<String, dynamic>? _cachedUser;
  static String? _cachedFcmToken;

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
          _cachedUser = data['user'] as Map<String, dynamic>?;
          _cachedFcmToken = data['fcm_token'] as String?;
        }
      }
    } catch (e) {
      debugPrint('[LocalStorage] Error reading auth file: $e');
    }
  }

  static String? getToken() => _cachedToken;

  static Map<String, dynamic>? getUser() => _cachedUser;

  static String? getFcmToken() => _cachedFcmToken;

  static bool get isLoggedIn => _cachedToken != null && _cachedToken!.isNotEmpty;

  static Future<void> saveAuth({
    required String token,
    Map<String, dynamic>? user,
  }) async {
    _cachedToken = token;
    if (user != null) _cachedUser = user;
    await _persist();
  }

  static Future<void> saveFcmToken(String fcmToken) async {
    _cachedFcmToken = fcmToken;
    await _persist();
  }

  static Future<void> clearAuth() async {
    _cachedToken = null;
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
        'user': _cachedUser,
        'fcm_token': _cachedFcmToken,
        'saved_at': DateTime.now().toIso8601String(),
      };
      await file.writeAsString(jsonEncode(payload), flush: true);
    } catch (e) {
      debugPrint('[LocalStorage] Error persisting auth: $e');
    }
  }
}
