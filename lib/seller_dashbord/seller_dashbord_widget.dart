import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'seller_dashbord_model.dart';
export 'seller_dashbord_model.dart';

/// Seller Dashboard / Public Seller Profile.
///
/// Two modes:
///  * OWNER — the signed-in user is the seller. Shows full management:
///    stats, quick actions, edit/delete on each product.
///  * VISITOR — a buyer viewing another seller's shop. Shows the public
///    profile: avatar, rating, product grid, chat button. No management UI.
class SellerDashbordWidget extends StatefulWidget {
  const SellerDashbordWidget({
    super.key,
    this.sellerRef,
  });

  /// If null → we assume the current user is the seller (owner mode).
  /// If set → we show the public profile of that seller (visitor mode).
  final DocumentReference? sellerRef;

  static String routeName = 'Seller_Dashbord';
  static String routePath = '/sellerDashbord';

  @override
  State<SellerDashbordWidget> createState() => _SellerDashbordWidgetState();
}

class _SellerDashbordWidgetState extends State<SellerDashbordWidget> {
  late SellerDashbordModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Brand
  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kBlue = Color(0xFF3B82F6);
  static const Color kPurple = Color(0xFFAB47D0);
  static const Color kOrange = Color(0xFFF59E0B);
  static const Color kRed = Color(0xFFDC0F0F);

  // Dark-first palette (since app is in dark mode)
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

  // The seller we're looking at — either the explicit ref or the current user
  DocumentReference? get _sellerRef =>
      widget.sellerRef ?? currentUserReference;

  // Are we the seller?
  bool get _isOwner {
    if (currentUserReference == null) return false;
    if (widget.sellerRef == null) return true;
    return widget.sellerRef == currentUserReference;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SellerDashbordModel());
    _model.isOwner = _isOwner;
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
    if (_sellerRef == null) {
      return _scaffold(
        body: _stateMessage(
          icon: Icons.person_off_outlined,
          title: 'No seller',
          subtitle: 'This seller could not be found.',
        ),
      );
    }

