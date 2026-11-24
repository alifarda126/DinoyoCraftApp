import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../storage/local_storage.dart';
import '../services/mobile_log_reporter.dart';
import 'server_status.dart';

class ApiClient {
  /// URL backend production yang disuntik saat build release:
  /// `flutter build apk --release --dart-define=API_BASE_URL=https://api.domain.com`
  /// Kosong saat development lokal (otomatis memakai discovery LAN / adb reverse).
  static const String configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get _normalizedConfiguredHost {
    final raw = configuredBaseUrl.trim();
    if (raw.isEmpty) return '';
    return raw
        .replaceAll(RegExp(r'/api/?$', caseSensitive: false), '')
        .replaceAll(RegExp(r'/+$'), '');
  }

  static bool get hasProductionBaseUrl => _normalizedConfiguredHost.isNotEmpty;

  static final List<String> candidateHosts = [
    if (configuredBaseUrl.trim().isNotEmpty)
      configuredBaseUrl
          .trim()
          .replaceAll(RegExp(r'/api/?$', caseSensitive: false), '')
          .replaceAll(RegExp(r'/+$'), ''),
    'http://127.0.0.1:5000',
    'http://192.168.1.6:5000',
    'http://10.35.96.186:5000',
    'http://192.168.17.168:5000',
    'http://192.168.1.3:5000',
    'http://192.168.1.2:5000',
    'http://192.168.110.161:5000',
    'http://10.0.2.2:5000',
  ];

  static int _activeHostIndex = 0;
  static bool _hasVerifiedHost = false;
  static Future<String?>? _ongoingDiscovery;
  static http.Client _httpClient = http.Client();

  static final ValueNotifier<String> baseHostNotifier = ValueNotifier<String>(
    candidateHosts.first,
  );

  static String get baseHost => candidateHosts[_activeHostIndex];
  static String get baseUrl => '$baseHost/api';

  @visibleForTesting
  static set testHttpClient(http.Client? client) {
    _httpClient = client ?? http.Client();
  }

  @visibleForTesting
  static void resetForTesting({int activeHostIndex = 0}) {
    _activeHostIndex =
        activeHostIndex.clamp(0, candidateHosts.length - 1);
    _hasVerifiedHost = false;
    _ongoingDiscovery = null;
    baseHostNotifier.value = candidateHosts[_activeHostIndex];
    _httpClient = http.Client();
  }

  static String? _authToken;

  static String? get authToken => _authToken ?? LocalStorage.getToken();
  static set authToken(String? token) => _authToken = token;

  static const Duration timeout = Duration(seconds: 10);

  static String _normalizeHost(String host) =>
      host.trim().replaceAll(RegExp(r'/+$'), '');

  static int _registerHost(String rawHost) {
    final normalized = _normalizeHost(rawHost);
    if (normalized.isEmpty) return _activeHostIndex;
    final existingIdx = candidateHosts.indexOf(normalized);
    if (existingIdx >= 0) return existingIdx;
    candidateHosts.add(normalized);
    return candidateHosts.length - 1;
  }

  static void _setActiveHost(String rawHost, {bool persist = true}) {
    final normalized = _normalizeHost(rawHost);
    if (normalized.isEmpty) return;
    _activeHostIndex = _registerHost(normalized);
    _hasVerifiedHost = true;
    if (baseHostNotifier.value != normalized) {
      baseHostNotifier.value = normalized;
    }
    if (persist) {
      unawaited(LocalStorage.saveLastBaseHost(normalized));
    }
  }

  /// Muat host terakhir yang berhasil dari penyimpanan lokal lalu mulai
  /// discovery paralel di latar belakang agar perangkat langsung tersambung.
  static Future<void> init({bool autoDiscover = true}) async {
    if (hasProductionBaseUrl) {
      final prodHost = _normalizedConfiguredHost;
      final idx = _registerHost(prodHost);
      _activeHostIndex = idx;
      baseHostNotifier.value = candidateHosts[idx];
      if (autoDiscover) {
        unawaited(discoverActiveHost(scanSubnetFallback: false));
      }
      return;
    }

    final savedHost = LocalStorage.getLastBaseHost();
    if (savedHost != null &&
        (savedHost.startsWith('http://') || savedHost.startsWith('https://'))) {
      final idx = _registerHost(savedHost);
      _activeHostIndex = idx;
      baseHostNotifier.value = candidateHosts[idx];
    }
    if (autoDiscover) {
      unawaited(discoverActiveHost());
    }
  }

