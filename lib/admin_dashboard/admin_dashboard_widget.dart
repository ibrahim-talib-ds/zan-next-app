import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin_dashboard_model.dart';
export 'admin_dashboard_model.dart';

/// Full Admin Dashboard — visible only to users with isAdmin: true.
class AdminDashboardWidget extends StatefulWidget {
  const AdminDashboardWidget({super.key});

  static String routeName = 'AdminDashboard';
  static String routePath = '/adminDashboard';

  @override
  State<AdminDashboardWidget> createState() => _AdminDashboardWidgetState();
}

class _AdminDashboardWidgetState extends State<AdminDashboardWidget> {
  late AdminDashboardModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kBlue = Color(0xFF3B82F6);
  static const Color kPurple = Color(0xFFAB47D0);

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
    _model = createModel(context, () => AdminDashboardModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  bool get _isAdmin {
    return valueOrDefault<bool>(currentUserDocument?.isAdmin, false) == true;
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    if (!_isAdmin) {
      return Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: kRed.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_outline_rounded,
                        color: kRed, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text('Access denied',
                      style: TextStyle(
                        color: _text,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      )),
                  const SizedBox(height: 8),
                  Text(
                    'You need admin privileges to view this page.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => context.safePop(),
                    child: const Text('Go back',
                        style: TextStyle(
                          color: kGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

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
                child: RefreshIndicator(
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
                        _buildStatsGrid(),
                        const SizedBox(height: 20),
                        _buildQuickActions(),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Latest Orders', trailing: 'View all',
                            onTrailingTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Full orders view coming soon')),
                          );
                        }),
                        _buildLatestOrders(),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Recently Joined Users', trailing: 'View all',
                            onTrailingTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Full users view coming soon')),
                          );
                        }),
                        _buildRecentUsers(),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Top Products'),
                        _buildTopProducts(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
              Text('Admin Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(height: 2),
              Text('Full control panel',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_rounded, color: Colors.white, size: 12),
                SizedBox(width: 4),
                Text('ADMIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.6,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // STATS GRID
  // ═══════════════════════════════════════════════════════════
  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _statCountCard(
                  icon: Icons.people_alt_outlined,
                  color: kBlue,
                  label: 'Total Users',
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCountCard(
                  icon: Icons.inventory_2_outlined,
                  color: kAmber,
                  label: 'Products',
                  stream: FirebaseFirestore.instance
                      .collection('Inventory')
                      .snapshots(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _statCountCard(
                  icon: Icons.shopping_bag_outlined,
                  color: kGreen,
                  label: 'Orders',
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .snapshots(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCountCard(
                  icon: Icons.support_agent_outlined,
                  color: kPurple,
                  label: 'Support Chats',
                  stream: FirebaseFirestore.instance
                      .collection('support_chats')
                      .snapshots(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCountCard({
    required IconData icon,
    required Color color,
    required String label,
    required Stream<QuerySnapshot> stream,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snap) {
        final count = snap.data?.docs.length ?? 0;
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
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                snap.hasData ? '$count' : '—',
                style: TextStyle(
                  color: _text,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════
  // QUICK ACTIONS
  // ═══════════════════════════════════════════════════════════
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Admin Tools'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _adminAction(
                  icon: Icons.support_agent_rounded,
                  color: kGreen,
                  label: 'Support Inbox',
                  onTap: () =>
                      context.pushNamed(AdminSupportInboxWidget.routeName),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _adminAction(
                  icon: Icons.verified_user_outlined,
                  color: kBlue,
                  label: 'Sellers',
                  onTap: () => _showComingSoon('Seller management'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _adminAction(
                  icon: Icons.flag_outlined,
                  color: kRed,
                  label: 'Reports',
                  onTap: () => _showComingSoon('Reports'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _adminAction(
                  icon: Icons.campaign_outlined,
                  color: kAmber,
                  label: 'Broadcast',
                  onTap: () => _showComingSoon('Broadcast'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon')),
    );
  }

  Widget _adminAction({
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
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _text,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SECTION HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _buildSectionHeader(
    String title, {
    String? trailing,
    VoidCallback? onTrailingTap,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 10),
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
          Text(title,
              style: TextStyle(
                color: _text,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              )),
          const Spacer(),
          if (trailing != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: Text(
                trailing,
                style: const TextStyle(
                  color: kGreen,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // LATEST ORDERS
  // ═══════════════════════════════════════════════════════════
  Widget _buildLatestOrders() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('date', descending: true)
            .limit(5)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return _loadingStrip();
          final docs = snap.data!.docs;
          if (docs.isEmpty) return _emptyStrip('No orders yet');

          return Container(
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _border),
            ),
            child: Column(
              children: List.generate(docs.length, (i) {
                final data = docs[i].data() as Map<String, dynamic>;
                final name = (data['product_name'] ?? 'Order').toString();
                final status = (data['status'] ?? 'Pending').toString();
                final price = (data['price'] as num?)?.toDouble() ?? 0;
                final images = (data['Item_images'] as List?) ?? [];

                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Order: $name')),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: _soft,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: images.isNotEmpty
                                  ? Image.network(
                                      _imgUrl(images.first.toString()),
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          Icon(Icons.image_not_supported_outlined,
                                              color: _muted, size: 18),
                                    )
                                  : Icon(Icons.shopping_bag_outlined,
                                      color: _muted, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: _text,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  const SizedBox(height: 2),
                                  Text(status,
                                      style: TextStyle(
                                        color: _statusColor(status),
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ],
                              ),
                            ),
                            Text(
                              formatNumber(price,
                                  formatType: FormatType.decimal,
                                  decimalType: DecimalType.automatic,
                                  currency: 'TZS '),
                              style: const TextStyle(
                                color: kGreen,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (i < docs.length - 1)
                      Divider(height: 1, color: _border, indent: 68),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('deliver')) return kGreen;
    if (s.contains('way') || s.contains('ship')) return kBlue;
    if (s.contains('cancel')) return kRed;
    return kAmber;
  }

  // ═══════════════════════════════════════════════════════════
  // RECENT USERS
  // ═══════════════════════════════════════════════════════════
  Widget _buildRecentUsers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('created_time', descending: true)
            .limit(5)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return _loadingStrip();
          final docs = snap.data!.docs;
          if (docs.isEmpty) return _emptyStrip('No users yet');

          return Container(
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _border),
            ),
            child: Column(
              children: List.generate(docs.length, (i) {
                final data = docs[i].data() as Map<String, dynamic>;
                final name = (data['display_name'] ?? 'User').toString();
                final email = (data['email'] ?? '').toString();
                final photo = _imgUrl((data['photo_url'] ?? '').toString());
                final isAdminUser = (data['isAdmin'] as bool?) ?? false;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _soft,
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: photo.isEmpty
                                ? Icon(Icons.person_rounded,
                                    color: _muted, size: 20)
                                : Image.network(photo,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(
                                        Icons.person_rounded,
                                        color: _muted,
                                        size: 20)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: _text,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),
                                    if (isAdminUser) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: kGreen.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Text('ADMIN',
                                            style: TextStyle(
                                              color: kGreen,
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 0.4,
                                            )),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: _muted, fontSize: 11.5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < docs.length - 1)
                      Divider(height: 1, color: _border, indent: 64),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // TOP PRODUCTS
  // ═══════════════════════════════════════════════════════════
  Widget _buildTopProducts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Inventory')
            .orderBy('view_count', descending: true)
            .limit(5)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return _loadingStrip();
          final docs = snap.data!.docs;
          if (docs.isEmpty) return _emptyStrip('No products yet');

          return Column(
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final name =
                  (data['inventory_name'] ?? 'Product').toString();
              final price =
                  (data['inventory_price'] as num?)?.toDouble() ?? 0;
              final views = (data['view_count'] as num?)?.toInt() ?? 0;
              final images = (data['inventory_images'] as List?) ?? [];

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _border),
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _soft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: images.isNotEmpty
                          ? Image.network(
                              _imgUrl(images.first.toString()),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                  Icons.image_not_supported_outlined,
                                  color: _muted,
                                  size: 18),
                            )
                          : Icon(Icons.inventory_2_outlined,
                              color: _muted, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _text,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              )),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(Icons.visibility_outlined,
                                  size: 11, color: _muted),
                              const SizedBox(width: 3),
                              Text('$views views',
                                  style: TextStyle(
                                      color: _muted, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatNumber(price,
                          formatType: FormatType.decimal,
                          decimalType: DecimalType.automatic,
                          currency: 'TZS '),
                      style: const TextStyle(
                        color: kGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // STRIPS
  // ═══════════════════════════════════════════════════════════
  Widget _loadingStrip() => Container(
        height: 100,
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: const Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(kGreen),
            ),
          ),
        ),
      );

  Widget _emptyStrip(String msg) => Container(
        height: 80,
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Center(
          child: Text(msg,
              style: TextStyle(color: _muted, fontSize: 13)),
        ),
      );
}
