import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '/repositories/user_repository.dart';
import '/models/user.dart';

/// Sends push notifications via our Cloudflare Worker.
/// The Worker relays to Firebase Cloud Messaging.
class NotificationSender {
  /// Extracts a user id from various input shapes:
  /// - String  → itself
  /// - any object with an `.id` getter (including our `_UidRef` shim) → its id
  /// - null    → null
  static String? _extractId(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    try {
      final id = (value as dynamic).id;
      if (id is String) return id;
    } catch (_) {}
    return null;
  }

  static const String _workerUrl =
      'https://zannext-notify.ibrahim-tech-projects.workers.dev';

  /// Send a notification to a specific user.
  ///
  /// Firebase-free: accepts either a String userId, or a `_UidRef`-style
  /// object (any object with an `.id` getter — including our auth_util
  /// shim). Anything else is treated as no-op.
  static Future<void> sendToUser({
    required dynamic userRef,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final String? userId = _extractId(userRef);
    if (userId == null || userId.isEmpty) return;

    try {
      // 1. Get the user's FCM token via API
      final User? user;
      try {
        user = await UserRepository.get(userId);
      } catch (_) {
        return;
      }

      final token = (user.fcmToken ?? '').trim();
      if (token.isEmpty) {
        debugPrint('🔔 No FCM token for user $userId');
        return;
      }

      // 2. Call the Worker
      final res = await http
          .post(
            Uri.parse(_workerUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'token': token,
              'title': title,
              'body': body,
              'data': (data ?? {}).map(
                (k, v) => MapEntry(k, v.toString()),
              ),
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        debugPrint('🔔 Notification sent: $title');
      } else {
        debugPrint('🔔 Notification failed: ${res.statusCode} ${res.body}');
      }
    } catch (e) {
      debugPrint('🔔 Notification error: $e');
    }
  }
}
