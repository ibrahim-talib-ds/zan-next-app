import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Sends push notifications via our Cloudflare Worker.
/// The Worker relays to Firebase Cloud Messaging.
class NotificationSender {
  static const String _workerUrl =
      'https://zannext-notify.ibrahim-tech-projects.workers.dev';

  /// Send a notification to a specific user (looked up by their ref).
  static Future<void> sendToUser({
    required DocumentReference? userRef,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    if (userRef == null) return;

    try {
      // 1. Get the user's FCM token
      final userDoc = await userRef.get();
      final data_map = userDoc.data() as Map<String, dynamic>?;
      if (data_map == null) return;

      final token = (data_map['fcm_token'] as String?)?.trim() ?? '';
      if (token.isEmpty) {
        debugPrint('🔔 No FCM token for user ${userRef.id}');
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
              'data': data ?? {},
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
