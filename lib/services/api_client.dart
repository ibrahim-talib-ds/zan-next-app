// ZanNext API Client
//
// Central HTTP client for the FastAPI backend.
// Handles:
//   - base URL configuration
//   - attaching the JWT access token
//   - auto-refreshing on 401
//   - JSON parsing

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  // ---- Configuration ----
  //
  // Local dev:    http://localhost:8000          (web, iOS simulator, Linux)
  // Android emu:  http://10.0.2.2:8000           (Android emulator to host)
  // Physical:     http://192.168.x.x:8000        (your LAN IP)
  // Production:   https://api.zannext.com        (later)
  static const String baseUrl = 'http://localhost:8000';

  static const _storage = FlutterSecureStorage();
  static const _kAccessToken = 'zannext_access_token';
  static const _kRefreshToken = 'zannext_refresh_token';

  // ---- Token storage ----

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _kAccessToken, value: accessToken);
    await _storage.write(key: _kRefreshToken, value: refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _kAccessToken);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _kRefreshToken);
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: _kAccessToken);
    await _storage.delete(key: _kRefreshToken);
  }

  // ---- Request helpers ----

  static Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (withAuth) {
      final token = await getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  /// Attempt to refresh the access token using the stored refresh token.
  static Future<bool> _tryRefresh() async {
    final refresh = await getRefreshToken();
    if (refresh == null || refresh.isEmpty) return false;

    try {
      final resp = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refresh}),
      );
      if (resp.statusCode != 200) return false;

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final newAccess = data['access_token'] as String?;
      final newRefresh = data['refresh_token'] as String?;
      if (newAccess == null || newRefresh == null) return false;

      await saveTokens(accessToken: newAccess, refreshToken: newRefresh);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    Future<http.Response> doRequest() async {
      final headers = await _headers(withAuth: withAuth);
      switch (method) {
        case 'GET':
          return http.get(uri, headers: headers);
        case 'POST':
          return http.post(uri, headers: headers, body: body == null ? null : jsonEncode(body));
        case 'PATCH':
          return http.patch(uri, headers: headers, body: body == null ? null : jsonEncode(body));
        case 'PUT':
          return http.put(uri, headers: headers, body: body == null ? null : jsonEncode(body));
        case 'DELETE':
          return http.delete(uri, headers: headers);
        default:
          throw ArgumentError('Unsupported method: $method');
      }
    }

    var resp = await doRequest();

    if (resp.statusCode == 401 && withAuth) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        resp = await doRequest();
      }
    }

    dynamic parsed;
    if (resp.body.isEmpty) {
      parsed = null;
    } else {
      try {
        parsed = jsonDecode(resp.body);
      } catch (_) {
        parsed = resp.body;
      }
    }

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return parsed;
    }

    final msg = (parsed is Map && parsed['detail'] is String)
        ? parsed['detail'] as String
        : 'HTTP ${resp.statusCode}';
    throw ApiException(resp.statusCode, msg);
  }

  // ---- Public API ----

  static Future<dynamic> get(String path, {bool withAuth = true}) =>
      _request('GET', path, withAuth: withAuth);

  static Future<dynamic> post(String path, {Map<String, dynamic>? body, bool withAuth = true}) =>
      _request('POST', path, body: body, withAuth: withAuth);

  static Future<dynamic> patch(String path, {Map<String, dynamic>? body, bool withAuth = true}) =>
      _request('PATCH', path, body: body, withAuth: withAuth);

  static Future<dynamic> delete(String path, {bool withAuth = true}) =>
      _request('DELETE', path, withAuth: withAuth);
}
