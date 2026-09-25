import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'notification_view_model.dart';
export 'notification_view_model.dart';

/// Full notification detail page.
/// Shows the complete message, image, timestamp, and type.
class NotificationViewWidget extends StatefulWidget {
  const NotificationViewWidget({
    super.key,
    required this.notificationRef,
  });

  final DocumentReference? notificationRef;

  static String routeName = 'NotificationView';
  static String routePath = '/notificationView';

  @override
  State<NotificationViewWidget> createState() =>
      _NotificationViewWidgetState();
}

class _NotificationViewWidgetState extends State<NotificationViewWidget> {
  late NotificationViewModel _model;

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kBlue = Color(0xFF2563EB);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _soft   => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFF0F2F5);
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

  String _imgUrl(String? url) {
    final u = (url ?? '').trim();
    if (u.isEmpty) return '';
    return u.startsWith('http://') ? u.replaceFirst('http://', 'https://') : u;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationViewModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _header(),
            Expanded(
              child: widget.notificationRef == null
                  ? _empty('Notification not found')
                  : StreamBuilder<NotificationsRecord>(
                      stream:
                          NotificationsRecord.getDocument(widget.notificationRef!),
                      builder: (context, snap) {
                        if (snap.hasError) {
                          return _empty('Could not load notification');
                        }
                        if (!snap.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kGreen),
                            ),
                          );
                        }
                        final n = snap.data!;
                        // Mark as read
                        if (!n.isRead) {
                          n.reference
                              .update({'is_read': true}).catchError((_) {});
                        }
                        return _body(n);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _header() {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(8, topPad + 8, 16, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreen, kGreenDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          FlutterFlowIconButton(
            borderRadius: 24,
            buttonSize: 44,
            fillColor: Colors.white.withOpacity(0.18),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 22),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Full message',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // BODY
  // ═══════════════════════════════════════════════════════════
  Widget _body(NotificationsRecord n) {
    final title = n.title ?? 'Notification';
    final body = n.notificationText ?? '';
    final when = n.createdTime ?? n.date;
    final img = _imgUrl(n.avater);
    final type = _detectType(n);

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Type chip + timestamp ───
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: type.color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(type.icon, color: type.color, size: 13),
                    const SizedBox(width: 5),
                    Text(
                      type.label,
                      style: TextStyle(
                        color: type.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                _timeAgo(when),
                style: TextStyle(
                  color: _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ─── Main card ───
          Container(
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image if any
                if (img.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      img,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Title
                Text(
                  title,
                  style: TextStyle(
                    color: _text,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),

                // Divider
                Container(height: 1, color: _border),
                const SizedBox(height: 12),

                // Body
                if (body.isNotEmpty)
                  SelectableText(
                    body,
                    style: TextStyle(
                      color: _text,
                      fontSize: 15,
                      height: 1.55,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                else
                  Text(
                    'No details provided.',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ─── Back to notifications button ───
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kGreen.withOpacity(0.3)),
              ),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_rounded, color: kGreen, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Back to Notifications',
                      style: TextStyle(
                        color: kGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _empty(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_off_outlined,
                  color: kGreen, size: 36),
            ),
            const SizedBox(height: 16),
            Text(msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _text,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      ),
    );
  }

  ({Color color, IconData icon, String label}) _detectType(
      NotificationsRecord n) {
    final t = (n.title ?? '').toLowerCase();
    final b = (n.notificationText ?? '').toLowerCase();
    final hay = '$t $b';
    if (hay.contains('flash') || hay.contains('sale') || hay.contains('offer'))
      return (
        color: kRed,
        icon: Icons.local_offer_rounded,
        label: 'PROMO'
      );
    if (hay.contains('feature') || hay.contains('update'))
      return (
        color: kBlue,
        icon: Icons.auto_awesome_rounded,
        label: 'UPDATE'
      );
    if (hay.contains('maintenance') || hay.contains('alert'))
      return (
        color: kAmber,
        icon: Icons.warning_amber_rounded,
        label: 'ALERT'
      );
    if (hay.contains('welcome'))
      return (
        color: kGreen,
        icon: Icons.waving_hand_rounded,
        label: 'WELCOME'
      );
    if (hay.contains('order'))
      return (
        color: kBlue,
        icon: Icons.shopping_bag_rounded,
        label: 'ORDER'
      );
    if (hay.contains('message') || hay.contains('chat'))
      return (
        color: kBlue,
        icon: Icons.chat_bubble_rounded,
        label: 'MESSAGE'
      );
    return (color: kGreen, icon: Icons.notifications_rounded, label: 'NOTICE');
  }

  String _timeAgo(DateTime? when) {
    if (when == null) return '';
    final d = DateTime.now().difference(when);
    if (d.inSeconds < 60) return 'Just now';
    if (d.inMinutes < 60) return '${d.inMinutes} min ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    if (d.inDays < 7) return '${d.inDays}d ago';
    return '${when.day}/${when.month}/${when.year}';
  }
}
