import '/auth/firebase_auth/auth_util.dart';
import '/repositories/notification_repository.dart';
import '/services/api_client.dart' as zannext_api;
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';

import 'notification_model.dart';
import '/components/shimmer.dart';
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

  static const Map<NotifyFilter, _TypeStyle> _styles = {
    NotifyFilter.message:  _TypeStyle(Icons.chat_bubble_rounded,   Color(0xFF2563EB), Color(0x1A2563EB)),
    NotifyFilter.product:  _TypeStyle(Icons.inventory_2_rounded,   Color(0xFF1B7A4E), Color(0x1A1B7A4E)),
    NotifyFilter.auth:     _TypeStyle(Icons.verified_user_rounded, Color(0xFF0D9488), Color(0x1A0D9488)),
    NotifyFilter.promo:    _TypeStyle(Icons.local_offer_rounded,   Color(0xFFDC0F0F), Color(0x1ADC0F0F)),
    NotifyFilter.favorite: _TypeStyle(Icons.favorite_rounded,      Color(0xFFDB2777), Color(0x1ADB2777)),
    NotifyFilter.review:   _TypeStyle(Icons.star_rounded,          Color(0xFFF59E0B), Color(0x1AF59E0B)),
    NotifyFilter.social:   _TypeStyle(Icons.people_alt_rounded,    Color(0xFF7C3AED), Color(0x1A7C3AED)),
    NotifyFilter.system:   _TypeStyle(Icons.settings_rounded,      Color(0xFF6B7280), Color(0x1A6B7280)),
  };

  List<Map<String, dynamic>> _all = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationModel());
    _load();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ─── defensive JSON helpers ───────────────────────────────
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
  String _id(Map m) => _s(m, ['id', 'notification_id', 'notificationId']);
  String _pid(Map m) => _s(m, ['product_id', 'productId']);
  String _title(Map m) => _s(m, ['title'], 'Notification');
  String _body(Map m) => _s(m, ['body', 'notification_text', 'notificationText']);
  bool _read(Map m) => _b(m, ['is_read', 'isRead']);
  DateTime? _when(Map m) => _d(m, ['created_at', 'createdAt', 'date']);

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
      final list = ((raw as List).map(_asMap).toList());
      list.sort((a, b) {
        final at = _when(a) ?? DateTime(1970);
        final bt = _when(b) ?? DateTime(1970);
        return bt.compareTo(at);
      });
      _all = list;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) safeSetState(() => _loading = false);
  }

  // ─── theme ────────────────────────────────────────────────
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bgColor     => _isDark ? const Color(0xFF121212) : const Color(0xFFF5F7F8);
  Color get _cardColor   => _isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _cardRead    => _isDark ? const Color(0xFF191919) : const Color(0xFFFAFAFA);
  Color get _textColor   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _mutedColor  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _borderColor => _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E7EB);

  // ─── type inference (same rules, on maps) ─────────────────
  NotifyFilter _detectType(Map<String, dynamic> n) {
    final title = _title(n).toLowerCase();
    final body = _body(n).toLowerCase();
    final pid = _pid(n).trim();
    final hay = '$title $body';

    if (pid.startsWith('chats/') || pid.startsWith('chat/') ||
        hay.contains('message') || hay.contains('chat') || hay.contains('replied')) {
      return NotifyFilter.message;
    }
    if (title.startsWith('new order') || title.startsWith('order') ||
        title.startsWith('your order') || title == 'order') {
      return NotifyFilter.system;
    }
    if (hay.contains('order') || hay.contains('ship') || hay.contains('delivery')) {
      return NotifyFilter.system;
    }
    if (pid.isNotEmpty && !pid.contains('/') ||
        hay.contains('new product') || hay.contains('restock') ||
        hay.contains('added') || hay.contains('listed') || hay.contains('available')) {
      return NotifyFilter.product;
    }
    if (hay.contains('verified') || hay.contains('approved') || hay.contains('kyc') ||
        hay.contains('seller account') || hay.contains('authorized')) {
      return NotifyFilter.auth;
    }
    if (hay.contains('promo') || hay.contains('offer') || hay.contains('discount') ||
        hay.contains('sale') || hay.contains('deal')) {
      return NotifyFilter.promo;
    }
    if (hay.contains('wishlist') || hay.contains('favorite') ||
        hay.contains('price drop') || hay.contains('saved')) {
      return NotifyFilter.favorite;
    }
    if (hay.contains('review') || hay.contains('rating') || hay.contains('star')) {
      return NotifyFilter.review;
    }
    if (hay.contains('follow') || hay.contains('followed') || hay.contains('subscriber')) {
      return NotifyFilter.social;
    }
    return NotifyFilter.system;
  }

  // ═══════════════════════════════════════════════════════════
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
    if (currentUserUid.isEmpty) return _notLoggedInState();
    if (_loading) {
      return const ShimmerListView(count: 5);
    }
    if (_error != null) return _errorState(_error!);

    final counts = <NotifyFilter, int>{NotifyFilter.all: _all.length};
    for (final n in _all) {
      final t = _detectType(n);
      counts[t] = (counts[t] ?? 0) + 1;
    }
    final filtered = _model.selectedFilter == NotifyFilter.all
        ? _all
        : _all.where((n) => _detectType(n) == _model.selectedFilter).toList();
    final unread = filtered.where((n) => !_read(n)).toList();
    final read = filtered.where((n) => _read(n)).toList();

    return Column(
      children: [
        _buildFilterChips(counts),
        Expanded(
          child: filtered.isEmpty
              ? _emptyState()
              : RefreshIndicator(
                  color: kGreen,
                  onRefresh: () async => _load(),
                  child: ListView(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
                    children: [
                      if (unread.isNotEmpty) ...[
                        _sectionHeader('New', unread.length),
                        const SizedBox(height: 8),
                        ...unread.map((n) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _swipeToDelete(n, _notificationTile(n, unread: true)),
                            )),
                        const SizedBox(height: 16),
                      ],
                      if (read.isNotEmpty) ...[
                        _sectionHeader('Earlier', read.length),
                        const SizedBox(height: 8),
                        ...read.map((n) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _swipeToDelete(n, _notificationTile(n, unread: false)),
                            )),
                      ],
                    ],
                  ),
                ),
        ),
      ],
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
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            TextButton(
              onPressed: _model.isMarkingAll ? null : _markAllRead,
              child: Text(_model.isMarkingAll ? 'Wait...' : 'Mark all',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 22),
              onSelected: (v) {
                if (v == 'clear_all') _confirmClearAll();
                if (v == 'clear_read') _confirmClearRead();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'clear_read',
                  child: Row(children: [
                    Icon(Icons.done_all_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Clear read only'),
                  ]),
                ),
                PopupMenuItem(
                  value: 'clear_all',
                  child: Row(children: [
                    Icon(Icons.delete_sweep_rounded, size: 18, color: Color(0xFFDC0F0F)),
                    SizedBox(width: 10),
                    Text('Clear all', style: TextStyle(color: Color(0xFFDC0F0F))),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── actions ──────────────────────────────────────────────
  Future<void> _markAllRead() async {
    if (_model.isMarkingAll) return;
    safeSetState(() => _model.isMarkingAll = true);
    try {
      try {
        await NotificationRepository.markAllRead();
      } catch (_) {
        for (final n in _all.where((n) => !_read(n))) {
          try {
            await zannext_api.ApiClient.patch('/notifications/${_id(n)}/read');
          } catch (_) {}
        }
      }
      await _load();
    } catch (e) {
      debugPrint('Mark-all error: $e');
    }
    if (mounted) safeSetState(() => _model.isMarkingAll = false);
  }

  Future<void> _deleteOne(Map<String, dynamic> n) async {
    final id = _id(n);
    if (id.isEmpty) return;
    try {
      await zannext_api.ApiClient.delete('/notifications/$id');
      _all = _all.where((x) => _id(x) != id).toList();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Notification deleted'),
          backgroundColor: kGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      safeSetState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Delete not supported by backend yet'),
          backgroundColor: const Color(0xFFDC0F0F),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _deleteAllNotifications({required bool onlyRead}) async {
    final targets = _all.where((n) => onlyRead ? _read(n) : true).toList();
    if (targets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to clear')));
      return;
    }
    var okCount = 0;
    for (final n in targets) {
      try {
        await zannext_api.ApiClient.delete('/notifications/${_id(n)}');
        okCount++;
      } catch (_) {}
    }
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(okCount > 0
            ? 'Cleared $okCount notification(s)'
            : 'Backend delete not available yet'),
        backgroundColor: okCount > 0 ? kGreen : const Color(0xFFDC0F0F),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
        content: Text('This will permanently delete every notification. You cannot undo.',
            style: TextStyle(color: _mutedColor, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: TextStyle(color: _mutedColor, fontWeight: FontWeight.w600))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear All',
                style: TextStyle(
                    color: Color(0xFFDC0F0F), fontWeight: FontWeight.w800))),
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
                style: TextStyle(color: _mutedColor, fontWeight: FontWeight.w600))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear',
                style: TextStyle(
                    color: Color(0xFFDC0F0F), fontWeight: FontWeight.w800))),
        ],
      ),
    );
    if (ok == true) await _deleteAllNotifications(onlyRead: true);
  }

  // ─── swipe ────────────────────────────────────────────────
  Widget _swipeToDelete(Map<String, dynamic> n, Widget child) {
    return Dismissible(
      key: ValueKey('notif_${_id(n)}'),
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
                    color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: _cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Text('Delete notification?',
                    style: TextStyle(
                        color: _textColor, fontWeight: FontWeight.w800, fontSize: 16)),
                content: Text(_title(n),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: _mutedColor, fontSize: 13)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text('Keep',
                        style: TextStyle(
                            color: _mutedColor, fontWeight: FontWeight.w600))),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Delete',
                        style: TextStyle(
                            color: Color(0xFFDC0F0F), fontWeight: FontWeight.w800))),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => _deleteOne(n),
      child: child,
    );
  }

  // ─── chips ────────────────────────────────────────────────
  Widget _buildFilterChips(Map<NotifyFilter, int> counts) {
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
    final visible = entries
        .where((e) => e.filter == NotifyFilter.all || (counts[e.filter] ?? 0) > 0)
        .toList();

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
                  color: active ? kGreen : _borderColor, width: 1.4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (style != null) ...[
                    Icon(style.icon, size: 14, color: active ? Colors.white : style.color),
                    const SizedBox(width: 6),
                  ],
                  Text(spec.label,
                      style: TextStyle(
                        color: active ? Colors.white : _textColor,
                        fontSize: 13,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      )),
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
                      child: Text('$count',
                          style: TextStyle(
                            color: active ? Colors.white : kGreen,
                            fontSize: 10, fontWeight: FontWeight.w700,
                          )),
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

  Widget _sectionHeader(String label, int count) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 2, 0),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  color: _textColor, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: kGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('$count',
                style: const TextStyle(
                    color: kGreen, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ─── tile ─────────────────────────────────────────────────
  Widget _notificationTile(Map<String, dynamic> n, {required bool unread}) {
    final title = _title(n);
    final body = _body(n);
    final when = _when(n);
    final type = _detectType(n);
    final style = _styles[type] ?? _styles[NotifyFilter.system]!;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openDetails(n, type),
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
                        border: Border.all(
                            color: _isDark ? _bgColor : Colors.white, width: 2),
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
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 14,
                        fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                      )),
                  if (body.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: _mutedColor, fontSize: 13, height: 1.35)),
                  ],
                  if ((n['image_url'] ?? '').toString().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        (n['image_url'] ?? '').toString(),
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
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
                        child: Text(type.name.toUpperCase(),
                            style: TextStyle(
                                color: style.color,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4)),
                      ),
                      const SizedBox(width: 8),
                      Text(_timeAgo(when),
                          style: TextStyle(
                              color: _mutedColor,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500)),
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

  // ─── router ───────────────────────────────────────────────
  Future<void> _openDetails(Map<String, dynamic> n, NotifyFilter type) async {
    if (!_read(n)) {
      try {
        await NotificationRepository.markRead(_id(n));
      } catch (_) {
        try {
          await zannext_api.ApiClient.patch('/notifications/${_id(n)}/read');
        } catch (_) {}
      }
      _load();
    }
    if (!mounted) return;

    String pid = _pid(n).trim();
    if (pid.startsWith('/')) pid = pid.substring(1);

    try {
      switch (type) {
        case NotifyFilter.message:
          String chatId = pid;
          if (chatId.startsWith('chats/')) chatId = chatId.replaceFirst('chats/', '');
          if (chatId.startsWith('chat/')) chatId = chatId.replaceFirst('chat/', '');
          if (chatId.isNotEmpty && !chatId.contains('/')) {
            context.pushNamed(
              ChatDWidget.routeName,
              queryParameters: {
                'chatId': serializeParam(chatId, ParamType.String),
              }.withoutNulls,
            );
            return;
          }
          context.pushNamed(MessagelistWidget.routeName);
          return;

        case NotifyFilter.product:
        case NotifyFilter.favorite:
          if (pid.isNotEmpty) {
            context.pushNamed(
              ProductDetailsWidget.routeName,
              queryParameters: {
                'inventoryRef': serializeParam(pid, ParamType.String),
              }.withoutNulls,
            );
            return;
          }
          _showDetailDialog(n);
          return;

        case NotifyFilter.auth:
          context.pushNamed(SellerDashbordWidget.routeName);
          return;

        case NotifyFilter.promo:
          context.pushNamed(CategorysZWidget.routeName);
          return;

        case NotifyFilter.review:
          context.pushNamed(ReviewsWidget.routeName);
          return;

        case NotifyFilter.social:
          context.pushNamed(SellerDashbordWidget.routeName);
          return;

        case NotifyFilter.system:
          final t = _title(n).toLowerCase().trim();
          final isOrder = t.startsWith('new order') || t.startsWith('order update') || t.startsWith('order update') ||
              t.startsWith('order placed') ||
              t.startsWith('order received') ||
              t.startsWith('order confirmed') ||
              t.startsWith('order cancelled') ||
              t.startsWith('order shipped') ||
              t.startsWith('order delivered') ||
              t.startsWith('order on the way') ||
              t.startsWith('your order') ||
              t == 'order';
          if (isOrder) {
            final isSellerSide = t.contains('received') || t.contains('new order');
            context.pushNamed(
              OrderDetailsWidget.routeName,
              queryParameters: {
                'initialTab': isSellerSide ? 'seller' : 'buyer',
              }.withoutNulls,
            );
            return;
          }
          _showDetailDialog(n);
          return;

        case NotifyFilter.all:
          _showDetailDialog(n);
          return;
      }
    } catch (e) {
      debugPrint('Routing error: $e');
      if (!mounted) return;
      _showDetailDialog(n);
    }
  }

  void _showDetailDialog(Map<String, dynamic> n) {
    final type = _detectType(n);
    final style = _styles[type] ?? _styles[NotifyFilter.system]!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: style.background,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(style.icon, color: style.color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(_title(n),
                  style: TextStyle(
                      color: _textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_body(n),
                style: TextStyle(
                    color: _textColor, fontSize: 13.5, height: 1.5)),
            const SizedBox(height: 10),
            Text(_timeAgo(_when(n)),
                style: TextStyle(color: _mutedColor, fontSize: 11)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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

  // ─── states ───────────────────────────────────────────────
  Widget _emptyState() => Center(
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
                      color: _textColor, fontSize: 16, fontWeight: FontWeight.w700)),
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
              const Icon(Icons.error_outline_rounded,
                  color: Color(0xFFDC0F0F), size: 48),
              const SizedBox(height: 12),
              Text('Could not load notifications',
                  style: TextStyle(
                      color: _textColor, fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(msg,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _mutedColor, fontSize: 12)),
              const SizedBox(height: 12),
              TextButton(onPressed: _load, child: const Text('Retry')),
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
                  style: TextStyle(
                      color: _textColor, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('You need to be signed in to see your notifications.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _mutedColor, fontSize: 13)),
            ],
          ),
        ),
      );
}

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
