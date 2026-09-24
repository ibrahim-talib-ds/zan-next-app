import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order_details_model.dart';
import '/services/notification_sender.dart';
export 'order_details_model.dart';

class OrderDetailsWidget extends StatefulWidget {
  const OrderDetailsWidget({
    super.key,
    this.initialTab,
  });

  /// 'buyer' or 'seller'. Defaults to 'buyer'.
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderDetailsModel());
    _model.activeTab = widget.initialTab ?? 'buyer';
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════
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
              // Check if user has seller orders to decide if we show tabs
              if (currentUserReference != null)
                StreamBuilder<List<OrdersRecord>>(
                  stream: queryOrdersRecord(
                    queryBuilder: (q) => q.where(
                      'seller',
                      isEqualTo: currentUserReference,
                    ),
                    limit: 1,
                  ),
                  builder: (context, snap) {
                    final hasSellerOrders =
                        (snap.data ?? const []).isNotEmpty;
                    return _buildTabs(showSellerTab: hasSellerOrders);
                  },
                ),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (currentUserReference == null) {
      return _stateMessage(
        icon: Icons.lock_outline_rounded,
        title: 'Please sign in',
        subtitle: 'You need to sign in to see your orders.',
      );
    }

    final isBuyerTab = _model.activeTab == 'buyer';

    return StreamBuilder<List<OrdersRecord>>(
      stream: queryOrdersRecord(
        queryBuilder: (q) => isBuyerTab
            ? q
                .where('buyer', isEqualTo: currentUserReference)
                .orderBy('date', descending: true)
            : q
                .where('seller', isEqualTo: currentUserReference)
                .orderBy('date', descending: true),
        limit: 100,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _stateMessage(
            icon: Icons.error_outline_rounded,
            title: 'Could not load orders',
            subtitle: '${snapshot.error}',
            iconColor: kRed,
          );
        }
        if (!snapshot.hasData) {
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
        final hiddenField =
            isBuyerTab ? 'hidden_for_buyer' : 'hidden_for_seller';
        final orders = snapshot.data!.where((o) {
          try {
            final data = (o as dynamic).snapshotData;
            if (data is Map) {
              return data[hiddenField] != true;
            }
          } catch (_) {}
          return true;
        }).toList();

        if (orders.isEmpty) {
          return _stateMessage(
            icon: isBuyerTab
                ? Icons.shopping_bag_outlined
                : Icons.storefront_outlined,
            title: isBuyerTab
                ? 'No orders yet'
                : 'No incoming orders yet',
            subtitle: isBuyerTab
                ? 'Your purchases will appear here.'
                : 'When buyers order your products, they will show up here.',
          );
        }

        return RefreshIndicator(
          color: kGreen,
          onRefresh: () async => safeSetState(() {}),
          child: ListView.separated(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final order = orders[i];
              return Dismissible(
                key: ValueKey('order_${order.reference.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                  decoration: BoxDecoration(
                    color: kRed,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete_outline_rounded,
                          color: Colors.white, size: 22),
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
                confirmDismiss: (_) => _confirmDeleteOrder(order),
                onDismissed: (_) => _deleteOrder(order),
                child: _buildOrderCard(order, isBuyer: isBuyerTab),
              );
            },
          ),
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
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Orders',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Buyer & Seller',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded,
                color: Colors.white, size: 22),
            onSelected: (v) {
              if (v == 'clear_delivered') _confirmClearDelivered();
              if (v == 'clear_cancelled') _confirmClearCancelled();
              if (v == 'clear_all') _confirmClearAllOrders();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'clear_delivered',
                child: Row(
                  children: [
                    Icon(Icons.done_all_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Clear delivered'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear_cancelled',
                child: Row(
                  children: [
                    Icon(Icons.cancel_outlined, size: 18),
                    SizedBox(width: 10),
                    Text('Clear cancelled'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded,
                        size: 18, color: kRed),
                    SizedBox(width: 10),
                    Text('Clear all',
                        style: TextStyle(color: kRed)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // DELETE HELPERS
  // ═══════════════════════════════════════════════════════════
  Future<bool> _confirmDeleteOrder(OrdersRecord order) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: _card,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Text('Delete order?',
                style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
            content: Text(
              '"${order.productName ?? "This order"}" will be removed from your list. The other party still sees it.',
              style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Cancel',
                    style: TextStyle(
                        color: _muted, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete',
                    style: TextStyle(
                        color: kRed, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteOrder(OrdersRecord order) async {
    try {
      // Soft delete: hide for this user only
      final isBuyer = order.buyer == currentUserReference;
      final field =
          isBuyer ? 'hidden_for_buyer' : 'hidden_for_seller';
      await order.reference.update({field: true});

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Order removed from your list'),
          backgroundColor: kGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      safeSetState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not delete: $e'),
          backgroundColor: kRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _confirmClearDelivered() async {
    final ok = await _confirmBulk('Clear delivered orders?',
        'All delivered orders will be removed from your list.');
    if (ok) await _bulkHide(statuses: ['delivered']);
  }

  Future<void> _confirmClearCancelled() async {
    final ok = await _confirmBulk('Clear cancelled orders?',
        'All cancelled orders will be removed from your list.');
    if (ok) await _bulkHide(statuses: ['cancelled']);
  }

  Future<void> _confirmClearAllOrders() async {
    final ok = await _confirmBulk('Clear all orders?',
        'Every order in this tab will be removed from your list. The other party still sees them.');
    if (ok) await _bulkHide(statuses: null);
  }

  Future<bool> _confirmBulk(String title, String body) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: _card,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Text(title,
                style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
            content: Text(body,
                style: TextStyle(color: _muted, fontSize: 13, height: 1.4)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Cancel',
                    style: TextStyle(
                        color: _muted, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Clear',
                    style: TextStyle(
                        color: kRed, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _bulkHide({required List<String>? statuses}) async {
    if (currentUserReference == null) return;
    final isBuyerTab = _model.activeTab == 'buyer';
    try {
      final q = await FirebaseFirestore.instance
          .collection('orders')
          .where(isBuyerTab ? 'buyer' : 'seller',
              isEqualTo: currentUserReference)
          .get();

      int count = 0;
      final batch = FirebaseFirestore.instance.batch();
      final field =
          isBuyerTab ? 'hidden_for_buyer' : 'hidden_for_seller';

      for (final doc in q.docs) {
        final data = doc.data();
        final status =
            (data['status'] ?? '').toString().toLowerCase();
        if (statuses != null) {
          final matches = statuses.any((s) => status.contains(s));
          if (!matches) continue;
        }
        batch.update(doc.reference, {field: true});
        count++;
      }
      await batch.commit();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cleared $count order(s)'),
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
          backgroundColor: kRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // TABS
  // ═══════════════════════════════════════════════════════════
  Widget _buildTabs({required bool showSellerTab}) {
    // If no seller orders, force buyer tab — no need to switch
    if (!showSellerTab) return const SizedBox(height: 8);

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
                label: 'My Orders',
                icon: Icons.shopping_bag_outlined,
                active: _model.activeTab == 'buyer',
                onTap: () => safeSetState(() => _model.activeTab = 'buyer'),
              ),
            ),
            Expanded(
              child: _tabBtn(
                label: 'Received',
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
            Icon(
              icon,
              size: 15,
              color: active ? Colors.white : _muted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : _muted,
                fontSize: 13,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ORDER CARD
  // ═══════════════════════════════════════════════════════════
  Widget _buildOrderCard(OrdersRecord order, {required bool isBuyer}) {
    final status = _statusOf(order.status);
    final imageUrl = order.itemImages.isNotEmpty
        ? order.itemImages.first
        : '';

    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          // ── Row 1: product info ──
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
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
                      : Image.network(
                          _imgUrl(imageUrl),
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.image_not_supported_outlined,
                            color: _muted,
                            size: 24,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                // Text info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        valueOrDefault<String>(
                            order.productName, 'Product'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _text,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        valueOrDefault<String>(
                          formatNumber(
                            order.price,
                            formatType: FormatType.decimal,
                            decimalType: DecimalType.automatic,
                            currency: 'TZS ',
                          ),
                          'TZS 0',
                        ),
                        style: const TextStyle(
                          color: kGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Counterparty line
                      _counterpartyLine(order, isBuyer: isBuyer),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Row 2: status bar ──
          Container(
            decoration: BoxDecoration(
              color: _soft,
              border: Border(
                top: BorderSide(color: _border),
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
            child: Row(
              children: [
                _statusBadge(status),
                const Spacer(),
                Text(
                  order.date != null
                      ? dateTimeFormat('yMMMd', order.date!)
                      : '',
                  style: TextStyle(color: _muted, fontSize: 11.5),
                ),
              ],
            ),
          ),

          // ── Row 3: actions (different per role) ──
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: isBuyer
                ? _buyerActions(order)
                : _sellerActions(order),
          ),
        ],
      ),
    );
  }

  Widget _counterpartyLine(OrdersRecord order, {required bool isBuyer}) {
    // For buyer: show seller name. For seller: show buyer name.
    final ref = isBuyer ? order.seller : order.buyer;
    if (ref == null) return const SizedBox.shrink();

    return FutureBuilder<UsersRecord?>(
      future: _getUser(ref),
      builder: (context, snap) {
        final name = snap.data?.displayName ?? '';
        if (name.isEmpty) return const SizedBox.shrink();
        return Row(
          children: [
            Icon(
              isBuyer
                  ? Icons.storefront_outlined
                  : Icons.person_outline_rounded,
              size: 13,
              color: _muted,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                isBuyer ? 'Seller: $name' : 'Buyer: $name',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: _muted, fontSize: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<UsersRecord?> _getUser(DocumentReference? ref) async {
    if (ref == null) return null;
    try {
      final snap = await ref.get();
      if (snap.exists) return UsersRecord.fromSnapshot(snap);
    } catch (_) {}
    return null;
  }

  // ═══════════════════════════════════════════════════════════
  // STATUS
  // ═══════════════════════════════════════════════════════════
  _OrderStatus _statusOf(String? raw) {
    final s = (raw ?? '').toLowerCase().trim();
    if (s.contains('deliver')) {
      return _OrderStatus('Delivered', kGreen, Icons.check_circle_rounded);
    }
    if (s.contains('ship') || s.contains('way')) {
      return _OrderStatus('On the way', kBlue, Icons.local_shipping_rounded);
    }
    if (s.contains('cancel')) {
      return _OrderStatus('Cancelled', kRed, Icons.cancel_outlined);
    }
    if (s.contains('return')) {
      return _OrderStatus('Returned', _muted, Icons.replay_rounded);
    }
    return _OrderStatus('Pending', kAmber, Icons.access_time_rounded);
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
          Text(
            st.label,
            style: TextStyle(
              color: st.color,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ACTIONS — BUYER
  // ═══════════════════════════════════════════════════════════
  Widget _buyerActions(OrdersRecord order) {
    return Row(
      children: [
        Expanded(
          child: _outlineBtn(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Contact Seller',
            onTap: () => _openChatWith(order.seller, order),
          ),
        ),
        const SizedBox(width: 8),
        _circleIcon(
          icon: Icons.local_shipping_outlined,
          onTap: () => _openTrackingSheet(order),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ACTIONS — SELLER
  // ═══════════════════════════════════════════════════════════
  Widget _sellerActions(OrdersRecord order) {
    final status = _statusOf(order.status);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Buyer address if present
        if (order.address.isNotEmpty) ...[
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
                  child: Text(
                    order.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _muted,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Quick status updates
        Row(
          children: [
            Expanded(
              child: _outlineBtn(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Message Buyer',
                onTap: () => _openChatWith(order.buyer, order),
              ),
            ),
            const SizedBox(width: 8),
            if (status.label == 'Pending' || status.label == 'On the way')
              _circleIcon(
                icon: Icons.local_shipping_rounded,
                color: kBlue,
                onTap: () => _advanceStatus(order, status),
              )
            else
              _circleIcon(
                icon: Icons.check_circle_rounded,
                color: kGreen,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order completed')),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _advanceStatus(
      OrdersRecord order, _OrderStatus current) async {
    String newStatus;
    if (current.label == 'Pending') {
      newStatus = 'On the way';
    } else if (current.label == 'On the way') {
      newStatus = 'Delivered';
    } else {
      newStatus = current.label;
    }

    try {
      await order.reference.update({'status': newStatus});

      // 🔔 Push notify the buyer
      await NotificationSender.sendToUser(
        userRef: order.buyer,
        title: 'Order Update: $newStatus',
        body: 'Your order for "${order.productName}" is now $newStatus',
        data: {
          'route': 'Order_details',
          'orderId': order.reference.id,
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to "$newStatus"')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // CHAT
  // ═══════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════
  // TRACKING BOTTOM SHEET
  // ═══════════════════════════════════════════════════════════
  Future<void> _openTrackingSheet(OrdersRecord order) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TrackingSheet(
        order: order,
        colors: _SheetColors(
          bg: _bg,
          card: _card,
          soft: _soft,
          text: _text,
          muted: _muted,
          border: _border,
          isDark: _isDark,
        ),
      ),
    );
  }

  Future<void> _openChatWith(
      DocumentReference? otherRef, OrdersRecord order) async {
    if (otherRef == null || currentUserReference == null) return;
    try {
      final existing = await FirebaseFirestore.instance
          .collection('Chats')
          .where('users', arrayContains: currentUserReference)
          .where('product_ref', isEqualTo: order.productRef)
          .limit(1)
          .get();

      DocumentReference chatRef;
      if (existing.docs.isNotEmpty) {
        chatRef = existing.docs.first.reference;
      } else {
        final newDoc = ChatsRecord.collection.doc();
        await newDoc.set({
          ...createChatsRecordData(
            lastMessage: 'Hi, about your order',
            lastMessageTime: getCurrentTimestamp,
            productRef: order.productRef,
            buyerRef: order.buyer,
            sellerRef: order.seller,
            productName: order.productName,
            price: order.price,
          ),
          ...mapToFirestore({
            'users': [currentUserReference!, otherRef],
            'User_name': [currentUserDisplayName, ''],
            'items_images': [
              order.itemImages.isNotEmpty ? order.itemImages.first : ''
            ],
          }),
        });
        chatRef = newDoc;
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open chat: $e')),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // BUTTON HELPERS
  // ═══════════════════════════════════════════════════════════
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
            Text(
              label,
              style: const TextStyle(
                color: kGreen,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
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

  // ═══════════════════════════════════════════════════════════
  // STATE MESSAGE
  // ═══════════════════════════════════════════════════════════
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
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _text,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13, height: 1.5),
            ),
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

// ═══════════════════════════════════════════════════════════
// TRACKING SHEET — a modal bottom sheet with live timeline
// ═══════════════════════════════════════════════════════════
class _SheetColors {
  final Color bg;
  final Color card;
  final Color soft;
  final Color text;
  final Color muted;
  final Color border;
  final bool isDark;
  const _SheetColors({
    required this.bg,
    required this.card,
    required this.soft,
    required this.text,
    required this.muted,
    required this.border,
    required this.isDark,
  });
}

class _TrackingSheet extends StatelessWidget {
  const _TrackingSheet({required this.order, required this.colors});

  final OrdersRecord order;
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

  int _statusIndex(String s) {
    final v = s.trim().toLowerCase();
    for (var i = 0; i < kFlow.length; i++) {
      if (kFlow[i].toLowerCase() == v) return i;
    }
    if (v == 'processing' || v == 'accepted') return 1;
    if (v == 'way' || v.contains('ship') || v.contains('on the')) return 2;
    if (v == 'delivered' || v == 'completed') return 3;
    return 0;
  }

  ({Color color, Color deep, IconData icon, String subtitle}) _cfg(
      String s) {
    switch (s.trim().toLowerCase()) {
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

  String _eta(String s) {
    if (s.contains('pending')) return 'Within 1–2 hours';
    if (s.contains('confirm')) return 'Within 45 minutes';
    if (s.contains('way') || s.contains('ship')) return '15–30 minutes';
    if (s.contains('deliver')) return 'Delivered';
    if (s.contains('cancel')) return 'Cancelled';
    return '—';
  }

  String _fmtTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ap = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ap';
  }

  @override
  Widget build(BuildContext context) {
    final status = order.status ?? 'Pending';
    final cfg = _cfg(status);
    final idx = _statusIndex(status);
    final progress = ((idx + 1) / kFlow.length).clamp(0.0, 1.0);

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
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header row
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
                            'Track Order',
                            style: TextStyle(
                              color: colors.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '#${order.reference.id.substring(0, 8).toUpperCase()}',
                            style: TextStyle(
                              color: colors.muted,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close_rounded,
                          color: colors.text, size: 20),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Status hero ───
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [cfg.color, cfg.deep],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: cfg.color.withOpacity(0.30),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
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
                                  child: Icon(cfg.icon,
                                      color: Colors.white, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'CURRENT STATUS',
                                        style: TextStyle(
                                          color:
                                              Colors.white.withOpacity(0.75),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        status.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 7,
                                backgroundColor:
                                    Colors.white.withOpacity(0.22),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cfg.subtitle,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.92),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ─── ETA card ───
                      if (idx >= 0 && idx < 3)
                        Container(
                          decoration: BoxDecoration(
                            color: kGreen.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: kGreen.withOpacity(0.25),
                                width: 1.2),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: kGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                    Icons.access_time_filled_rounded,
                                    color: Colors.white,
                                    size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ESTIMATED ARRIVAL',
                                      style: TextStyle(
                                        color: colors.muted,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      _eta(status),
                                      style: const TextStyle(
                                        color: kGreen,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (idx >= 0 && idx < 3)
                        const SizedBox(height: 14),

                      // ─── Timeline ───
                      Container(
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colors.border),
                        ),
                        padding: const EdgeInsets.all(14),
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
                                Text(
                                  'Order Timeline',
                                  style: TextStyle(
                                    color: colors.text,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...List.generate(kFlow.length, (i) {
                              final label = kFlow[i];
                              final done = i <= idx;
                              final isNow = i == idx;
                              return IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: done
                                                ? kGreen
                                                : Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: done
                                                  ? kGreen
                                                  : colors.border,
                                              width: 2,
                                            ),
                                            boxShadow: isNow
                                                ? [
                                                    BoxShadow(
                                                      color: kGreen
                                                          .withOpacity(0.45),
                                                      blurRadius: 8,
                                                      spreadRadius: 1,
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: done
                                              ? const Icon(
                                                  Icons.check_rounded,
                                                  color: Colors.white,
                                                  size: 13)
                                              : null,
                                        ),
                                        if (i < kFlow.length - 1)
                                          Expanded(
                                            child: Container(
                                              width: 2,
                                              color: i < idx
                                                  ? kGreen
                                                  : colors.border,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: i < kFlow.length - 1
                                              ? 18
                                              : 0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  label,
                                                  style: TextStyle(
                                                    color: done
                                                        ? colors.text
                                                        : colors.muted,
                                                    fontSize: 13.5,
                                                    fontWeight: isNow
                                                        ? FontWeight.w900
                                                        : FontWeight.w700,
                                                  ),
                                                ),
                                                if (isNow) ...[
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 7,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: kGreen
                                                          .withOpacity(0.14),
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(6),
                                                    ),
                                                    child: const Text(
                                                      'NOW',
                                                      style: TextStyle(
                                                        color: kGreen,
                                                        fontSize: 9.5,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        letterSpacing: 0.6,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              done
                                                  ? (isNow
                                                      ? 'In progress'
                                                      : 'Completed')
                                                  : 'Pending',
                                              style: TextStyle(
                                                color: colors.muted,
                                                fontSize: 11,
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
                      ),

                      const SizedBox(height: 14),

                      // ─── Product card ───
                      Container(
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colors.border),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: colors.soft,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: order.itemImages.isNotEmpty
                                  ? Image.network(
                                      order.itemImages.first,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => Icon(
                                        Icons.image_not_supported_outlined,
                                        color: colors.muted,
                                        size: 20,
                                      ),
                                    )
                                  : Icon(
                                      Icons.image_not_supported_outlined,
                                      color: colors.muted,
                                      size: 20,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.productName ?? 'Product',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: colors.text,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatNumber(
                                      order.price,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.automatic,
                                      currency: 'TZS ',
                                    ),
                                    style: const TextStyle(
                                      color: kGreen,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ─── Delivery address ───
                      if (order.address.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: colors.card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: colors.border),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: kGreen.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: const Icon(
                                    Icons.location_on_rounded,
                                    color: kGreen,
                                    size: 16),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'DELIVERING TO',
                                      style: TextStyle(
                                        color: colors.muted,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      order.address,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: colors.text,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 14),

                      // ─── Close button ───
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: kGreen,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: kGreen.withOpacity(0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
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
