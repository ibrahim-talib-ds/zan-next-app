// ZanNext — PushService (Postgres-backed, no Firebase).
//
// Polls /notifications for the current user every 30s while the app is
// foregrounded. New notifications:
//   1. Post as an OS notification via LocalNotifications.show()
//   2. Show an in-app WhatsApp-style banner via _TopBanner
//   3. Route on tap (chat / order / product / fallback)

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/repositories/notification_repository.dart';
import '/models/notification.dart';
import '/flutter_flow/nav/nav.dart';
import '/index.dart';
import '/services/local_notifications.dart';

class PushService with WidgetsBindingObserver {
  PushService._();
  static final PushService instance = PushService._();

  static const _pollInterval = Duration(seconds: 30);
  static const _lastSeenKey = 'zannext_last_seen_notif';

  Timer? _pollTimer;
  String? _lastSeenId;
  bool _initialized = false;
  OverlayEntry? _currentBanner;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addObserver(this);

    final prefs = await SharedPreferences.getInstance();
    _lastSeenId = prefs.getString(_lastSeenKey);

    _startPolling();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _pollOnce());
    // First check immediately (don't wait 30s)
    Future.delayed(const Duration(seconds: 3), _pollOnce);
  }

  Future<void> _pollOnce() async {
    final uid = currentUserUid;
    if (uid.isEmpty) return;

    try {
      final list = await NotificationRepository.listForUser(uid);
      if (list.isEmpty) return;

      // Newest first — API returns already sorted, but be defensive
      list.sort((a, b) {
        final at = a.createdAt?.millisecondsSinceEpoch ?? 0;
        final bt = b.createdAt?.millisecondsSinceEpoch ?? 0;
        return bt.compareTo(at);
      });

      final newest = list.first;

      // First ever run: seed with the newest id, don't spam banner
      if (_lastSeenId == null) {
        _lastSeenId = newest.id;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_lastSeenKey, newest.id);
        return;
      }

      // Nothing new since last poll
      if (newest.id == _lastSeenId) return;

      // Collect everything newer than lastSeenId
      final idx = list.indexWhere((n) => n.id == _lastSeenId);
      final fresh = idx < 0 ? <AppNotification>[newest] : list.sublist(0, idx);
      if (fresh.isEmpty) return;

      // Show banner for newest, OS notification for each
      for (final n in fresh.reversed) {
        LocalNotifications.show(
          title: n.title,
          body: n.body,
          payload: n.id,
        );
      }
      _showBanner(fresh.first);

      _lastSeenId = newest.id;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastSeenKey, newest.id);
    } catch (e) {
      debugPrint('🔔 Poll error: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _pollOnce();
      _pollTimer?.cancel();
      _pollTimer = Timer.periodic(_pollInterval, (_) => _pollOnce());
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _pollTimer?.cancel();
    }
  }

  void dispose() {
    _pollTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  /// Kept for compatibility with main.dart / login flows.
  Future<void> syncTokenToCurrentUser() async {}
  Future<void> clearTokenFromUser() async {}
  Future<bool> ensurePermission() async => true;

  // ═══════════════════════════════════════════════════════════
  // IN-APP BANNER
  // ═══════════════════════════════════════════════════════════
  void _showBanner(AppNotification n) {
    final ctx = appNavigatorKey.currentContext;
    if (ctx == null) return;
    final overlay = Overlay.maybeOf(ctx);
    if (overlay == null) return;

    _removeBanner();

    final entry = OverlayEntry(
      builder: (context) => _TopBanner(
        title: n.title,
        body: n.body,
        onTap: () {
          _removeBanner();
          _navigateFromNotification(n);
        },
      ),
    );
    _currentBanner = entry;
    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 4), _removeBanner);
  }

  void _removeBanner() {
    try {
      _currentBanner?.remove();
    } catch (_) {}
    _currentBanner = null;
  }

  // ═══════════════════════════════════════════════════════════
  // NAVIGATION
  // ═══════════════════════════════════════════════════════════
  static void flushPending() {} // legacy no-op

  void _navigateFromNotification(AppNotification n) {
    final ctx = appNavigatorKey.currentContext;
    if (ctx == null) return;

    try {
      final type = n.type;
      final productId = n.productId;

      if (type == 'order') {
        GoRouter.of(ctx).pushNamed(OrderDetailsWidget.routeName);
        return;
      }
      if (type == 'chat' || type == 'message') {
        GoRouter.of(ctx).pushNamed(ChatDWidget.routeName);
        return;
      }
      if ((type == 'product' || type == 'promo') && productId != null) {
        GoRouter.of(ctx).pushNamed(
          ProductDetailsWidget.routeName,
          queryParameters: {'id': productId},
        );
        return;
      }
      GoRouter.of(ctx).pushNamed(NotificationWidget.routeName);
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
