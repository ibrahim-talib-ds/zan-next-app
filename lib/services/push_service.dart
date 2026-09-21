import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/nav/nav.dart';
import '/index.dart';

/// ─── Background handler (top-level, required by FCM) ───────────
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 Background push: ${message.messageId}');
}

class PushService {
  PushService._();
  static final PushService instance = PushService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    }

    // 1. Request permission (iOS + web + Android 13+).
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('🔔 Permission: ${settings.authorizationStatus}');
    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    // 2. Fetch token + save to user doc.
    await _saveToken();

    // 3. Refresh token when FCM rotates it.
    _fcm.onTokenRefresh.listen(_updateUserToken);

    // 4. Foreground message → in-app banner.
    FirebaseMessaging.onMessage.listen(_foregroundMessage);

    // 5. Tap when app is in background.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);

    // 6. Cold start: app launched from a push.
    final initial = await _fcm.getInitialMessage();
    if (initial != null) {
      Future.delayed(const Duration(milliseconds: 900), () {
        _handleTap(initial);
      });
    }
  }

  Future<void> _saveToken() async {
    try {
      final token = await _fcm.getToken();
      if (token == null || token.isEmpty) return;
      debugPrint('🔔 FCM token: $token');
      await _updateUserToken(token);
    } catch (e) {
      debugPrint('🔔 Token error: $e');
    }
  }

  Future<void> _updateUserToken(String token) async {
    final user = currentUserReference;
    if (user == null) return;
    try {
      await user.update({'fcm_token': token});
    } catch (e) {
      debugPrint('🔔 Token save error: $e');
    }
  }

  void _foregroundMessage(RemoteMessage msg) {
    final n = msg.notification;
    if (n == null) return;
    final ctx = appNavigatorKey.currentContext;
    if (ctx == null) return;

    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (n.title != null)
                    Text(n.title!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  if (n.body != null)
                    Text(n.body!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        backgroundColor: const Color(0xFF1B7A4E),
        action: SnackBarAction(
          label: 'Open',
          textColor: Colors.white,
          onPressed: () => _handleTap(msg),
        ),
      ),
    );
  }

  void _handleTap(RemoteMessage msg) {
    final data = msg.data;
    debugPrint('🔔 Tap: $data');

    final route = data['route'] as String?;
    final ctx = appNavigatorKey.currentContext;
    if (ctx == null) return;

    try {
      if (route == null || route.isEmpty) {
        GoRouter.of(ctx).pushNamed(NotificationWidget.routeName);
      } else {
        GoRouter.of(ctx).pushNamed(route);
      }
    } catch (e) {
      debugPrint('🔔 Nav error: $e');
      try {
        GoRouter.of(ctx).pushNamed(NotificationWidget.routeName);
      } catch (_) {}
    }
  }
}
