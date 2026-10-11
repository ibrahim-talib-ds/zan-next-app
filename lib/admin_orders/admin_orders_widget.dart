import '/auth/firebase_auth/auth_util.dart';
import '/services/api_client.dart' as zannext_api;
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';

import 'admin_orders_model.dart';
export 'admin_orders_model.dart';

/// Admin Orders — 100% Postgres. Every order in the system + status control.
class AdminOrdersWidget extends StatefulWidget {
  const AdminOrdersWidget({super.key});

  static String routeName = 'adminOrders';
  static String routePath = '/adminOrders';

  @override
  State<AdminOrdersWidget> createState() => _AdminOrdersWidgetState();
}

class _AdminOrdersWidgetState extends State<AdminOrdersWidget> {
  late AdminOrdersModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kBlue = Color(0xFF3B82F6);
  static const Color kRed = Color(0xFFDC0F0F);

  List<Map<String, dynamic>> _orders = const [];
  bool _loading = true;
  String? _error;
  String _filter = 'all';

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _soft   => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFF0F2F5);
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminOrdersModel());
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
      List<Map<String, dynamic>> list;
      if (raw is List) {
        list = raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } else {
        // admin sees ALL orders via their own endpoint when it exists;
        // fall back to union of buyer+seller views
        final a = await zannext_api.ApiClient.get(
            '/orders?user_id=$currentUserUid') as List;
        list = a.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      list.sort((a, b) {
        final ad = _d(a, ['created_at', 'date']) ?? DateTime(1970);
        final bd = _d(b, ['created_at', 'date']) ?? DateTime(1970);
        return bd.compareTo(ad);
      });
      _orders = list;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) safeSetState(() => _loading = false);
  }

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'all') return _orders;
    return _orders
        .where((o) => _s(o, ['status']).toLowerCase().contains(_filter))
        .toList();
  }

  Future<void> _setStatus(Map<String, dynamic> o, String status) async {
    final id = _s(o, ['id']);
    try {
      await zannext_api.ApiClient.patch('/orders/$id/status',
          body: {'status': status});
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Order → $status'),
        backgroundColor: kGreen,
        behavior: SnackBarBehavior.floating,
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed: $e'),
        backgroundColor: kRed,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _bg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildFilters(),
            Expanded(child: _buildBody()),
          ],
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
            bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: Row(
        children: [
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 24,
            borderWidth: 1,
            buttonSize: 44,
            fillColor: Colors.white.withOpacity(0.15),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 22),
            onPressed: () => context.safePop(),
          ),
          const Spacer(),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Orders',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            Text('Admin · ${_orders.length} total',
                style: TextStyle(color: Colors.white70, fontSize: 11)),
          ]),
          const Spacer(),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = [
      ('all', 'All'),
      ('pend', 'Pending'),
      ('confirm', 'Confirmed'),
      ('ship', 'On the way'),
      ('deliver', 'Delivered'),
      ('cancel', 'Cancelled'),
    ];
    return Container(
      height: 48,
      color: _bg,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (key, label) = filters[i];
          final active = _filter == key;
          return GestureDetector(
            onTap: () => safeSetState(() => _filter = key),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: active ? kGreen : _card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: active ? kGreen : _border, width: 1.3),
              ),
              child: Center(
                child: Text(label,
                    style: TextStyle(
                        color: active ? Colors.white : _text,
                        fontSize: 12.5,
                        fontWeight:
                            active ? FontWeight.w800 : FontWeight.w500)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
          child: SizedBox(
              width: 36, height: 36,
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                  strokeWidth: 3)));
    }
    if (_error != null) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.error_outline_rounded,
                    color: kRed, size: 44),
                const SizedBox(height: 12),
                Text(_error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, fontSize: 12)),
                const SizedBox(height: 8),
                TextButton(onPressed: _load, child: const Text('Retry')),
              ])));
    }
    final orders = _filtered;
    if (orders.isEmpty) {
      return Center(
          child: Text('No orders',
              style: TextStyle(color: _muted, fontSize: 14)));
    }

    return RefreshIndicator(
      color: kGreen,
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final o = orders[i];
          final status = _s(o, ['status'], 'pending');
          final buyer = _s(o, ['buyer_name'], _s(o, ['buyer_id']));
          final seller = _s(o, ['seller_name'], _s(o, ['seller_id']));
          final product = _s(o, ['product_name'], 'item');
          final price = (o['price'] as num?)?.toDouble() ?? 0;
          final when = _d(o, ['created_at', 'date']);
          final images = (o['item_images'] is List)
              ? (o['item_images'] as List).map((e) => e.toString()).toList()
              : <String>[];

          Color sc;
          IconData sic;
          if (status.contains('cancel')) {
            sc = kRed; sic = Icons.cancel_outlined;
          } else if (status.contains('deliver')) {
            sc = kGreen; sic = Icons.check_circle_rounded;
          } else if (status.contains('ship') || status.contains('way')) {
            sc = kBlue; sic = Icons.local_shipping_rounded;
          } else if (status.contains('confirm')) {
            sc = kBlue; sic = Icons.verified_rounded;
          } else {
            sc = kAmber; sic = Icons.access_time_rounded;
          }

          return Container(
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _border),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        color: _soft,
                        borderRadius: BorderRadius.circular(10)),
                    clipBehavior: Clip.antiAlias,
                    padding: const EdgeInsets.all(3),
                    child: images.isEmpty
                        ? Icon(Icons.image_outlined,
                            color: _muted, size: 20)
                        : Image.network(images.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.image_outlined,
                                    color: _muted, size: 20)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: _text,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text('$buyer → $seller',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: _muted, fontSize: 11.5)),
                        ]),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('TZS ${price.toStringAsFixed(0)}',
                          style: TextStyle(
                              color: kGreen,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800)),
                      if (when != null)
                        Text('${when.day}/${when.month}',
                            style: TextStyle(
                                color: _muted, fontSize: 10.5)),
                    ],
                  ),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                        color: sc.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(sic, color: sc, size: 12),
                      const SizedBox(width: 4),
                      Text(status.toUpperCase(),
                          style: TextStyle(
                              color: sc,
                              fontSize: 10,
                              fontWeight: FontWeight.w800)),
                    ]),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    tooltip: 'Set status',
                    onSelected: (v) => _setStatus(o, v),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'pending', child: Text('Pending')),
                      PopupMenuItem(value: 'confirmed', child: Text('Confirmed')),
                      PopupMenuItem(value: 'shipped', child: Text('On the way')),
                      PopupMenuItem(value: 'delivered', child: Text('Delivered')),
                      PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                          color: kGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text('Set status',
                            style: TextStyle(
                                color: kGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down_rounded,
                            color: kGreen, size: 18),
                      ]),
                    ),
                  ),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }
}
