import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'order1_model.dart';
export 'order1_model.dart';

/// Live order tracking screen.
/// Shows a real-time timeline of the order status with progress,
/// seller info, driver info, and contact / cancel actions.
class Order1Widget extends StatefulWidget {
  const Order1Widget({
    super.key,
    this.orderRef,
    this.orderId,
  });

  final DocumentReference? orderRef;
  final String? orderId;

  static String routeName = 'Order1';
  static String routePath = '/order1';

  @override
  State<Order1Widget> createState() => _Order1WidgetState();
}

class _Order1WidgetState extends State<Order1Widget> {
  late Order1Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kBlue = Color(0xFF2563EB);

  /// Ordered status timeline. Anything not in this list is treated as "done".
  static const List<String> kStatusFlow = [
    'Pending',
    'Confirmed',
    'On the way',
    'Delivered',
  ];

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

  /// Read an arbitrary field from the order's raw Firestore data.
  /// Returns null if the field is missing.
  dynamic _raw(OrdersRecord o, String key) {
    try {
      final data = (o as dynamic).snapshotData;
      if (data is Map) return data[key];
    } catch (_) {}
    return null;
  }

  String _rawStr(OrdersRecord o, String key) {
    final v = _raw(o, key);
    if (v == null) return '';
    return v.toString();
  }

