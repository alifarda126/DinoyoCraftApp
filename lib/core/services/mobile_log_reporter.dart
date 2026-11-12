import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../network/api_client.dart';

/// Reporter non-fatal aman untuk aplikasi Flutter (PRD §10.4).
/// Mengirim event terpilih (network fallback, API 5xx, Pusher/FCM init error,
/// referensi Crashlytics) ke POST /api/internal/logs/mobile dengan antrean offline
/// maksimum 100 event.
class MobileLogReporter {
  MobileLogReporter._();

  static const int _maxQueueSize = 100;
  static final List<Map<String, dynamic>> _offlineQueue = [];
  static bool _isFlushing = false;

  static final RegExp _sensitiveKeyRegex = RegExp(
    r'password|pass|otp|token|secret|authorization|cookie|full_address|ktp|nib',
    caseSensitive: false,
  );

  static Map<String, dynamic> _sanitizeMap(Map<String, dynamic>? input) {
    if (input == null) return {};
    final out = <String, dynamic>{};
    input.forEach((key, value) {
      if (_sensitiveKeyRegex.hasMatch(key)) {
        out[key] = '[REDACTED]';
      } else if (value is String) {
        out[key] = value.length > 250 ? value.substring(0, 250) : value;
      } else if (value is num || value is bool) {
        out[key] = value;
      }
    });
    return out;
  }

  /// Mencatat event telemetry mobile secara non-blocking
  static void reportEvent({
    String category = 'mobile',
    required String eventName,
    String severity = 'warning',
    required String message,
    String? route,
    String? method,
    int? statusCode,
    int? durationMs,
    String? requestId,
    String? crashlyticsRef,
    Map<String, dynamic>? metadata,
  }) {
    // Hindari loop tak terbatas bila request adalah ingest log itu sendiri
    if (route != null && route.contains('/internal/logs')) return;

    final payload = <String, dynamic>{
      'source': 'mobile',
      'service': 'mobile-flutter',
      'category': category,
      'eventName': eventName,
      'severity': severity,
      'message': message.length > 400 ? message.substring(0, 400) : message,
      'platform': Platform.isAndroid
          ? 'Android'
          : Platform.isIOS
          ? 'iOS'
          : Platform.operatingSystem,
      'appVersion': '1.0.0+1',
      if (requestId != null) 'requestId': requestId,
      if (crashlyticsRef != null) 'crashlyticsRef': crashlyticsRef,
      if (route != null)
        'http': {
          'method': method ?? 'GET',
          'route': route.split('?').first,
          'statusCode': statusCode ?? 0,
          'durationMs': durationMs ?? 0,
        },
      if (metadata != null) 'metadata': _sanitizeMap(metadata),
      'queuedAt': DateTime.now().toUtc().toIso8601String(),
    };

    if (_offlineQueue.length >= _maxQueueSize) {
      _offlineQueue.removeAt(0);
    }
    _offlineQueue.add(payload);

    unawaited(_flushQueue());
  }

  static Future<void> _flushQueue() async {
    if (_isFlushing || _offlineQueue.isEmpty) return;
    _isFlushing = true;

    try {
      final batch = List<Map<String, dynamic>>.from(_offlineQueue.take(20));
      final uri = Uri.parse('${ApiClient.baseHost}/api/internal/logs/mobile');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final token = ApiClient.authToken;
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final resp = await http
          .post(
            uri,
            headers: headers,
            body: jsonEncode({'events': batch}),
          )
          .timeout(const Duration(seconds: 5));

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        _offlineQueue.removeRange(
          0,
          batch.length.clamp(0, _offlineQueue.length),
        );
      }
    } catch (e) {
      debugPrint('[MobileLogReporter] Ditunda ke antrean offline (${_offlineQueue.length} item): $e');
    } finally {
      _isFlushing = false;
    }
  }
}