    return _scaffold(
      body: StreamBuilder<UsersRecord>(
        stream: UsersRecord.getDocument(_sellerRef!),
        builder: (context, userSnap) {
          final seller = userSnap.data;

          return StreamBuilder<List<InventoryRecord>>(
            stream: queryInventoryRecord(
              queryBuilder: (r) => r.where(
                'sellers_ref',
                isEqualTo: _sellerRef,
              ),
              limit: 100,
            ),
            builder: (context, invSnap) {
              final products = invSnap.data ?? const <InventoryRecord>[];

              return RefreshIndicator(
                color: kGreen,
                onRefresh: () async => safeSetState(() {}),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroHeader(seller, products),
                      if (_isOwner) ...[
                        const SizedBox(height: 16),
                        _buildOwnerStats(products),
                        const SizedBox(height: 20),
                        _buildOwnerQuickActions(),
                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          'My Products',
                          trailing: '${products.length}',
                        ),
                      ] else ...[
                        const SizedBox(height: 20),
                        _buildVisitorActions(seller),
                        const SizedBox(height: 20),
                        _buildSellerHighlights(seller, products),
                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          'Shop',
                          trailing: '${products.length} items',
                        ),
                      ],
                      const SizedBox(height: 12),
                      _buildProductGrid(products),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _scaffold({required Widget body}) {
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
          bottom: false,
          child: body,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HERO HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _buildHeroHeader(UsersRecord? seller, List<InventoryRecord> products) {
    final topPad = MediaQuery.of(context).padding.top;
    final photo = _imgUrl(seller?.photoUrl);
    final name = seller?.displayName ?? (_isOwner ? 'My Shop' : 'Seller');
    final city = seller?.city ?? '';
    final rating = _avgRating(products);
    final totalReviews = products.fold<int>(0, (s, p) => s + p.reviews);

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(0, topPad + 8, 0, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreen, kGreenDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Top row — back / title / menu
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 12, 0),
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
                Text(
                  _isOwner ? 'My Shop' : 'Seller',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 44),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Avatar + name + city + rating
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Avatar with verified ring
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.white, Color(0x80FFFFFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(2.5),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: kGreenDeep,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(
                      child: photo.isEmpty
                          ? const Icon(Icons.person_rounded,
                              color: Colors.white70, size: 32)
                          : Image.network(
                              photo,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person_rounded,
                                color: Colors.white70,
                                size: 32,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Name + city + rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Verified badge
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: kAmber,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_rounded,
                                color: Colors.white, size: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: Colors.white70, size: 14),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              city.isNotEmpty ? city : 'Zanzibar',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Rating chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: kAmber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '· $totalReviews reviews',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _avgRating(List<InventoryRecord> products) {
    if (products.isEmpty) return 0;
    final total = products.fold<double>(0, (s, p) => s + p.rating);
    return total / products.length;
  }

  // ═══════════════════════════════════════════════════════════
  // OWNER: STATS ROW
  // ═══════════════════════════════════════════════════════════
  Widget _buildOwnerStats(List<InventoryRecord> products) {
    // Compute view count from products
    final totalViews =
        products.fold<int>(0, (s, p) => s + p.viewCount);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _statCard(
                  icon: Icons.attach_money_rounded,
                  color: kAmber,
                  label: 'Revenue',
                  value: 'TZS 0',
                  hint: 'This month',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FutureBuilder<int>(
                  future: queryOrdersRecordCount(
                    queryBuilder: (q) => q.where(
                      'seller',
                      isEqualTo: currentUserReference,
                    ),
                  ),
                  builder: (context, snap) {
                    return _statCard(
                      icon: Icons.shopping_bag_outlined,
                      color: kBlue,
                      label: 'Orders',
                      value: '${snap.data ?? 0}',
                      hint: 'All time',
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _statCard(
                  icon: Icons.inventory_2_outlined,
                  color: kOrange,
                  label: 'Products',
                  value: '${products.length}',
                  hint: 'Listed by you',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard(
                  icon: Icons.visibility_outlined,
                  color: kPurple,
                  label: 'Views',
                  value: formatNumber(totalViews,
                      formatType: FormatType.compact),
                  hint: 'All products',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    String? hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: color, size: 17),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _text,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 2),
            Text(
              hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: _muted, fontSize: 10.5),
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // OWNER: QUICK ACTIONS
  // ═══════════════════════════════════════════════════════════
  Widget _buildOwnerQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _quickAction(
              icon: Icons.add_circle_outline_rounded,
              color: kGreen,
              label: 'Add Product',
              onTap: () => context.pushNamed(SelectAdWidget.routeName),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _quickAction(
              icon: Icons.list_alt_rounded,
              color: kBlue,
              label: 'My Products',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Scroll down to see your products'),
                  duration: Duration(seconds: 2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _quickAction(
              icon: Icons.local_shipping_outlined,
              color: kOrange,
              label: 'Orders',
              onTap: () =>
                  context.pushNamed(OrderDetailsWidget.routeName),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 92,
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _text,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // VISITOR: PRIMARY ACTIONS
  // ═══════════════════════════════════════════════════════════
  Widget _buildVisitorActions(UsersRecord? seller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _primaryButton(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Message Seller',
              onTap: () => _openChatWithSeller(seller),
            ),
          ),
          const SizedBox(width: 10),
          _circleAction(
            icon: Icons.favorite_border_rounded,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Following this seller')),
              );
            },
          ),
          const SizedBox(width: 8),
          _circleAction(
            icon: Icons.share_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _primaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: kGreen,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: kGreen.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleAction({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Icon(icon, color: _text, size: 20),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // VISITOR: HIGHLIGHTS
  // ═══════════════════════════════════════════════════════════
  Widget _buildSellerHighlights(
      UsersRecord? seller, List<InventoryRecord> products) {
    final totalReviews =
        products.fold<int>(0, (s, p) => s + p.reviews);
    final totalViews =
        products.fold<int>(0, (s, p) => s + p.viewCount);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            _highlight(
              icon: Icons.inventory_2_outlined,
              value: '${products.length}',
              label: 'Products',
            ),
            _divider(),
            _highlight(
              icon: Icons.star_rounded,
              value: '${totalReviews}',
              label: 'Reviews',
            ),
            _divider(),
            _highlight(
              icon: Icons.visibility_outlined,
              value: formatNumber(totalViews,
                  formatType: FormatType.compact),
              label: 'Views',
            ),
          ],
        ),
      ),
    );
  }

  Widget _highlight({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: kGreen, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: _text,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: _muted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 44, color: _border);

  // ═══════════════════════════════════════════════════════════
  // SECTION HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _buildSectionHeader(String title, {String? trailing}) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: kGreen,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: _text,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          if (trailing != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                trailing,
                style: const TextStyle(
                  color: kGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PRODUCT GRID
  // ═══════════════════════════════════════════════════════════
  Widget _buildProductGrid(List<InventoryRecord> products) {
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.inventory_2_outlined,
                    color: kGreen, size: 32),
              ),
              const SizedBox(height: 14),
              Text(
                _isOwner
                    ? 'You haven\'t posted any products yet'
                    : 'This seller hasn\'t posted any products yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _text,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_isOwner) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () =>
                      context.pushNamed(SelectAdWidget.routeName),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add_rounded,
                      color: Colors.white, size: 18),
                  label: const Text(
                    'Add your first product',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.68,
        ),
        itemCount: products.length,
        itemBuilder: (context, i) => _productCard(products[i]),
      ),
    );
  }

  Widget _productCard(InventoryRecord item) {
    final inStock = true; // placeholder — add stock field later
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.pushNamed(
        ProductDetailsWidget.routeName,
        queryParameters: {
          'inventoryRef': serializeParam(
            item.reference,
            ParamType.DocumentReference,
          ),
        }.withoutNulls,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _soft,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.network(
                      _imgUrl(valueOrDefault<String>(
                        item.inventoryImages.firstOrNull,
                        '',
                      )),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.image_not_supported_outlined,
                        color: _muted,
                        size: 28,
                      ),
                    ),
                  ),
                  // Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: inStock
                            ? const Color(0xFF16A34A)
                            : kRed,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        inStock ? 'IN STOCK' : 'OUT',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valueOrDefault<String>(
                          item.inventoryName, 'Product'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _text,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      valueOrDefault<String>(
                        formatNumber(
                          item.inventoryPrice,
                          formatType: FormatType.decimal,
                          decimalType: DecimalType.automatic,
                          currency: 'TZS ',
                        ),
                        'TZS 0',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: kGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    // OWNER: edit / delete row
                    if (_isOwner) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _miniAction(
                              icon: Icons.edit_outlined,
                              label: 'Edit',
                              color: kBlue,
                              onTap: () => context.pushNamed(
                                EditModeWidget.routeName,
                                queryParameters: {
                                  'targetProduct': serializeParam(
                                    item.reference,
                                    ParamType.DocumentReference,
                                  ),
                                }.withoutNulls,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _miniAction(
                              icon: Icons.delete_outline_rounded,
                              label: 'Del',
                              color: kRed,
                              onTap: () => _confirmDelete(item),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(InventoryRecord item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _card,
        title: Text(
          'Delete product?',
          style: TextStyle(color: _text, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'This will permanently remove "${item.inventoryName}" from your shop.',
          style: TextStyle(color: _muted, fontSize: 13.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel', style: TextStyle(color: _muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: kRed,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await item.reference.delete();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e')),
        );
      }
    }
  }

  // ═══════════════════════════════════════════════════════════
  // CHAT WITH SELLER (visitor action)
  // ═══════════════════════════════════════════════════════════
  Future<void> _openChatWithSeller(UsersRecord? seller) async {
    if (currentUserReference == null || _sellerRef == null) return;

    try {
      // Find an existing chat with this seller (any product)
      final existing = await FirebaseFirestore.instance
          .collection('Chats')
          .where('users', arrayContains: currentUserReference)
          .where('seller_ref', isEqualTo: _sellerRef)
          .limit(1)
          .get();

      DocumentReference chatRef;
      if (existing.docs.isNotEmpty) {
        chatRef = existing.docs.first.reference;
      } else {
        final newDoc = ChatsRecord.collection.doc();
        await newDoc.set({
          ...createChatsRecordData(
            lastMessage: 'Hi, I want to ask about your shop',
            lastMessageTime: getCurrentTimestamp,
            buyerRef: currentUserReference,
            sellerRef: _sellerRef,
            productName: 'Shop inquiry',
            price: 0,
          ),
          ...mapToFirestore({
            'users': [
              currentUserReference!,
              _sellerRef!,
            ],
            'User_name': [
              currentUserDisplayName,
              seller?.displayName ?? 'Seller',
            ],
            'items_images': [
              _imgUrl(seller?.photoUrl).isNotEmpty
                  ? _imgUrl(seller?.photoUrl)
                  : 'https://static.thenounproject.com/png/4974686-200.png'
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
  // STATE MESSAGE
  // ═══════════════════════════════════════════════════════════
  Widget _stateMessage({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
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
                color: kGreen.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: kGreen, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _text,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
