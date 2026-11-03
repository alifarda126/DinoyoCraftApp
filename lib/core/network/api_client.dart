import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../storage/local_storage.dart';

class ApiClient {
  static final List<String> candidateHosts = [
    'http://127.0.0.1:5000',
    'http://192.168.1.2:5000',
    'http://192.168.110.161:5000',
    'http://10.0.2.2:5000',
  ];

  static int _activeHostIndex = 0;

  static String get baseHost => candidateHosts[_activeHostIndex];
  static String get baseUrl => '$baseHost/api';

  static String? _authToken;

  static String? get authToken => _authToken ?? LocalStorage.getToken();
  static set authToken(String? token) => _authToken = token;

  static const Duration timeout = Duration(seconds: 10);

  /// Menormalisasi URL gambar lokal backend (/uploads/...) ke URL lengkap
  static String resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?auto=format&fit=crop&w=400&q=80';
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$baseHost$cleanPath';
  }

  static Map<String, String> _headers([Map<String, String>? extra]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = authToken;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    if (extra != null) {
      headers.addAll(extra);
    }
    return headers;
  }

  static Future<http.Response> _executeWithFallback(
    Future<http.Response> Function(String host) requestFn,
  ) async {
    Object? lastError;
    final startIndex = _activeHostIndex;

    for (int i = 0; i < candidateHosts.length; i++) {
      final index = (startIndex + i) % candidateHosts.length;
      final host = candidateHosts[index];
      try {
        final response = await requestFn(host).timeout(timeout);
        _activeHostIndex = index;
        return response;
      } on SocketException catch (e) {
        lastError = e;
        debugPrint('[ApiClient] Host $host unreachable via socket, trying fallback...');
      } on http.ClientException catch (e) {
        lastError = e;
        debugPrint('[ApiClient] Host $host client error: $e, trying fallback...');
      } on TimeoutException catch (e) {
        lastError = e;
        debugPrint('[ApiClient] Host $host timed out, trying fallback...');
      } catch (e) {
        // If it's another non-network error (e.g. format), don't loop endlessly
        rethrow;
      }
    }

    throw Exception(
      'Tidak dapat terhubung ke server backend (${lastError ?? "koneksi gagal"}). Pastikan backend berjalan dan HP terhubung via kabel (adb reverse) atau satu jaringan Wi-Fi.',
    );
  }

  static Future<Map<String, dynamic>> get(String path) async {
    final response = await _executeWithFallback((host) {
      final url = Uri.parse('$host/api$path');
      return http.get(url, headers: _headers());
    });
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> post(String path, dynamic body) async {
    final response = await _executeWithFallback((host) {
      final url = Uri.parse('$host/api$path');
      return http.post(
        url,
        headers: _headers(),
        body: jsonEncode(body),
      );
    });
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> put(String path, dynamic body) async {
    final response = await _executeWithFallback((host) {
      final url = Uri.parse('$host/api$path');
      return http.put(
        url,
        headers: _headers(),
        body: jsonEncode(body),
      );
    });
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> patch(String path, [dynamic body]) async {
    final response = await _executeWithFallback((host) {
      final url = Uri.parse('$host/api$path');
      return http.patch(
        url,
        headers: _headers(),
        body: body != null ? jsonEncode(body) : null,
      );
    });
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> delete(String path) async {
    final response = await _executeWithFallback((host) {
      final url = Uri.parse('$host/api$path');
      return http.delete(url, headers: _headers());
    });
    return _processResponse(response);
  }

  static Map<String, dynamic> _processResponse(http.Response response) {
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = {'message': response.body};
    }

    if (response.statusCode == 401) {
      debugPrint('[ApiClient] 401 Unauthorized detected. Clearing cached session.');
      _authToken = null;
      LocalStorage.clearAuth();
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'success': true, 'data': decoded};
    }

    final message = decoded is Map<String, dynamic>
        ? (decoded['message'] ?? decoded['error'] ?? 'Terjadi kesalahan')
        : 'HTTP Error ${response.statusCode}';
    final data = decoded is Map<String, dynamic> ? decoded['data'] : null;
    throw ApiException(
      statusCode: response.statusCode,
      message: message.toString(),
      data: data,
      rawResponse: decoded is Map<String, dynamic> ? decoded : null,
    );
  }
}

/// Exception terstruktur dari REST API DinoyoCraft
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic data;
  final Map<String, dynamic>? rawResponse;

  ApiException({
    required this.statusCode,
    required this.message,
    this.data,
    this.rawResponse,
  });

  /// Mengecek apakah error disebabkan akun Google belum terdaftar
  bool get isNotRegistered =>
      statusCode == 404 &&
      (rawResponse?['is_registered'] == false ||
          message.toLowerCase().contains('belum terdaftar'));

  @override
  String toString() => message;
}