  List<Map<String, dynamic>> _rawHistory(OrdersRecord o) {
    final v = _raw(o, 'status_history');
    if (v is List) {
      return v
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return const [];
  }

  String _driverPhoneFrom(OrdersRecord o) {
    return _rawStr(o, 'driver_phone');
  }

  String _sellerPhoneFrom(OrdersRecord o) {
    final direct = _rawStr(o, 'seller_phone');
    if (direct.isNotEmpty) return direct;
    return _rawStr(o, 'sellerPhone');
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Order1Model());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  DocumentReference? get _ref {
    if (widget.orderRef != null) return widget.orderRef;
    final id = widget.orderId;
    if (id != null && id.isNotEmpty) {
      return OrdersRecord.collection.doc(id);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ref = _ref;
    if (ref == null) {
      return Scaffold(
        backgroundColor: _bg,
        appBar: _appBar(context, 'Order'),
        body: Center(
          child: Text('Order not found',
              style: TextStyle(color: _muted, fontSize: 14)),
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _bg,
      body: StreamBuilder<OrdersRecord>(
        stream: OrdersRecord.getDocument(ref),
        builder: (context, snap) {
          if (snap.hasError) {
            return _errorView(snap.error.toString());
          }
          if (!snap.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kGreen),
              ),
            );
          }
          final order = snap.data!;
          _model.order = order;

          return SafeArea(
            child: Column(
              children: [
                _appBar(context, 'Order #${order.reference.id.substring(0, 6).toUpperCase()}'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _statusHero(order),
                        const SizedBox(height: 18),
                        _timeline(order),
                        const SizedBox(height: 18),
                        _productCard(order),
                        const SizedBox(height: 14),
                        _deliveryCard(order),
                        const SizedBox(height: 14),
                        if (_driverPhone(order).isNotEmpty) ...[
                          _driverCard(order),
                          const SizedBox(height: 14),
                        ],
                        _actionsCard(order),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // APP BAR
  // ═══════════════════════════════════════════════════════════
  PreferredSizeWidget _appBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
        child: FlutterFlowIconButton(
          borderRadius: 10,
          buttonSize: 42,
          fillColor: _card,
          icon: Icon(Icons.arrow_back_rounded, color: _text, size: 20),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _text,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
          child: FlutterFlowIconButton(
            borderRadius: 10,
            buttonSize: 42,
            fillColor: _card,
            icon: Icon(Icons.support_agent_rounded, color: kGreen, size: 20),
            onPressed: () {
              context.pushNamed(SupportWidget.routeName);
            },
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // STATUS HERO — big colored header showing current status
  // ═══════════════════════════════════════════════════════════
  Widget _statusHero(OrdersRecord order) {
    final status = valueOrDefault<String>(order.status, 'Pending');
    final cfg = _statusConfig(status);
    final idx = _statusIndex(status);
    final progress = idx < 0 ? 0.0 : (idx + 1) / kStatusFlow.length;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cfg.color, cfg.deep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: cfg.color.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(cfg.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STATUS',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.22),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cfg.subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // TIMELINE
  // ═══════════════════════════════════════════════════════════
  Widget _timeline(OrdersRecord order) {
    final currentIdx = _statusIndex(
        valueOrDefault<String>(order.status, 'Pending'));
    final history = _rawHistory(order);

    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 14,
                decoration: BoxDecoration(
                  color: kGreen,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text('Order Timeline',
                  style: TextStyle(
                    color: _text,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  )),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(kStatusFlow.length, (i) {
            final label = kStatusFlow[i];
            final done = i <= currentIdx;
            final isNow = i == currentIdx;
            final ts = _historyTimestamp(history, label);

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: done ? kGreen : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: done ? kGreen : _border,
                            width: 2,
                          ),
                          boxShadow: isNow
                              ? [
                                  BoxShadow(
                                    color: kGreen.withOpacity(0.45),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: done
                            ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 13)
                            : null,
                      ),
                      if (i < kStatusFlow.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: i < currentIdx ? kGreen : _border,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: i < kStatusFlow.length - 1 ? 20 : 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                label,
                                style: TextStyle(
                                  color: done ? _text : _muted,
                                  fontSize: 14,
                                  fontWeight:
                                      isNow ? FontWeight.w900 : FontWeight.w700,
                                ),
                              ),
                              if (isNow) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: kGreen.withOpacity(0.14),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'NOW',
                                    style: TextStyle(
                                      color: kGreen,
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            ts != null
                                ? _formatTime(ts)
                                : (done ? 'Completed' : 'Pending'),
                            style: TextStyle(
                              color: _muted,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PRODUCT CARD
  // ═══════════════════════════════════════════════════════════
  Widget _productCard(OrdersRecord order) {
    final img = order.itemImages.isNotEmpty
        ? order.itemImages.first
        : '';
    final price = order.price;

    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(4),
            child: Image.network(
              _imgUrl(img),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  color: _muted,
                  size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valueOrDefault<String>(order.productName, 'Product'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _text,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatNumber(
                    price,
                    formatType: FormatType.decimal,
                    decimalType: DecimalType.automatic,
                    currency: 'TZS ',
                  ),
                  style: const TextStyle(
                    color: kGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // DELIVERY CARD — address + seller + notes
  // ═══════════════════════════════════════════════════════════
  Widget _deliveryCard(OrdersRecord order) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(
            icon: Icons.storefront_rounded,
            label: 'Seller',
            value: valueOrDefault<String>(_rawStr(order, 'seller_name'), 'Seller'),
          ),
          const SizedBox(height: 12),
          _row(
            icon: Icons.location_on_rounded,
            label: 'Delivering to',
            value: valueOrDefault<String>(order.address, 'Address'),
          ),
          if (_rawStr(order, 'buyer_phone').isNotEmpty) ...[
            const SizedBox(height: 12),
            _row(
              icon: Icons.phone_rounded,
              label: 'Your phone',
              value: _rawStr(order, 'buyer_phone'),
            ),
          ],
          if (_rawStr(order, 'buyer_notes').isNotEmpty) ...[
            const SizedBox(height: 12),
            _row(
              icon: Icons.sticky_note_2_rounded,
              label: 'Notes',
              value: _rawStr(order, 'buyer_notes'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: kGreen.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: kGreen, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  )),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  color: _text,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // DRIVER CARD (only if driver phone is set on order)
  // ═══════════════════════════════════════════════════════════
  String _driverPhone(OrdersRecord order) => _driverPhoneFrom(order);

  Widget _driverCard(OrdersRecord order) {
    final phone = _driverPhone(order);
    return Container(
      decoration: BoxDecoration(
        color: kBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBlue.withOpacity(0.35), width: 1.2),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: kBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delivery_dining_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your driver',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    )),
                const SizedBox(height: 3),
                Text(
                  phone,
                  style: TextStyle(
                    color: _text,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _call(phone),
            icon: const Icon(Icons.call_rounded, color: kBlue, size: 20),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ACTION BUTTONS — Call seller / Chat / Cancel
  // ═══════════════════════════════════════════════════════════
  Widget _actionsCard(OrdersRecord order) {
    final status = valueOrDefault<String>(order.status, 'Pending');
    final canCancel = status == 'Pending';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _outlineBtn(
                icon: Icons.phone_rounded,
                label: 'Call Seller',
                onTap: () => _call(_sellerPhoneFrom(order)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _outlineBtn(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Chat',
                onTap: () => _openChat(order),
              ),
            ),
          ],
        ),
        if (canCancel) ...[
          const SizedBox(height: 10),
          _outlineBtn(
            icon: Icons.cancel_outlined,
            label: _model.isCancelling ? 'Cancelling…' : 'Cancel Order',
            danger: true,
            onTap: _model.isCancelling ? null : () => _cancelOrder(order),
          ),
        ],
      ],
    );
  }

  Widget _outlineBtn({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool danger = false,
  }) {
    final color = danger ? kRed : kGreen;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.35), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════
  Future<void> _call(String phone) async {
    final p = phone.trim();
    if (p.isEmpty) {
      _snack('No phone number on file', kRed);
      return;
    }
    try {
      await launchUrl(Uri.parse('tel:$p'));
    } catch (_) {
      _snack('Could not open dialer', kRed);
    }
  }

  Future<void> _openChat(OrdersRecord order) async {
    final seller = order.seller;
    if (seller == null) {
      _snack('Seller not available', kRed);
      return;
    }
    // Create or reuse a chat with the seller
    final myRef = currentUserReference;
    if (myRef == null) return;

    try {
      final existing = await FirebaseFirestore.instance
          .collection('chats')
          .where('users', arrayContains: myRef)
          .where('users', arrayContains: seller)
          .limit(1)
          .get();

      DocumentReference chatRef;
      if (existing.docs.isNotEmpty) {
        chatRef = existing.docs.first.reference;
      } else {
        chatRef = FirebaseFirestore.instance.collection('chats').doc();
        await chatRef.set({
          'users': [myRef, seller],
          'last_message': '',
          'last_time': FieldValue.serverTimestamp(),
          'created_time': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;
      context.pushNamed(
        ChatDWidget.routeName,
        queryParameters: {
          'receiveChats':
              serializeParam(chatRef, ParamType.DocumentReference),
        }.withoutNulls,
      );
    } catch (e) {
      _snack('Could not open chat', kRed);
    }
  }

  Future<void> _cancelOrder(OrdersRecord order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Cancel order?',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
              fontSize: 17,
            )),
        content: Text(
          'This will notify the seller. You can\'t undo this.',
          style: TextStyle(color: _muted, fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Keep',
                style: TextStyle(color: _muted, fontWeight: FontWeight.w700)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel Order',
                style: TextStyle(
                    color: kRed, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    safeSetState(() => _model.isCancelling = true);

    try {
      final history = List<Map<String, dynamic>>.from(_rawHistory(order));

      history.add({
        'status': 'Cancelled',
        'timestamp': DateTime.now().toIso8601String(),
        'note': 'Cancelled by buyer',
      });

      await order.reference.update({
        'status': 'Cancelled',
        'status_history': history,
      });

      // Notify seller
      if (order.seller != null) {
        await NotificationsRecord.collection.doc().set({
          ...createNotificationsRecordData(
            title: 'Order Cancelled',
            notificationText:
                '${currentUserDisplayName} cancelled the order for "${order.productName}"',
            userRef: order.seller,
            isRead: false,
            date: getCurrentTimestamp,
            createdTime: getCurrentTimestamp,
            avater: currentUserPhoto,
            productId: order.productRef?.id ?? '',
          ),
        });
      }

      if (!mounted) return;
      safeSetState(() => _model.isCancelling = false);
      _snack('Order cancelled', kGreen);
    } catch (e) {
      if (!mounted) return;
      safeSetState(() => _model.isCancelling = false);
      _snack('Failed to cancel: $e', kRed);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════
  int _statusIndex(String status) {
    final s = status.trim().toLowerCase();
    for (var i = 0; i < kStatusFlow.length; i++) {
      if (kStatusFlow[i].toLowerCase() == s) return i;
    }
    // Aliases
    if (s == 'processing' || s == 'accepted') return 1;
    if (s == 'on the way' || s == 'on_the_way' || s == 'shipped') return 2;
    if (s == 'delivered' || s == 'completed') return 3;
    if (s == 'cancelled' || s == 'canceled') return -1;
    return 0;
  }

  ({Color color, Color deep, IconData icon, String subtitle}) _statusConfig(
      String status) {
    switch (status.trim().toLowerCase()) {
      case 'confirmed':
        return (
          color: kBlue,
          deep: const Color(0xFF0A2A6B),
          icon: Icons.verified_rounded,
          subtitle: 'Seller confirmed your order',
        );
      case 'on the way':
      case 'on_the_way':
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
      case 'pending':
      default:
        return (
          color: kGreen,
          deep: kGreenDeep,
          icon: Icons.hourglass_top_rounded,
          subtitle: 'Waiting for seller confirmation',
        );
    }
  }

  DateTime? _historyTimestamp(
      List<Map<String, dynamic>> history, String label) {
    for (final h in history) {
      final s = (h['status'] ?? '').toString().trim().toLowerCase();
      if (s == label.toLowerCase()) {
        final ts = h['timestamp'];
        if (ts is String) {
          return DateTime.tryParse(ts);
        }
      }
    }
    return null;
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  void _snack(String msg, Color bg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _errorView(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, color: kRed, size: 44),
            const SizedBox(height: 12),
            Text('Something went wrong',
                style: TextStyle(
                  color: _text,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                )),
            const SizedBox(height: 6),
            Text(msg,
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 12.5)),
          ],
        ),
      ),
    );
  }
}