  /// Menormalisasi URL gambar lokal backend (/uploads/...) ke URL lengkap
  static String resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?auto=format&fit=crop&w=400&q=80';
    }
    final localBackendMatch =
        RegExp(r'^https?://[^/]+:5000(/.*)$').firstMatch(path);
    if (localBackendMatch != null) {
      return '$baseHost${localBackendMatch.group(1)}';
    }
    for (final localOrigin in const [
      'http://localhost:5000',
      'http://127.0.0.1:5000',
    ]) {
      if (path.startsWith('$localOrigin/')) {
        return '$baseHost${path.substring(localOrigin.length)}';
      }
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

  static Future<bool> _probeHostHealth(String host, Duration probeTimeout) async {
    try {
      final url = Uri.parse('$host/api/health');
      final resp = await _httpClient
          .get(url, headers: const {'Accept': 'application/json'})
          .timeout(probeTimeout);
      if (resp.statusCode != 200) return false;
      final decoded = jsonDecode(resp.body);
      return decoded is Map && decoded['success'] == true;
    } catch (_) {
      return false;
    }
  }

  static Future<String?> _raceHosts(
    List<String> hosts,
    Duration probeTimeout,
  ) async {
    if (hosts.isEmpty) return null;
    final completer = Completer<String?>();
    var remaining = hosts.length;

    for (final rawHost in hosts) {
      final host = _normalizeHost(rawHost);
      _probeHostHealth(host, probeTimeout).then((ok) {
        if (ok && !completer.isCompleted) {
          completer.complete(host);
          return;
        }
        remaining--;
        if (remaining == 0 && !completer.isCompleted) {
          completer.complete(null);
        }
      });
    }

    return completer.future;
  }

  static bool _isPrivateIpv4(String ip) {
    if (ip.startsWith('192.168.') || ip.startsWith('10.')) return true;
    if (ip.startsWith('172.')) {
      final parts = ip.split('.');
      if (parts.length == 4) {
        final second = int.tryParse(parts[1]) ?? -1;
        return second >= 16 && second <= 31;
      }
    }
    return false;
  }

  static Future<String?> _discoverFromLocalSubnet() async {
    if (kIsWeb) return null;
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      final ownIps = <String>{};
      final prefixes = <String>[];
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          final ip = addr.address;
          ownIps.add(ip);
          if (_isPrivateIpv4(ip)) {
            final parts = ip.split('.');
            if (parts.length == 4) {
              final prefix = '${parts[0]}.${parts[1]}.${parts[2]}';
              if (!prefixes.contains(prefix)) {
                prefixes.add(prefix);
              }
            }
          }
        }
      }
      if (prefixes.isEmpty) return null;

      final alreadyTried = candidateHosts.map(_normalizeHost).toSet();
      final subnetCandidates = <String>[];
      for (final prefix in prefixes) {
        for (int octet = 1; octet <= 254; octet++) {
          final ip = '$prefix.$octet';
          if (ownIps.contains(ip)) continue;
          final host = 'http://$ip:5000';
          if (!alreadyTried.contains(host)) {
            subnetCandidates.add(host);
          }
        }
      }

      const batchSize = 32;
      for (int i = 0; i < subnetCandidates.length; i += batchSize) {
        final end = (i + batchSize < subnetCandidates.length)
            ? i + batchSize
            : subnetCandidates.length;
        final batch = subnetCandidates.sublist(i, end);
        final winner = await _raceHosts(batch, const Duration(milliseconds: 450));
        if (winner != null) {
          return winner;
        }
      }
    } catch (e) {
      debugPrint('[ApiClient] Subnet auto-discovery error: $e');
    }
    return null;
  }

  /// Cari host backend aktif secara paralel (race seluruh candidateHosts)
  /// dan fallback ke pemindaian subnet Wi-Fi /24 bila DHCP berubah.
  static Future<String?> discoverActiveHost({
    bool force = false,
    bool scanSubnetFallback = true,
  }) {
    if (!force && _hasVerifiedHost && ServerStatus.isReachable) {
      return Future.value(baseHost);
    }
    if (_ongoingDiscovery != null) {
      return _ongoingDiscovery!;
    }

    final future = () async {
      try {
        if (hasProductionBaseUrl) {
          final prodHost = _normalizedConfiguredHost;
          final ok = await _probeHostHealth(
            prodHost,
            const Duration(seconds: 5),
          );
          if (ok) {
            _setActiveHost(prodHost, persist: false);
            ServerStatus.markUp();
            return prodHost;
          }
          return null;
        }

        final previousHost = baseHost;
        final orderedCandidates = <String>[];
        final seen = <String>{};
        final saved = LocalStorage.getLastBaseHost();
        if (saved != null && saved.isNotEmpty) {
          final norm = _normalizeHost(saved);
          if (seen.add(norm)) orderedCandidates.add(norm);
        }
        for (final c in candidateHosts) {
          final norm = _normalizeHost(c);
          if (seen.add(norm)) orderedCandidates.add(norm);
        }

        String? winner = await _raceHosts(
          orderedCandidates,
          const Duration(milliseconds: 1800),
        );

        if (winner == null && scanSubnetFallback) {
          winner = await _discoverFromLocalSubnet();
        }

        if (winner != null) {
          if (winner != previousHost) {
            debugPrint('[ApiClient] Tersambung otomatis ke backend: $winner');
            MobileLogReporter.reportEvent(
              category: 'mobile',
              eventName: 'mobile.network.host_fallback',
              severity: 'info',
              message:
                  'Aplikasi Mobile tersambung otomatis dari $previousHost ke $winner',
              metadata: {
                'failedHost': previousHost,
                'activeHost': winner,
              },
            );
          }
          _setActiveHost(winner);
          ServerStatus.markUp();
          return winner;
        }
        return null;
      } finally {
        _ongoingDiscovery = null;
      }
    }();

    _ongoingDiscovery = future;
    return future;
  }

  static Future<http.Response> _executeWithFallback(
    Future<http.Response> Function(String host) requestFn, {
    Duration? requestTimeout,
  }) async {
    if (!_hasVerifiedHost && _ongoingDiscovery != null) {
      await _ongoingDiscovery;
    }

    Object? lastError;
    final currentHost = baseHost;
    final firstTimeout =
        _hasVerifiedHost ? (requestTimeout ?? timeout) : const Duration(seconds: 3);

    try {
      final response = await requestFn(currentHost).timeout(firstTimeout);
      _hasVerifiedHost = true;
      ServerStatus.markUp();
      return response;
    } on SocketException catch (e) {
      lastError = e;
      debugPrint('[ApiClient] Host $currentHost unreachable via socket: $e');
    } on http.ClientException catch (e) {
      lastError = e;
      debugPrint('[ApiClient] Host $currentHost client error: $e');
    } on TimeoutException catch (e) {
      lastError = e;
      debugPrint('[ApiClient] Host $currentHost timed out');
    } catch (e) {
      rethrow;
    }

    _hasVerifiedHost = false;
    final discovered = await discoverActiveHost(force: true);
    if (discovered != null) {
      try {
        final response = await requestFn(discovered)
            .timeout(requestTimeout ?? timeout);
        _hasVerifiedHost = true;
        ServerStatus.markUp();
        return response;
      } on SocketException catch (e) {
        lastError = e;
      } on http.ClientException catch (e) {
        lastError = e;
      } on TimeoutException catch (e) {
        lastError = e;
      }
    }

    ServerStatus.markDown();
    throw Exception(
      'Tidak dapat terhubung ke server backend ($lastError). Pastikan backend berjalan dan HP terhubung via kabel (adb reverse) atau satu jaringan Wi-Fi.',
    );
  }

  static Future<Map<String, dynamic>> get(String path) async {
    final response = await _executeWithFallback((host) {
      final url = Uri.parse('$host/api$path');
      return _httpClient.get(url, headers: _headers());
    });
    return _handleResponseWithRefresh(
      response,
      path,
      () => _executeWithFallback((host) {
        final url = Uri.parse('$host/api$path');
        return _httpClient.get(url, headers: _headers());
      }),
    );
  }

  static Future<Map<String, dynamic>> post(String path, dynamic body) async {
    final Duration? customTimeout =
        path.startsWith('/ai/') ? const Duration(seconds: 22) : null;
    final response = await _executeWithFallback(
      (host) {
        final url = Uri.parse('$host/api$path');
        return _httpClient.post(
          url,
          headers: _headers(),
          body: jsonEncode(body),
        );
      },
      requestTimeout: customTimeout,
    );
    return _handleResponseWithRefresh(
      response,
      path,
      () => _executeWithFallback(
        (host) {
          final url = Uri.parse('$host/api$path');
          return _httpClient.post(
            url,
            headers: _headers(),
            body: jsonEncode(body),
          );
        },
        requestTimeout: customTimeout,
      ),
    );
  }

  static Future<Map<String, dynamic>> put(String path, dynamic body) async {
    final response = await _executeWithFallback((host) {
      final url = Uri.parse('$host/api$path');
      return _httpClient.put(
        url,
        headers: _headers(),
        body: jsonEncode(body),
      );
    });
    return _handleResponseWithRefresh(
      response,
      path,
      () => _executeWithFallback((host) {
        final url = Uri.parse('$host/api$path');
        return _httpClient.put(
          url,
          headers: _headers(),
          body: jsonEncode(body),
        );
      }),
    );
  }

  static Future<Map<String, dynamic>> patch(String path, [dynamic body]) async {
    final response = await _executeWithFallback((host) {
      final url = Uri.parse('$host/api$path');
      return _httpClient.patch(
        url,
        headers: _headers(),
        body: body != null ? jsonEncode(body) : null,
      );
    });
    return _handleResponseWithRefresh(
      response,
      path,
      () => _executeWithFallback((host) {
        final url = Uri.parse('$host/api$path');
        return _httpClient.patch(
          url,
          headers: _headers(),
          body: body != null ? jsonEncode(body) : null,
        );
      }),
    );
  }

  static Future<Map<String, dynamic>> delete(String path) async {
    final response = await _executeWithFallback((host) {
      final url = Uri.parse('$host/api$path');
      return _httpClient.delete(url, headers: _headers());
    });
    return _handleResponseWithRefresh(
      response,
      path,
      () => _executeWithFallback((host) {
        final url = Uri.parse('$host/api$path');
        return _httpClient.delete(url, headers: _headers());
      }),
    );
  }

  /// Mengirim request multipart/form-data (misal: upload foto chat, avatar, dokumen mitra)
  static Future<Map<String, dynamic>> postMultipart(
    String path, {
    Map<String, String>? fields,
    String? fileField,
    String? filePath,
    List<http.MultipartFile>? extraFiles,
  }) async {
    Future<http.Response> makeRequest(String host) async {
      final url = Uri.parse('$host/api$path');
      final request = http.MultipartRequest('POST', url);
      final token = authToken;
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';
      if (fields != null) {
        request.fields.addAll(fields);
      }
      if (fileField != null && filePath != null && filePath.isNotEmpty) {
        final file = File(filePath);
        if (await file.exists()) {
          request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
        }
      }
      if (extraFiles != null) {
        request.files.addAll(extraFiles);
      }
      final streamed = await _httpClient.send(request);
      return http.Response.fromStream(streamed);
    }

    final response = await _executeWithFallback(makeRequest);
    return _handleResponseWithRefresh(
      response,
      path,
      () => _executeWithFallback(makeRequest),
    );
  }

  /// Mengirim request PUT multipart/form-data (misal: update foto profil avatar di PUT /auth/profile)
  static Future<Map<String, dynamic>> putMultipart(
    String path, {
    Map<String, String>? fields,
    String? fileField,
    String? filePath,
    List<http.MultipartFile>? extraFiles,
  }) async {
    Future<http.Response> makeRequest(String host) async {
      final url = Uri.parse('$host/api$path');
      final request = http.MultipartRequest('PUT', url);
      final token = authToken;
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';
      if (fields != null) {
        request.fields.addAll(fields);
      }
      if (fileField != null && filePath != null && filePath.isNotEmpty) {
        final file = File(filePath);
        if (await file.exists()) {
          request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
        }
      }
      if (extraFiles != null) {
        request.files.addAll(extraFiles);
      }
      final streamed = await _httpClient.send(request);
      return http.Response.fromStream(streamed);
    }

    final response = await _executeWithFallback(makeRequest);
    return _handleResponseWithRefresh(
      response,
      path,
      () => _executeWithFallback(makeRequest),
    );
  }

  /// Jika response 401 dan path bukan endpoint auth, coba refresh token
  /// lalu ulangi request sekali. Gagal refresh → session dibersihkan.
  static Future<Map<String, dynamic>> _handleResponseWithRefresh(
    http.Response response,
    String path,
    Future<http.Response> Function() retry,
  ) async {
    if (response.statusCode == 401 &&
        !_isAuthPath(path) &&
        LocalStorage.getRefreshToken() != null) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        return _processResponse(await retry());
      }
    }
    return _processResponse(response);
  }

  /// Endpoint auth tidak di-refresh (kredensial salah bukan token kadaluarsa;
  /// juga mencegah loop refresh tanpa akhir).
  static bool _isAuthPath(String path) {
    return path.startsWith('/auth/login') ||
        path.startsWith('/auth/refresh') ||
        path.startsWith('/auth/register') ||
        path.startsWith('/auth/verify') ||
        path.startsWith('/auth/resend') ||
        path.startsWith('/auth/google') ||
        path.startsWith('/auth/forgot') ||
        path.startsWith('/auth/reset') ||
        path.startsWith('/auth/check-username') ||
        path.startsWith('/auth/fcm-token');
  }

  /// Panggil POST /auth/refresh untuk mendapat access token baru.
  /// Berhasil → token disimpan & true. Gagal → session dibersihkan & false.
  static bool _refreshing = false;

  static Future<bool> _tryRefreshToken() async {
    final refreshToken = LocalStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty || _refreshing) {
      return false;
    }
    _refreshing = true;
    try {
      final resp = await _executeWithFallback((host) {
        final url = Uri.parse('$host/api/auth/refresh');
        return _httpClient.post(
          url,
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({'refresh_token': refreshToken}),
        );
      });

      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);
        if (decoded is Map<String, dynamic> && decoded['success'] == true) {
          final data = decoded['data'];
          if (data is Map<String, dynamic>) {
            final newToken = data['token'] as String?;
            if (newToken != null && newToken.isNotEmpty) {
              _authToken = newToken;
              await LocalStorage.saveAuth(
                token: newToken,
                refreshToken: data['refresh_token'] as String?,
                user: data,
              );
              return true;
            }
          }
        }
      }
      // Refresh token ditolak → sesi tidak lagi valid.
      await LocalStorage.clearAuth();
      return false;
    } catch (e) {
      debugPrint('[ApiClient] Refresh token gagal: $e');
      return false;
    } finally {
      _refreshing = false;
    }
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
    final requestId = response.headers['x-request-id'];

    if (response.statusCode >= 500) {
      MobileLogReporter.reportEvent(
        category: 'mobile',
        eventName: 'mobile.api.server_error',
        severity: 'error',
        message: 'Mobile menerima HTTP ${response.statusCode}: $message',
        statusCode: response.statusCode,
        requestId: requestId,
      );
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: message.toString(),
      data: data,
      requestId: requestId,
      rawResponse: decoded is Map<String, dynamic> ? decoded : null,
    );
  }
}

/// Exception terstruktur dari REST API DinoyoCraft
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic data;
  final String? requestId;
  final Map<String, dynamic>? rawResponse;

  ApiException({
    required this.statusCode,
    required this.message,
    this.data,
    this.requestId,
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
