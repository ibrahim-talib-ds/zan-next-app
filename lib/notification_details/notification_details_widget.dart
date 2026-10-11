import '/auth/firebase_auth/auth_util.dart';
import '/services/api_client.dart' as zannext_api;
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';

import 'notification_details_model.dart';
export 'notification_details_model.dart';

/// Notification details — Postgres version.
/// Shows the latest message-type and order-type notification,
/// plus a compact list. Replaces the old Firestore boilerplate.
class NotificationDetailsWidget extends StatefulWidget {
  const NotificationDetailsWidget({super.key});

  static String routeName = 'notification_details';
  static String routePath = '/notificationDetails';

  @override
  State<NotificationDetailsWidget> createState() =>
      _NotificationDetailsWidgetState();
}

class _NotificationDetailsWidgetState extends State<NotificationDetailsWidget> {
  late NotificationDetailsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);

  List<Map<String, dynamic>> _all = const [];
  bool _loading = true;

  Map<String, dynamic> _asMap(dynamic d) => Map<String, dynamic>.from(d as Map);
  String _s(Map m, List<String> keys, [String fb = '']) {
    for (final k in keys) {
      final v = m[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return fb;
  }
  bool _b(Map m, List<String> keys) {
    for (final k in keys) {
      final v = m[k];
      if (v != null) return v == true || v.toString() == 'true';
    }
    return false;
  }
  DateTime? _d(Map m, List<String> keys) {
    for (final k in keys) {
      final p = DateTime.tryParse((m[k] ?? '').toString());
      if (p != null) return p;
    }
    return null;
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF121212) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationDetailsModel());
    _load();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (currentUserUid.isEmpty) {
      if (mounted) safeSetState(() => _loading = false);
      return;
    }
    try {
      dynamic raw;
      try {
        raw = await zannext_api.ApiClient.get('/notifications?user_id=$currentUserUid');
      } catch (_) {
        raw = await zannext_api.ApiClient.get('/notifications');
      }
      final list = (raw as List).map(_asMap).toList();
      list.sort((a, b) {
        final at = _d(a, ['created_at', 'date']) ?? DateTime(1970);
        final bt = _d(b, ['created_at', 'date']) ?? DateTime(1970);
        return bt.compareTo(at);
      });
      _all = list;
    } catch (_) {}
    if (mounted) safeSetState(() => _loading = false);
  }

  Map<String, dynamic>? _latest(List<String> keywords) {
    for (final n in _all) {
      final hay = (_s(n, ['title']) + ' ' + _s(n, ['body', 'notification_text'])).toLowerCase();
      if (keywords.any(hay.contains)) return n;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _bg,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _loading
                    ? const Center(
                        child: SizedBox(
                          width: 40, height: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                            strokeWidth: 3),
                        ),
                      )
                    : _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(0, topPad + 8, 0, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreen, Color(0xFF0A3A22)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 12, 0),
        child: Row(
          children: [
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 24,
              borderWidth: 1,
              buttonSize: 44,
              fillColor: Colors.white.withOpacity(0.18),
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
              onPressed: () => context.safePop(),
            ),
            const SizedBox(width: 6),
            const Expanded(
              child: Text('Notifications',
                  style: TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            TextButton(
              onPressed: () => context.pushNamed(NotificationWidget.routeName),
              child: const Text('See all',
                  style: TextStyle(
                      color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_all.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                    color: kGreen.withOpacity(0.12), shape: BoxShape.circle),
                child: const Icon(Icons.notifications_off_outlined,
                    color: kGreen, size: 38),
              ),
              const SizedBox(height: 16),
              Text('No notifications yet',
                  style: TextStyle(
                      color: _text, fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      );
    }

    final msg = _latest(['message', 'chat', 'replied']);
    final order = _latest(['order', 'ship', 'deliver']);
    final rest = _all
        .where((n) => !(identical(n, msg) || identical(n, order)))
        .take(20)
        .toList();

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
      children: [
        if (msg != null) _featureCard(msg, Icons.chat_bubble_rounded,
            const Color(0xFF2563EB), () => context.pushNamed(MessagelistWidget.routeName)),
        if (order != null) ...[
          const SizedBox(height: 10),
          _featureCard(order, Icons.local_shipping_rounded,
              const Color(0xFF1B7A4E), () => context.pushNamed(OrderDetailsWidget.routeName)),
        ],
        const SizedBox(height: 18),
        Text('Earlier',
            style: TextStyle(
                color: _text, fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ...rest.map((n) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _simpleTile(n),
            )),
      ],
    );
  }

  Widget _featureCard(Map<String, dynamic> n, IconData icon, Color color,
      VoidCallback onTap) {
    final title = _s(n, ['title'], 'Notification');
    final body = _s(n, ['body', 'notification_text']);
    final when = _d(n, ['created_at', 'date']);
    final unread = !_b(n, ['is_read', 'isRead']);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: unread ? color.withOpacity(0.4) : _border,
              width: unread ? 1.4 : 1),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: _text,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  if (body.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _muted, fontSize: 12)),
                  ],
                ],
              ),
            ),
            if (when != null)
              Text(_timeAgo(when),
                  style: TextStyle(color: _muted, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _simpleTile(Map<String, dynamic> n) {
    final title = _s(n, ['title'], 'Notification');
    final when = _d(n, ['created_at', 'date']);
    final unread = !_b(n, ['is_read', 'isRead']);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.pushNamed(NotificationWidget.routeName),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            if (unread)
              Container(
                width: 8, height: 8,
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                    color: kGreen, shape: BoxShape.circle),
              ),
            Expanded(
              child: Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: _text,
                      fontSize: 13.5,
                      fontWeight:
                          unread ? FontWeight.w700 : FontWeight.w500)),
            ),
            Text(_timeAgo(when),
                style: TextStyle(color: _muted, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime? when) {
    if (when == null) return '';
    final d = DateTime.now().difference(when);
    if (d.inSeconds < 60) return 'now';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    if (d.inDays < 7) return '${d.inDays}d';
    return '${when.day}/${when.month}';
  }
}
