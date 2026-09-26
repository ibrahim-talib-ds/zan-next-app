import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
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
  OverlayEntry? _currentBanner;

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
      debugPrint('🔔 Cold start from push: ${initial.data}');
      // Give the app time to fully render, then retry navigation
      Future.delayed(const Duration(milliseconds: 1500), () {
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

  // ═══════════════════════════════════════════════════════════
  // FOREGROUND MESSAGE — WhatsApp-style top banner
  // ═══════════════════════════════════════════════════════════
  void _foregroundMessage(RemoteMessage msg) {
    final n = msg.notification;
    if (n == null) return;
    final ctx = appNavigatorKey.currentContext;
    if (ctx == null) return;

    final overlay = Overlay.maybeOf(ctx);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (context) => _TopBanner(
        title: n.title ?? 'Notification',
        body: n.body ?? '',
        onTap: () {
          _removeBanner();
          _handleTap(msg);
        },
      ),
    );
    _currentBanner = entry;
    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 4), () {
      _removeBanner();
    });
  }

  void _removeBanner() {
    try {
      _currentBanner?.remove();
    } catch (_) {}
    _currentBanner = null;
  }

  // ═══════════════════════════════════════════════════════════
  // TAP HANDLER — routes to correct screen
  // ═══════════════════════════════════════════════════════════
  /// Queue for cold-start navigation.
  static RemoteMessage? _pendingMsg;

  /// Called from main.dart after the app is fully ready.
  static void flushPending() {
    final msg = _pendingMsg;
    _pendingMsg = null;
    if (msg != null) {
      PushService.instance._navigate(msg);
    }
  }

  void _handleTap(RemoteMessage msg) {
    debugPrint('🔔 Tap received: ${msg.data}');

    // Try up to 10 times, waiting for context to be ready
    _tryNavigate(msg, attempt: 0);
  }

  void _tryNavigate(RemoteMessage msg, {required int attempt}) {
    final ctx = appNavigatorKey.currentContext;

    // Context not ready → wait and retry (cold start)
    if (ctx == null) {
      if (attempt >= 10) {
        debugPrint('🔔 Nav gave up after 10 attempts');
        return;
      }
      Future.delayed(const Duration(milliseconds: 300), () {
        _tryNavigate(msg, attempt: attempt + 1);
      });
      return;
    }

    _navigate(msg);
  }

  void _navigate(RemoteMessage msg) {
    final data = msg.data;
    final route = data['route'] as String?;
    final chatId = data['chatId'] as String?;

    // Get fresh context right now
    final ctx = appNavigatorKey.currentContext;
    if (ctx == null) {
      debugPrint('🔔 _navigate: context still null');
      return;
    }

    debugPrint('🔔 Navigating: route=$route chatId=$chatId');

    try {
      // ── CHAT ──────────────────────────────────────────────
      if (route == 'ChatD' && chatId != null && chatId.isNotEmpty) {
        final chatRef =
            FirebaseFirestore.instance.collection('Chats').doc(chatId);
        GoRouter.of(ctx).pushNamed(
          ChatDWidget.routeName,
          queryParameters: {
            'receiveChats':
                serializeParam(chatRef, ParamType.DocumentReference),
          }.withoutNulls,
        );
        return;
      }

      // ── ORDER ─────────────────────────────────────────────
      if (route == 'Order_details') {
        GoRouter.of(ctx).pushNamed(OrderDetailsWidget.routeName);
        return;
      }

      // ── Fallback ──────────────────────────────────────────
      if (route == null || route.isEmpty) {
        GoRouter.of(ctx).pushNamed(NotificationWidget.routeName);
      } else {
        try {
          GoRouter.of(ctx).pushNamed(route);
        } catch (_) {
          GoRouter.of(ctx).pushNamed(NotificationWidget.routeName);
        }
      }
    } catch (e) {
      debugPrint('🔔 Nav error: $e');
      try {
        GoRouter.of(ctx).pushNamed(NotificationWidget.routeName);
      } catch (_) {}
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// TOP BANNER — slides from top of screen (WhatsApp style)
// ═══════════════════════════════════════════════════════════════
class _TopBanner extends StatefulWidget {
  const _TopBanner({
    required this.title,
    required this.body,
    required this.onTap,
  });

  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  State<_TopBanner> createState() => _TopBannerState();
}

class _TopBannerState extends State<_TopBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              margin: EdgeInsetsDirectional.fromSTEB(12, top + 8, 12, 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1B7A4E),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (widget.body.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white70,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
