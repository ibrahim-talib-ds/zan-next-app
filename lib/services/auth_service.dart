// ZanNext Auth Service
//
// Wraps the API client for authentication operations.

import 'api_client.dart';

class AuthService {
  /// Sign up a new user. Returns { access_token, refresh_token, user }.
  static Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String displayName,
    String? phoneNumber,
  }) async {
    final result = await ApiClient.post(
      '/auth/signup',
      body: {
        'email': email,
        'password': password,
        'display_name': displayName,
        if (phoneNumber != null && phoneNumber.isNotEmpty) 'phone_number': phoneNumber,
      },
      withAuth: false,
    );
    final data = result as Map<String, dynamic>;
    await ApiClient.saveTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
    return data;
  }

  /// Login. Returns { access_token, refresh_token, user }.
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await ApiClient.post(
      '/auth/login',
      body: {'email': email, 'password': password},
      withAuth: false,
    );
    final data = result as Map<String, dynamic>;
    await ApiClient.saveTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
    return data;
  }

  /// Logout — revokes the refresh token on the server.
  static Future<void> logout() async {
    final refresh = await ApiClient.getRefreshToken();
    if (refresh != null) {
      try {
        await ApiClient.post(
          '/auth/logout',
          body: {'refresh_token': refresh},
          withAuth: false,
        );
      } catch (_) {
        // Ignore errors on logout
      }
    }
    await ApiClient.clearTokens();
  }

  /// Get the current user's profile.
  static Future<Map<String, dynamic>> me() async {
    final result = await ApiClient.get('/auth/me');
    return result as Map<String, dynamic>;
  }

  /// True if we have a stored access token.
  static Future<bool> isLoggedIn() async {
    final token = await ApiClient.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Trigger a password reset email.
  static Future<void> forgotPassword(String email) async {
    await ApiClient.post(
      '/auth/forgot-password',
      body: {'email': email},
      withAuth: false,
    );
  }

  /// Verify a reset token and return the user's email.
  static Future<String> verifyResetToken(String token) async {
    final res = await ApiClient.get(
      '/auth/verify-reset-token?token=${Uri.encodeComponent(token)}',
      withAuth: false,
    ) as Map;
    return (res['email'] ?? '').toString();
  }

  /// Complete a password reset with a token.
  static Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await ApiClient.post(
      '/auth/reset-password',
      body: {'token': token, 'new_password': newPassword},
      withAuth: false,
    );
  }
}
