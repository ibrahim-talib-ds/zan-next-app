import '/auth/firebase_auth/auth_util.dart';
import '/repositories/chat_repository.dart';
import '/repositories/order_repository.dart';
import '/services/api_client.dart' as zannext_api;
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/internationalization.dart';
import '/index.dart';
import 'package:flutter/material.dart';

import 'order_details_model.dart';
export 'order_details_model.dart';

/// Order details — 100% Postgres.
/// Buyer tab: my orders. Seller tab: orders I sell (with status controls:
/// Pending -> Confirmed -> On the way -> Delivered, plus Cancel).
class OrderDetailsWidget extends StatefulWidget {
  const OrderDetailsWidget({super.key, this.initialTab});

  final String? initialTab;

  static String routeName = 'Order_details';
  static String routePath = '/orderDetails';

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  late OrderDetailsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kBlue = Color(0xFF3B82F6);
  static const Color kRed = Color(0xFFDC0F0F);

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

  String _s(Map m, List<String> keys, [String fb = '']) {
    for (final k in keys) {
      final v = m[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return fb;
  }

  DateTime? _d(Map m, List<String> keys) {
    for (final k in keys) {
      final p = DateTime.tryParse((m[k] ?? '').toString());
      if (p != null) return p;
    }
    return null;
  }

  List<Map<String, dynamic>> _all = const [];
  bool _loading = true;
  String? _error;
  bool _hasSellerOrders = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderDetailsModel());
    _model.activeTab = widget.initialTab ?? 'buyer';
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
      final raw = await zannext_api.ApiClient.get('/orders?user_id=$currentUserUid');
      final list = (raw as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
      list.sort((a, b) {
        final ad = _d(a, ['created_at', 'date']) ?? DateTime(1970);
        final bd = _d(b, ['created_at', 'date']) ?? DateTime(1970);
        return bd.compareTo(ad);
      });
      _all = list;
      _hasSellerOrders = _all.any((o) => _s(o, ['seller_id']) == currentUserUid);
      if (_model.activeTab == 'seller' && !_hasSellerOrders) {
        _model.activeTab = 'buyer';
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) safeSetState(() => _loading = false);
  }

  List<Map<String, dynamic>> _visible() {
    final isBuyer = _model.activeTab == 'buyer';
    return _all.where((o) {
      final mine = isBuyer
          ? _s(o, ['buyer_id']) == currentUserUid
          : _s(o, ['seller_id']) == currentUserUid;
      if (!mine) return false;
      final hidden = isBuyer ? o['hidden_for_buyer'] : o['hidden_for_seller'];
      return hidden != true && hidden != 'true';
    }).toList();
  }

  // ── BUILD ──────────────────────────────────────────────────
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
              if (_hasSellerOrders) _buildTabs(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            borderColor: Colors.transparent,
            borderRadius: 24,
            borderWidth: 1,
            buttonSize: 44,
            fillColor: Colors.white.withOpacity(0.18),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 22),
            onPressed: () => context.safePop(),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(FFLocalizations.of(context).getText('od_header_title'),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(FFLocalizations.of(context).getText('od_header_sub'),
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded,
                color: Colors.white, size: 22),
            onSelected: (v) {
              if (v == 'clear_all') _confirmBulkClear(all: true);
              if (v == 'clear_delivered') _confirmBulkClear();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'clear_delivered',
                child: Row(children: [
                  const Icon(Icons.done_all_rounded, size: 18),
                  const SizedBox(width: 10),
                  Text(FFLocalizations.of(context)
                      .getText('od_menu_clear_delivered')),
                ]),
              ),
              PopupMenuItem(
                value: 'clear_all',
                child: Row(children: [
                  const Icon(Icons.delete_sweep_rounded,
                      size: 18, color: kRed),
                  const SizedBox(width: 10),
                  Text(FFLocalizations.of(context).getText('od_menu_clear_all'),
                      style: const TextStyle(color: kRed)),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 6),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: _tabBtn(
                label: FFLocalizations.of(context).getText('od_tab_my_orders'),
                icon: Icons.shopping_bag_outlined,
                active: _model.activeTab == 'buyer',
                onTap: () => safeSetState(() => _model.activeTab = 'buyer'),
              ),
            ),
            Expanded(
              child: _tabBtn(
                label: FFLocalizations.of(context).getText('od_tab_received'),
                icon: Icons.storefront_outlined,
                active: _model.activeTab == 'seller',
                onTap: () => safeSetState(() => _model.activeTab = 'seller'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBtn({
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 40,
        decoration: BoxDecoration(
          color: active ? kGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: active ? Colors.white : _muted),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: active ? Colors.white : _muted,
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (currentUserUid.isEmpty) {
      return _stateMessage(
        icon: Icons.lock_outline_rounded,
        title: FFLocalizations.of(context).getText('od_please_sign_in'),
        subtitle: FFLocalizations.of(context).getText('od_sign_in_sub'),
      );
    }
    if (_loading) {
      return const Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kGreen),
            strokeWidth: 3,
          ),
        ),
      );
    }
    if (_error != null) {
      return _stateMessage(
        icon: Icons.error_outline_rounded,
        title: FFLocalizations.of(context).getText('od_could_not_load'),
        subtitle: _error!,
        iconColor: kRed,
      );
    }
    final isBuyer = _model.activeTab == 'buyer';
    final orders = _visible();
    if (orders.isEmpty) return _emptyOrdersState(isBuyer);

    return RefreshIndicator(
      color: kGreen,
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final o = orders[i];
          return Dismissible(
            key: ValueKey('order_${_s(o, ['id'])}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
              decoration: BoxDecoration(
                color: kRed,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.delete_outline_rounded,
                      color: Colors.white, size: 22),
                  const SizedBox(width: 6),
                  Text(FFLocalizations.of(context).getText('od_delete'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                ],
              ),
            ),
            confirmDismiss: (_) => _confirmDelete(),
            onDismissed: (_) => _hideOrder(o),
            child: _buildOrderCard(o, isBuyer: isBuyer),
          );
        },
      ),
    );
  }

  Future<bool> _confirmDelete() async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: _card,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Text(
                FFLocalizations.of(context).getText('od_delete_order_title'),
                style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
            content: Text(
                FFLocalizations.of(context).getText('od_delete_order_body_prefix') +
                    FFLocalizations.of(context).getText('od_this_order') +
                    FFLocalizations.of(context)
                        .getText('od_delete_order_body_mid'),
                style: TextStyle(color: _muted, fontSize: 13, height: 1.4)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(FFLocalizations.of(context).getText('od_cancel'),
                    style: TextStyle(
                        color: _muted, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(FFLocalizations.of(context).getText('od_delete'),
                    style: const TextStyle(
                        color: kRed, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _hideOrder(Map<String, dynamic> o) async {
    try {
      await OrderRepository.hide(_s(o, ['id']));
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(FFLocalizations.of(context).getText('od_order_removed')),
          backgroundColor: kGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${FFLocalizations.of(context).getText('od_could_not_delete')}$e'),
          backgroundColor: kRed,
        ),
      );
    }
  }

  Future<void> _confirmBulkClear({bool all = false}) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _card,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
            all
                ? FFLocalizations.of(context).getText('od_clear_all_title')
                : FFLocalizations.of(context)
                    .getText('od_clear_delivered_title'),
            style: TextStyle(
                color: _text, fontWeight: FontWeight.w800, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(FFLocalizations.of(context).getText('od_cancel'),
                style:
                    TextStyle(color: _muted, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(FFLocalizations.of(context).getText('od_clear'),
                style: const TextStyle(
                    color: kRed, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final isBuyer = _model.activeTab == 'buyer';
    var count = 0;
    for (final o in _visible()) {
      final status = _s(o, ['status']).toLowerCase();
      if (!all && !(status.contains('deliver') || status.contains('cancel'))) {
        continue;
      }
      try {
        await OrderRepository.hide(_s(o, ['id']));
        count++;
      } catch (_) {}
    }
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${FFLocalizations.of(context).getText('od_cleared_prefix')}$count${FFLocalizations.of(context).getText('od_cleared_suffix')}'),
        backgroundColor: kGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── ORDER CARD ─────────────────────────────────────────────
  Widget _buildOrderCard(Map<String, dynamic> o, {required bool isBuyer}) {
    final status = _statusOf(_s(o, ['status']));
    final images = (o['item_images'] is List)
        ? (o['item_images'] as List).map((e) => e.toString()).toList()
        : <String>[];
    final imageUrl = images.isNotEmpty ? images.first : '';

    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: _soft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: imageUrl.isEmpty
                      ? Icon(Icons.image_not_supported_outlined,
                          color: _muted, size: 24)
                      : Image.network(_imgUrl(imageUrl),
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                              Icons.image_not_supported_outlined,
                              color: _muted,
                              size: 24)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          valueOrDefault<String>(_s(o, ['product_name']),
                              FFLocalizations.of(context)
                                  .getText('od_product_fallback')),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: _text,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              height: 1.25)),
                      const SizedBox(height: 6),
                      Text(
                        valueOrDefault<String>(
                            formatNumber(
                                (o['price'] as num?)?.toDouble() ?? 0,
                                formatType: FormatType.decimal,
                                decimalType: DecimalType.automatic,
                                currency: 'TZS '),
                            'TZS 0'),
                        style: const TextStyle(
                            color: kGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      _counterpartyLine(o, isBuyer: isBuyer),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: _soft,
              border: Border(top: BorderSide(color: _border)),
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(15)),
            ),
            padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
            child: Row(
              children: [
                _statusBadge(status),
                const Spacer(),
                Text(
                  _d(o, ['created_at', 'date']) != null
                      ? dateTimeFormat('yMMMd', _d(o, ['created_at', 'date'])!)
                      : '',
                  style: TextStyle(color: _muted, fontSize: 11.5),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child:
                isBuyer ? _buyerActions(o) : _sellerActions(o),
          ),
        ],
      ),
    );
  }

  Widget _counterpartyLine(Map<String, dynamic> o, {required bool isBuyer}) {
    final name = isBuyer
        ? _s(o, ['seller_name'], _s(o, ['seller_id']))
        : _s(o, ['buyer_name'], _s(o, ['buyer_id']));
    if (name.isEmpty) return const SizedBox.shrink();
    return Row(
      children: [
        Icon(
          isBuyer ? Icons.storefront_outlined : Icons.person_outline_rounded,
          size: 13,
          color: _muted,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '${isBuyer ? FFLocalizations.of(context).getText('od_seller_prefix') : FFLocalizations.of(context).getText('od_buyer_prefix')}$name',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: _muted, fontSize: 12),
          ),
        ),
      ],
    );
  }

  // ── STATUS ─────────────────────────────────────────────────
  _OrderStatus _statusOf(String? raw) {
    final s = (raw ?? '').toLowerCase().trim();
    if (s.contains('cancel')) {
      return _OrderStatus(
          FFLocalizations.of(context).getText('od_status_cancelled'),
          kRed,
          Icons.cancel_outlined);
    }
    if (s.contains('deliver')) {
      return _OrderStatus(
          FFLocalizations.of(context).getText('od_status_delivered'),
          kGreen,
          Icons.check_circle_rounded);
    }
    if (s.contains('ship') || s.contains('way')) {
      return _OrderStatus(
          FFLocalizations.of(context).getText('od_status_on_way'),
          kBlue,
          Icons.local_shipping_rounded);
    }
    if (s.contains('confirm')) {
      return _OrderStatus('Confirmed', kBlue, Icons.verified_rounded);
    }
    return _OrderStatus(
        FFLocalizations.of(context).getText('od_status_pending'),
        kAmber,
        Icons.access_time_rounded);
  }

  Widget _statusBadge(_OrderStatus st) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: st.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(st.icon, color: st.color, size: 13),
          const SizedBox(width: 5),
          Text(st.label,
              style: TextStyle(
                  color: st.color,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  // ── BUYER ACTIONS ──────────────────────────────────────────
  Widget _buyerActions(Map<String, dynamic> o) {
    return Row(
      children: [
        Expanded(
          child: _outlineBtn(
            icon: Icons.chat_bubble_outline_rounded,
            label: FFLocalizations.of(context).getText('od_contact_seller'),
            onTap: () => _openChat(o),
          ),
        ),
        const SizedBox(width: 8),
        _circleIcon(
          icon: Icons.local_shipping_outlined,
          onTap: () => _openTrackingSheet(o),
        ),
      ],
    );
  }

  // ── SELLER ACTIONS ─────────────────────────────────────────
  Widget _sellerActions(Map<String, dynamic> o) {
    final status = _s(o, ['status']).toLowerCase();
    final delivered = status.contains('deliver') || status.contains('cancel');
    final next = _nextStatus(_s(o, ['status']));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_s(o, ['address']).isNotEmpty) ...[
          Container(
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 15, color: kGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_s(o, ['address']),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: _muted, fontSize: 12, height: 1.35)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        Row(
          children: [
            Expanded(
              child: _outlineBtn(
                icon: Icons.chat_bubble_outline_rounded,
                label: FFLocalizations.of(context).getText('od_message_buyer'),
                onTap: () => _openChat(o),
              ),
            ),
            const SizedBox(width: 8),
            if (!delivered)
              _circleIcon(
                icon: Icons.local_shipping_rounded,
                color: kBlue,
                onTap: () => _setStatus(o, next),
              ),
            if (!delivered) const SizedBox(width: 8),
            if (!delivered)
              _circleIcon(
                icon: Icons.cancel_outlined,
                color: kRed,
                onTap: () => _setStatus(o, 'Cancelled'),
              )
            else
              _circleIcon(
                icon: Icons.check_circle_rounded,
                color: kGreen,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(FFLocalizations.of(context)
                          .getText('od_order_completed'))));
                },
              ),
          ],
        ),
        if (!delivered) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text('Next: $next',
                style: TextStyle(color: _muted, fontSize: 11)),
          ),
        ],
      ],
    );
  }

