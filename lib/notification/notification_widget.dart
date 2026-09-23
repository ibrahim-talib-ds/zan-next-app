import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'notification_model.dart';
export 'notification_model.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  static String routeName = 'Notification';
  static String routePath = '/notification';

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late NotificationModel _model;

  static const Color kGreen = Color(0xFF1B7A4E);

  // ─── Per-type visual identity ───────────────────────────
  static const Map<NotifyFilter, _TypeStyle> _styles = {
    NotifyFilter.message:  _TypeStyle(Icons.chat_bubble_rounded,        Color(0xFF2563EB), Color(0x1A2563EB)),
    NotifyFilter.product:  _TypeStyle(Icons.inventory_2_rounded,        Color(0xFF1B7A4E), Color(0x1A1B7A4E)),
    NotifyFilter.auth:     _TypeStyle(Icons.verified_user_rounded,      Color(0xFF0D9488), Color(0x1A0D9488)),
    NotifyFilter.promo:    _TypeStyle(Icons.local_offer_rounded,        Color(0xFFDC0F0F), Color(0x1ADC0F0F)),
    NotifyFilter.favorite: _TypeStyle(Icons.favorite_rounded,           Color(0xFFDB2777), Color(0x1ADB2777)),
    NotifyFilter.review:   _TypeStyle(Icons.star_rounded,               Color(0xFFF59E0B), Color(0x1AF59E0B)),
    NotifyFilter.social:   _TypeStyle(Icons.people_alt_rounded,         Color(0xFF7C3AED), Color(0x1A7C3AED)),
    NotifyFilter.system:   _TypeStyle(Icons.settings_rounded,           Color(0xFF6B7280), Color(0x1A6B7280)),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ─── Theme-aware color helpers ────────────────────────────
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bgColor     => _isDark ? const Color(0xFF121212) : const Color(0xFFF5F7F8);
  Color get _cardColor   => _isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _cardRead    => _isDark ? const Color(0xFF191919) : const Color(0xFFFAFAFA);
  Color get _textColor   => _isDark ? Colors.white            : const Color(0xFF111827);
  Color get _mutedColor  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _borderColor => _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E7EB);

  // ═══════════════════════════════════════════════════════════
  // TYPE INFERENCE (no `type` field in schema → infer)
  // ═══════════════════════════════════════════════════════════
  NotifyFilter _detectType(NotificationsRecord r) {
    final title = r.title.toLowerCase();
    final body = r.notificationText.toLowerCase();
    final pid = r.productId.trim();
    final haystack = '$title $body';

    if (pid.startsWith('chats/') || pid.startsWith('chat/') ||
        haystack.contains('message') || haystack.contains('chat') ||
        haystack.contains('replied')) {
      return NotifyFilter.message;
    }
    if (haystack.contains('order') || haystack.contains('ship') ||
        haystack.contains('delivery')) {
      // Orders intentionally fall through to system (you removed them).
      return NotifyFilter.system;
    }
    if (pid.startsWith('inventory/') || pid.isNotEmpty && !pid.contains('/') ||
        haystack.contains('new product') || haystack.contains('restock') ||
        haystack.contains('added') || haystack.contains('listed') ||
        haystack.contains('available')) {
      return NotifyFilter.product;
    }
    if (haystack.contains('verified') || haystack.contains('approved') ||
        haystack.contains('kyc') || haystack.contains('seller account') ||
        haystack.contains('authorized')) {
      return NotifyFilter.auth;
    }
    if (haystack.contains('promo') || haystack.contains('offer') ||
        haystack.contains('discount') || haystack.contains('sale') ||
        haystack.contains('deal')) {
      return NotifyFilter.promo;
    }
    if (haystack.contains('wishlist') || haystack.contains('favorite') ||
        haystack.contains('price drop') || haystack.contains('saved')) {
      return NotifyFilter.favorite;
    }
    if (haystack.contains('review') || haystack.contains('rating') ||
        haystack.contains('star')) {
      return NotifyFilter.review;
    }
    if (haystack.contains('follow') || haystack.contains('followed') ||
        haystack.contains('subscriber')) {
      return NotifyFilter.social;
    }
    if (haystack.contains('login') || haystack.contains('security') ||
        haystack.contains('password')) {
      return NotifyFilter.system;
    }
    return NotifyFilter.system; // fallback
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════

  // ═══════════════════════════════════════════════════════════
  // SMART ROUTER — send user to the right screen based on
  // the notification title / content
  // ═══════════════════════════════════════════════════════════
  Future<void> _openNotification(dynamic notif) async {
    final type = (() {
      try { return (notif.type as String? ?? '').toLowerCase(); } catch (_) {}
      return '';
    })();
    final productId = (() {
      try { return (notif.productId as String? ?? ''); } catch (_) {}
      return '';
    })();
    final title = (() {
      try { return (notif.title as String? ?? '').toLowerCase(); } catch (_) {}
      return '';
    })();

    // Mark as read first (best effort)
    try {
      if (notif.isRead == false) {
        notif.reference.update({'is_read': true}).catchError((_) {});
      }
    } catch (_) {}

    // ── 1. CHAT ─────────────────────────────────────────────
    if (type == 'chat') {
      try {
        final chatRef = await _findChatForNotification(notif);
        if (chatRef != null) {
          if (!mounted) return;
          context.pushNamed(
            ChatDWidget.routeName,
            queryParameters: {
              'receiveChats':
                  serializeParam(chatRef, ParamType.DocumentReference),
            }.withoutNulls,
          );
          return;
        }
      } catch (_) {}
      // fallback → open messages list
      try {
        context.pushNamed(NotificationWidget.routeName);
        return;
      } catch (_) {}
    }

    // ── 2. ORDER ────────────────────────────────────────────
    if (type == 'order') {
      if (productId.isNotEmpty) {
        try {
          context.pushNamed(
            Order1Widget.routeName,
            queryParameters: {'orderId': productId}.withoutNulls,
          );
          return;
        } catch (_) {}
      }
      try {
        context.pushNamed(OrderDetailsWidget.routeName);
        return;
      } catch (_) {}
    }

    // ── 3. PRODUCT ──────────────────────────────────────────
    if (type == 'product' && productId.isNotEmpty) {
      try {
        final docRef =
            FirebaseFirestore.instance.collection('inventory').doc(productId);
        context.pushNamed(
          ProductDetailsWidget.routeName,
          queryParameters: {
            'inventoryRef':
                serializeParam(docRef, ParamType.DocumentReference),
          }.withoutNulls,
        );
        return;
      } catch (_) {}
    }

    // ── 4. Anything else → notification list ────────────────
    try {
      context.pushNamed(NotificationDetailsWidget.routeName);
      return;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (currentUserReference == null) return _notLoggedInState();

    return StreamBuilder<List<NotificationsRecord>>(
      stream: queryNotificationsRecord(
        queryBuilder: (r) => r.where('user_ref', isEqualTo: currentUserReference),
        limit: 200,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) return _errorState('${snapshot.error}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 40, height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                strokeWidth: 3,
              ),
            ),
          );
        }
        final all = List<NotificationsRecord>.from(snapshot.data ?? const []);
        all.sort((a, b) {
          final at = a.createdTime ?? a.date ?? DateTime(1970);
          final bt = b.createdTime ?? b.date ?? DateTime(1970);
          return bt.compareTo(at);
        });

        // Group by type for the chip counts
        final counts = <NotifyFilter, int>{ NotifyFilter.all: all.length };
        for (final n in all) {
          final t = _detectType(n);
          counts[t] = (counts[t] ?? 0) + 1;
        }

        // Filter by chip
        final filtered = _model.selectedFilter == NotifyFilter.all
            ? all
            : all.where((n) => _detectType(n) == _model.selectedFilter).toList();

        // Split into unread/read
        final unread = filtered.where((n) => !n.isRead).toList();
        final read   = filtered.where((n) =>  n.isRead).toList();

        return Column(
          children: [
            _buildFilterChips(counts),
            Expanded(
              child: filtered.isEmpty
                  ? _emptyState()
                  : RefreshIndicator(
                      color: kGreen,
                      onRefresh: () async => safeSetState(() {}),
                      child: ListView(
                        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
                        children: [
                          if (unread.isNotEmpty) ...[
                            _sectionHeader('New', unread.length),
                            const SizedBox(height: 8),
                            ...unread.map((n) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _swipeToDelete(
                                    n,
                                    _notificationTile(n, unread: true),
                                  ),
                                )),
                            const SizedBox(height: 16),
                          ],
                          if (read.isNotEmpty) ...[
                            _sectionHeader('Earlier', read.length),
                            const SizedBox(height: 8),
                            ...read.map((n) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _swipeToDelete(
                                    n,
                                    _notificationTile(n, unread: false),
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _buildHeader() {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(0, topPad + 8, 0, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreen, Color(0xFF0A3A22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
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
              child: Text(
                'Notifications',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(
              onPressed: _model.isMarkingAll ? null : _markAllRead,
              child: Text(
                _model.isMarkingAll ? 'Wait...' : 'Mark all',
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded,
                  color: Colors.white, size: 22),
              onSelected: (v) {
                if (v == 'clear_all') _confirmClearAll();
                if (v == 'clear_read') _confirmClearRead();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'clear_read',
                  child: Row(
                    children: [
                      Icon(Icons.done_all_rounded, size: 18),
                      SizedBox(width: 10),
                      Text('Clear read only'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep_rounded,
                          size: 18, color: Color(0xFFDC0F0F)),
                      SizedBox(width: 10),
                      Text('Clear all',
                          style: TextStyle(color: Color(0xFFDC0F0F))),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SWIPE-TO-DELETE WRAPPER
  // ═══════════════════════════════════════════════════════════
  Widget _swipeToDelete(NotificationsRecord n, Widget child) {
    return Dismissible(
      key: ValueKey('notif_${n.reference.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
        decoration: BoxDecoration(
          color: const Color(0xFFDC0F0F),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
            SizedBox(width: 6),
            Text('Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                )),
          ],
        ),
      ),
      confirmDismiss: (_) => _confirmDeleteOne(n),
      onDismissed: (_) => _deleteOne(n),
      child: child,
    );
  }

  Future<bool> _confirmDeleteOne(NotificationsRecord n) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: _cardColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Text('Delete notification?',
                style: TextStyle(
                    color: _textColor, fontWeight: FontWeight.w800, fontSize: 16)),
            content: Text(
              valueOrDefault<String>(n.title, 'This notification'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: _mutedColor, fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Keep',
                    style: TextStyle(
                        color: _mutedColor, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete',
                    style: TextStyle(
                        color: Color(0xFFDC0F0F), fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteOne(NotificationsRecord n) async {
    try {
      await n.reference.delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Notification deleted'),
          backgroundColor: kGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not delete: $e'),
          backgroundColor: const Color(0xFFDC0F0F),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _confirmClearAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Clear all notifications?',
            style: TextStyle(
                color: _textColor, fontWeight: FontWeight.w800, fontSize: 16)),
        content: Text(
          'This will permanently delete every notification. You cannot undo.',
          style: TextStyle(color: _mutedColor, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: TextStyle(
                    color: _mutedColor, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear All',
                style: TextStyle(
                    color: Color(0xFFDC0F0F), fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
    if (ok == true) await _deleteAllNotifications(onlyRead: false);
  }

  Future<void> _confirmClearRead() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Clear read notifications?',
            style: TextStyle(
                color: _textColor, fontWeight: FontWeight.w800, fontSize: 16)),
        content: Text("Only notifications you've already seen will be removed.",
            style: TextStyle(color: _mutedColor, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: TextStyle(
                    color: _mutedColor, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear',
                style: TextStyle(
                    color: Color(0xFFDC0F0F), fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
    if (ok == true) await _deleteAllNotifications(onlyRead: true);
  }

  Future<void> _deleteAllNotifications({required bool onlyRead}) async {
    try {
      final q = await FirebaseFirestore.instance
          .collection('notifications')
          .where('user_ref', isEqualTo: currentUserReference)
          .where('is_read', isEqualTo: onlyRead ? true : false)
          .get();

      if (q.docs.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing to clear')),
        );
        return;
      }

      final batch = FirebaseFirestore.instance.batch();
      for (final doc in q.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cleared ${q.docs.length} notification(s)'),
          backgroundColor: kGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      safeSetState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not clear: $e'),
          backgroundColor: const Color(0xFFDC0F0F),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // FILTER CHIPS
  // ═══════════════════════════════════════════════════════════
  Widget _buildFilterChips(Map<NotifyFilter, int> counts) {
    // Build the ordered chip list, skipping empty filters.
    final entries = <_ChipSpec>[
      _ChipSpec(NotifyFilter.all,      'All'),
      _ChipSpec(NotifyFilter.message,  'Messages'),
      _ChipSpec(NotifyFilter.product,  'Products'),
      _ChipSpec(NotifyFilter.auth,     'Auth'),
      _ChipSpec(NotifyFilter.promo,    'Promos'),
      _ChipSpec(NotifyFilter.favorite, 'Favorites'),
      _ChipSpec(NotifyFilter.review,   'Reviews'),
      _ChipSpec(NotifyFilter.social,   'Social'),
      _ChipSpec(NotifyFilter.system,   'System'),
    ];

    final visible = entries.where((e) =>
        e.filter == NotifyFilter.all || (counts[e.filter] ?? 0) > 0).toList();

    return Container(
      height: 52,
      color: _bgColor,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
        itemCount: visible.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final spec = visible[i];
          final count = counts[spec.filter] ?? 0;
          final active = _model.selectedFilter == spec.filter;
          final style = _styles[spec.filter];

          return GestureDetector(
            onTap: () => safeSetState(() => _model.selectedFilter = spec.filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: active ? kGreen : _cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? kGreen : _borderColor,
                  width: 1.4,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (style != null) ...[
                    Icon(style.icon, size: 14, color: active ? Colors.white : style.color),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    spec.label,
                    style: TextStyle(
                      color: active ? Colors.white : _textColor,
                      fontSize: 13,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white.withOpacity(0.25)
                            : kGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: active ? Colors.white : kGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SECTION HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _sectionHeader(String label, int count) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 2, 0),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: _textColor, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: kGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('$count',
                style: const TextStyle(color: kGreen, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // NOTIFICATION TILE
  // ═══════════════════════════════════════════════════════════
  Widget _notificationTile(NotificationsRecord record, {required bool unread}) {
    final title = record.hasTitle() ? record.title : 'Notification';
    final body = record.hasNotificationText() ? record.notificationText : '';
    final when = record.createdTime ?? record.date;
    final type = _detectType(record);
    final style = _styles[type] ?? _styles[NotifyFilter.system]!;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openDetails(record, type),
      child: Container(
        decoration: BoxDecoration(
          color: unread ? _cardColor : _cardRead,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: unread ? style.color.withOpacity(0.4) : _borderColor,
            width: unread ? 1.4 : 1,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: style.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(style.icon, color: style.color, size: 22),
                ),
                if (unread)
                  Positioned(
                    right: -2, top: -2,
                    child: Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(
                        color: style.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: _isDark ? _bgColor : Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 14,
                      fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  if (body.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: _mutedColor, fontSize: 13, height: 1.35),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: style.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          type.name.toUpperCase(),
                          style: TextStyle(color: style.color, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _timeAgo(when),
                        style: TextStyle(color: _mutedColor, fontSize: 11.5, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, color: _mutedColor, size: 20),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ROUTER — every type lands somewhere sensible
  // ═══════════════════════════════════════════════════════════
  Future<void> _openDetails(NotificationsRecord record, NotifyFilter type) async {
    if (!record.isRead) record.reference.update({'is_read': true}).catchError((_) {});
    if (!mounted) return;

    // Normalise product_id
    String pid = record.productId.trim();
    if (pid.startsWith('/')) pid = pid.substring(1);

    try {
      switch (type) {
        case NotifyFilter.message:
          // Try to resolve a chat reference from product_id first
          DocumentReference? chatRef;
          if (pid.startsWith('chats/')) {
            chatRef = FirebaseFirestore.instance.doc(pid);
          } else if (pid.startsWith('chat/')) {
            chatRef = FirebaseFirestore.instance.doc(pid.replaceFirst('chat/', 'chats/'));
          } else if (pid.isNotEmpty && !pid.contains('/')) {
            // Bare doc id → assume it's a Chats doc id
            chatRef = FirebaseFirestore.instance.collection('Chats').doc(pid);
          }

          // Fallback: search for a chat where current user is a participant
          // and (optionally) the other participant matches the sender name.
          if (chatRef == null) {
            chatRef = await _findChatForNotification(record);
          }

          context.pushNamed(
            ChatDWidget.routeName,
            queryParameters: {
              if (chatRef != null)
                'receiveChats': serializeParam(chatRef, ParamType.DocumentReference),
            }.withoutNulls,
            extra: _t(),
          );
          return;

        case NotifyFilter.product:
        case NotifyFilter.favorite:
          DocumentReference? invRef;
          if (pid.startsWith('inventory/')) {
            invRef = FirebaseFirestore.instance.doc(pid);
          } else if (pid.isNotEmpty && !pid.contains('/')) {
            invRef = FirebaseFirestore.instance.collection('Inventory').doc(pid);
          }
          if (invRef != null) {
            context.pushNamed(
              ProductDetailsWidget.routeName,
              queryParameters: {
                'inventoryRef': serializeParam(invRef, ParamType.DocumentReference),
              }.withoutNulls,
              extra: _t(),
            );
            return;
          }
          context.pushNamed(CategorysZWidget.routeName, extra: _t());
          return;

        case NotifyFilter.auth:
          context.pushNamed(SellerDashbordWidget.routeName, extra: _t());
          return;

        case NotifyFilter.promo:
          context.pushNamed(CategorysZWidget.routeName, extra: _t());
          return;

        case NotifyFilter.review:
          context.pushNamed(ReviewsWidget.routeName, extra: _t());
          return;

        case NotifyFilter.social:
          // NOTE: When you build a public seller profile, swap this for its route.
          context.pushNamed(SellerDashbordWidget.routeName, extra: _t());
          return;

        case NotifyFilter.system:
          await _openNotification(record);
          return;

        case NotifyFilter.all:
          context.pushNamed(HomeWidget.routeName, extra: _t());
          return;
      }
    } catch (e) {
      debugPrint('🔔 Routing error: $e');
      if (!mounted) return;
      context.pushNamed(HomeWidget.routeName);
    }
  }


  // ═══════════════════════════════════════════════════════════
  // CHAT RESOLUTION for message notifications
  // ═══════════════════════════════════════════════════════════
  Future<DocumentReference?> _findChatForNotification(
    NotificationsRecord record,
  ) async {
    try {
      // Extract a probable sender name from the notification title.
      // Common formats: "New message from Ahmed", "Ahmed: hello", etc.
      final titleRaw = record.title.trim();
      String? senderName;
      final m1 = RegExp(r'from\s+(.+)$', caseSensitive: false)
          .firstMatch(titleRaw);
      if (m1 != null) senderName = m1.group(1)?.trim();
      final m2 = RegExp(r'^([^:]+):', caseSensitive: false)
          .firstMatch(titleRaw);
      senderName ??= m2?.group(1)?.trim();

      // 1. Query Chats where the user is buyer or seller.
      //    We do two queries because Firestore can't OR them.
      final q1 = await FirebaseFirestore.instance
          .collection('Chats')
          .where('buyer_ref', isEqualTo: currentUserReference)
          .orderBy('last_message_time', descending: true)
          .limit(10)
          .get();

      final q2 = await FirebaseFirestore.instance
          .collection('Chats')
          .where('seller_ref', isEqualTo: currentUserReference)
          .orderBy('last_message_time', descending: true)
          .limit(10)
          .get();

      final all = [...q1.docs, ...q2.docs];
      if (all.isEmpty) return null;

      // If we extracted a sender name, prefer the chat whose other
      // party name matches. Otherwise fall back to the most recent chat.
      if (senderName != null && senderName.isNotEmpty) {
        final needle = senderName.toLowerCase();
        for (final doc in all) {
          final data = doc.data();
          final buyerName = (data['buyer_name'] ?? '').toString().toLowerCase();
          final sellerName = (data['seller_name'] ?? '').toString().toLowerCase();
          if (buyerName.contains(needle) || sellerName.contains(needle)) {
            return doc.reference;
          }
        }
      }
      return all.first.reference;
    } catch (e) {
      debugPrint('🔔 _findChatForNotification failed: $e');
      return null;
    }
  }

  Map<String, dynamic> _t() => <String, dynamic>{
        '__transition_info__': TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 250),
        ),
      };

  // ═══════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════
  Future<void> _markAllRead() async {
    if (_model.isMarkingAll) return;
    safeSetState(() => _model.isMarkingAll = true);
    try {
      final snap = await NotificationsRecord.collection
          .where('user_ref', isEqualTo: currentUserReference)
          .where('is_read', isEqualTo: false)
          .get();
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in snap.docs) {
        batch.update(doc.reference, {'is_read': true});
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Mark-all error: $e');
    }
    if (mounted) safeSetState(() => _model.isMarkingAll = false);
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

  // ═══════════════════════════════════════════════════════════
  // STATES
  // ═══════════════════════════════════════════════════════════
  Widget _emptyState() => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: kGreen.withOpacity(0.12), shape: BoxShape.circle),
                child: const Icon(Icons.notifications_off_outlined, color: kGreen, size: 38),
              ),
              const SizedBox(height: 16),
              Text('No notifications yet',
                  style: TextStyle(color: _textColor, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(
                _model.selectedFilter == NotifyFilter.all
                    ? 'When you get updates about your orders, messages, or offers, they will appear here.'
                    : 'No ${_model.selectedFilter.name} notifications.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _mutedColor, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
      );

  Widget _errorState(String msg) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, color: Color(0xFFDC0F0F), size: 48),
              const SizedBox(height: 12),
              Text('Could not load notifications',
                  style: TextStyle(color: _textColor, fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(msg, textAlign: TextAlign.center, style: TextStyle(color: _mutedColor, fontSize: 12)),
            ],
          ),
        ),
      );

  Widget _notLoggedInState() => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline_rounded, color: _mutedColor, size: 48),
              const SizedBox(height: 12),
              Text('Please sign in',
                  style: TextStyle(color: _textColor, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('You need to be signed in to see your notifications.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _mutedColor, fontSize: 13)),
            ],
          ),
        ),
      );
}

// ═══════════════════════════════════════════════════════════════
// Small helper records
// ═══════════════════════════════════════════════════════════════
class _TypeStyle {
  final IconData icon;
  final Color color;
  final Color background;
  const _TypeStyle(this.icon, this.color, this.background);
}

class _ChipSpec {
  final NotifyFilter filter;
  final String label;
  const _ChipSpec(this.filter, this.label);
}
