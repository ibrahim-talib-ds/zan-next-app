import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order_details_model.dart';
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
        final orders = snapshot.data!;
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
            itemBuilder: (context, i) => _buildOrderCard(
              orders[i],
              isBuyer: isBuyerTab,
            ),
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
          const SizedBox(width: 44),
        ],
      ),
    );
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
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tracking coming soon')),
            );
          },
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