    String _nextStatus(String current) {
    final s = current.toLowerCase().trim();
    if (s.contains('pend')) return 'confirmed';
    if (s.contains('confirm')) return 'shipped';
    return 'delivered';
  }

  String _pretty(String s) {
    switch (s.toLowerCase().trim()) {
      case 'confirmed': return 'Confirmed';
      case 'shipped': return 'On the way';
      case 'delivered': return 'Delivered';
      case 'cancelled': return 'Cancelled';
      default: return s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
    }
  }

    Future<void> _setStatus(Map<String, dynamic> o, String newStatus) async {
    final id = _s(o, ['id']);
    final pretty = _pretty(newStatus);
    try {
      await OrderRepository.updateStatus(id, newStatus);

      // Notify the buyer: in-app notification + FCM push (backend /internal/notify)
      final buyer = _s(o, ['buyer_id']);
      if (buyer.isNotEmpty && buyer != currentUserUid) {
        try {
          await zannext_api.ApiClient.post('/internal/notify', body: {
            'user_id': buyer,
            'title': 'Order update: $pretty',
            'body':
                'Your order for "${_s(o, ['product_name'], 'item')}" is now $pretty',
            'type': 'system',
            'product_id': id,
          });
        } catch (_) {}
      }

      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              '${FFLocalizations.of(context).getText('od_status_updated_prefix')}$pretty${FFLocalizations.of(context).getText('od_status_updated_suffix')}')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              '${FFLocalizations.of(context).getText('od_update_failed')}$e')));
    }
  }

  // ── CHAT ───────────────────────────────────────────────────
  Future<void> _openChat(Map<String, dynamic> o) async {
    if (currentUserUid.isEmpty) return;
    try {
      final images = (o['item_images'] is List)
          ? (o['item_images'] as List).map((e) => e.toString()).toList()
          : <String>[];
      final chat = await ChatRepository.create({
        'seller_id': _s(o, ['seller_id']),
        if (_s(o, ['product_id']).isNotEmpty)
          'product_id': _s(o, ['product_id']),
        'product_name': _s(o, ['product_name']),
        'price': (o['price'] as num?)?.toDouble() ?? 0,
        'item_images': [
          if (images.isNotEmpty) images.first,
        ],
      });
      if (!mounted) return;
      context.pushNamed(
        ChatDWidget.routeName,
        queryParameters: {
          'chatId': serializeParam(chat.id, ParamType.String),
        }.withoutNulls,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              '${FFLocalizations.of(context).getText('od_could_not_open_chat')}$e')));
    }
  }

  // ── TRACKING SHEET ─────────────────────────────────────────
  Future<void> _openTrackingSheet(Map<String, dynamic> o) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TrackingSheet(
        order: o,
        colors: _SheetColors(
          bg: _bg, card: _card, soft: _soft, text: _text,
          muted: _muted, border: _border,
        ),
      ),
    );
  }

  // ── BUTTON HELPERS ─────────────────────────────────────────
  Widget _outlineBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: kGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: kGreen, size: 15),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    color: kGreen,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _circleIcon({
    required IconData icon,
    required VoidCallback onTap,
    Color color = kGreen,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  // ── STATES ─────────────────────────────────────────────────
  Widget _emptyOrdersState(bool isBuyerTab) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    kGreen.withOpacity(0.15),
                    kGreen.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isBuyerTab
                    ? Icons.shopping_bag_outlined
                    : Icons.storefront_outlined,
                color: kGreen,
                size: 48,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              isBuyerTab
                  ? FFLocalizations.of(context).getText('od_empty_buyer_title')
                  : FFLocalizations.of(context)
                      .getText('od_empty_seller_title'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _text, fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              isBuyerTab
                  ? FFLocalizations.of(context).getText('od_empty_buyer_sub')
                  : FFLocalizations.of(context).getText('od_empty_seller_sub'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _muted, fontSize: 13.5, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stateMessage({
    required IconData icon,
    required String title,
    required String subtitle,
    Color iconColor = kGreen,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 44),
            ),
            const SizedBox(height: 20),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 13, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _OrderStatus {
  final String label;
  final Color color;
  final IconData icon;
  const _OrderStatus(this.label, this.color, this.icon);
}

class _SheetColors {
  final Color bg;
  final Color card;
  final Color soft;
  final Color text;
  final Color muted;
  final Color border;
  const _SheetColors({
    required this.bg,
    required this.card,
    required this.soft,
    required this.text,
    required this.muted,
    required this.border,
  });
}

class _TrackingSheet extends StatelessWidget {
  const _TrackingSheet({required this.order, required this.colors});

  final Map<String, dynamic> order;
  final _SheetColors colors;

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kBlue = Color(0xFF3B82F6);

  static const List<String> kFlow = [
    'Pending',
    'Confirmed',
    'On the way',
    'Delivered',
  ];

  String _s(List<String> keys, [String fb = '']) {
    for (final k in keys) {
      final v = order[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return fb;
  }

  int _statusIndex(String s) {
    final v = s.trim().toLowerCase();
    for (var i = 0; i < kFlow.length; i++) {
      if (kFlow[i].toLowerCase() == v) return i;
    }
    if (v.contains('confirm') || v == 'processing' || v == 'accepted') return 1;
    if (v.contains('ship') || v.contains('way')) return 2;
    if (v.contains('deliver') || v == 'completed') return 3;
    return 0;
  }

  ({Color color, Color deep, IconData icon, String subtitle}) _cfg(String s) {
    switch (s.trim().toLowerCase()) {
      case 'confirmed':
        return (
          color: kBlue,
          deep: const Color(0xFF0A2A6B),
          icon: Icons.verified_rounded,
          subtitle: 'Seller confirmed your order',
        );
      case 'on the way':
      case 'shipped':
        return (
          color: kAmber,
          deep: const Color(0xFF7A4A00),
          icon: Icons.delivery_dining_rounded,
          subtitle: 'Your order is on the way',
        );
      case 'delivered':
      case 'completed':
        return (
          color: kGreen,
          deep: kGreenDeep,
          icon: Icons.check_circle_rounded,
          subtitle: 'Delivered — enjoy!',
        );
      case 'cancelled':
      case 'canceled':
        return (
          color: kRed,
          deep: const Color(0xFF5A0505),
          icon: Icons.cancel_rounded,
          subtitle: 'This order was cancelled',
        );
      default:
        return (
          color: kGreen,
          deep: kGreenDeep,
          icon: Icons.hourglass_top_rounded,
          subtitle: 'Waiting for seller confirmation',
        );
    }
  }

  String _eta(String s) {
    if (s.contains('pend')) return 'Within 1–2 hours';
    if (s.contains('confirm')) return 'Within 45 minutes';
    if (s.contains('way') || s.contains('ship')) return '15–30 minutes';
    if (s.contains('deliver')) return 'Delivered';
    if (s.contains('cancel')) return 'Cancelled';
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    final status = _s(['status'], 'Pending');
    final cfg = _cfg(status);
    final idx = _statusIndex(status);
    final cancelled = status.toLowerCase().contains('cancel');
    final oid = _s(['id'], '--------');
    final shortId = oid.length > 8 ? oid.substring(0, 8) : oid;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: Container(
        color: colors.bg,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 8, 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: kGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(Icons.local_shipping_rounded,
                          color: kGreen, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              FFLocalizations.of(context).getText('ts_title'),
                              style: TextStyle(
                                  color: colors.text,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text('#${shortId.toUpperCase()}',
                              style: TextStyle(
                                  color: colors.muted,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          Icon(Icons.close_rounded, color: colors.text, size: 20),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [cfg.color, cfg.deep],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.20),
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child:
                                      Icon(cfg.icon, color: Colors.white, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          FFLocalizations.of(context)
                                              .getText('ts_current_status'),
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.75),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1.2)),
                                      const SizedBox(height: 2),
                                      Text(status.toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 0.4)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(cfg.subtitle,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 12.5)),
                            const SizedBox(height: 4),
                            Text('ETA: ${_eta(status.toLowerCase())}',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 11)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      ...List.generate(kFlow.length, (i) {
                        final done = !cancelled && i <= idx;
                        final isLast = i == kFlow.length - 1;
                        final color =
                            done ? kGreen : colors.border;
                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: done
                                          ? kGreen
                                          : colors.card,
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: color, width: 2),
                                    ),
                                    child: done
                                        ? const Icon(Icons.check_rounded,
                                            color: Colors.white, size: 13)
                                        : null,
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: (i < idx && !cancelled)
                                            ? kGreen
                                            : colors.border,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(kFlow[i],
                                          style: TextStyle(
                                              color: done
                                                  ? colors.text
                                                  : colors.muted,
                                              fontSize: 13.5,
                                              fontWeight: done
                                                  ? FontWeight.w800
                                                  : FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      if (cancelled)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.cancel_rounded,
                                  color: kRed, size: 18),
                              SizedBox(width: 8),
                              Text('This order was cancelled',
                                  style: TextStyle(
                                      color: kRed,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
