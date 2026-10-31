import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // Untuk Android emulator: gunakan 10.0.2.2.
  // Untuk iOS simulator atau desktop: gunakan localhost atau 127.0.0.1.
  // Untuk real device: ganti dengan IP LAN komputer kamu (contoh: 192.168.1.10).
  static String baseUrl = 'http://10.0.2.2:5000/api';

  static String? authToken;

  static Map<String, String> _headers([Map<String, String>? extra]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authToken != null && authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    if (extra != null) {
      headers.addAll(extra);
    }
    return headers;
  }

  static Future<Map<String, dynamic>> get(String path) async {
    final url = Uri.parse('$baseUrl$path');
    final response = await http.get(url, headers: _headers());
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> post(String path, dynamic body) async {
    final url = Uri.parse('$baseUrl$path');
    final response = await http.post(
      url,
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  static Map<String, dynamic> _processResponse(http.Response response) {
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = {'message': response.body};
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
    throw Exception(message);
  }
}
