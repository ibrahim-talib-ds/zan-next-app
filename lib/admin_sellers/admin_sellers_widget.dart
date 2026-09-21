import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin_sellers_model.dart';
export 'admin_sellers_model.dart';

class AdminSellersWidget extends StatefulWidget {
  const AdminSellersWidget({super.key});

  static String routeName = 'AdminSellers';
  static String routePath = '/adminSellers';

  @override
  State<AdminSellersWidget> createState() => _AdminSellersWidgetState();
}

class _AdminSellersWidgetState extends State<AdminSellersWidget> {
  late AdminSellersModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kBlue = Color(0xFF3B82F6);

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
    _model = createModel(context, () => AdminSellersModel());
    _model.searchController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
            _buildSearchBar(),
            Expanded(child: _buildSellersList()),
          ],
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
              Text('Sellers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(height: 2),
              Text('Verify & manage',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SEARCH
  // ═══════════════════════════════════════════════════════════
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 6),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: TextField(
          controller: _model.searchController,
          focusNode: _model.searchFocusNode,
          onChanged: (v) => safeSetState(
              () => _model.searchQuery = v.trim().toLowerCase()),
          style: TextStyle(color: _text, fontSize: 14.5),
          cursorColor: kGreen,
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Search by name or email',
            hintStyle: TextStyle(color: _muted, fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded,
                color: _muted, size: 20),
            suffixIcon: _model.searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _model.searchController?.clear();
                      safeSetState(() => _model.searchQuery = '');
                    },
                    child: Icon(Icons.close_rounded,
                        color: _muted, size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsetsDirectional.fromSTEB(0, 14, 14, 14),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SELLERS LIST
  // ═══════════════════════════════════════════════════════════
  Widget _buildSellersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _state(Icons.error_outline_rounded,
              'Could not load sellers', '${snapshot.error}', kRed);
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

        // Filter: sellers = users with isSeller == true OR role contains 'seller'
        // Fallback: if none, show all non-admin users
        final allUsers = snapshot.data!.docs;

        var sellers = allUsers.where((d) {
          final data = d.data() as Map<String, dynamic>;
          final isSeller = data['isSeller'] as bool? ?? false;
          final role = (data['role'] ?? '').toString().toLowerCase();
          final isAdmin = data['isAdmin'] as bool? ?? false;
          return isSeller || role.contains('seller') || (!isAdmin);
        }).toList();

        // Apply search filter
        final q = _model.searchQuery;
        if (q.isNotEmpty) {
          sellers = sellers.where((d) {
            final data = d.data() as Map<String, dynamic>;
            final name = (data['display_name'] ?? '').toString().toLowerCase();
            final email = (data['email'] ?? '').toString().toLowerCase();
            return name.contains(q) || email.contains(q);
          }).toList();
        }

        if (sellers.isEmpty) {
          return _state(
            Icons.storefront_outlined,
            'No sellers yet',
            'When users list products, they will appear here.',
            kGreen,
          );
        }

        return Column(
          children: [
            _buildSummaryBar(sellers.length),
            Expanded(
              child: RefreshIndicator(
                color: kGreen,
                onRefresh: () async => safeSetState(() {}),
                child: ListView.separated(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
                  itemCount: sellers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _sellerTile(sellers[i]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryBar(int count) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 6),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: kGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.storefront_outlined,
                    size: 13, color: kGreen),
                const SizedBox(width: 5),
                Text('$count sellers',
                    style: const TextStyle(
                      color: kGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sellerTile(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final name = (data['display_name'] ?? 'User').toString();
    final email = (data['email'] ?? '').toString();
    final photo = _imgUrl((data['photo_url'] ?? '').toString());
    final isVerified = (data['isVerified'] as bool?) ?? false;
    final isSuspended = (data['isSuspended'] as bool?) ?? false;
    final isAdmin = (data['isAdmin'] as bool?) ?? false;
    final city = (data['city'] ?? '').toString();

    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSuspended
              ? kRed.withOpacity(0.4)
              : isVerified
                  ? kGreen.withOpacity(0.4)
                  : _border,
          width: isVerified || isSuspended ? 1.4 : 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: avatar + info + status pills
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.antiAlias,
                child: photo.isEmpty
                    ? const Icon(Icons.person_rounded,
                        color: kGreen, size: 22)
                    : Image.network(
                        photo,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.person_rounded,
                            color: kGreen,
                            size: 22),
                      ),
              ),
              const SizedBox(width: 12),
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
                            style: TextStyle(
                              color: _text,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (isAdmin) ...[
                          const SizedBox(width: 6),
                          _pill('ADMIN', kBlue),
                        ],
                      ],
                    ),
                    if (email.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: _muted, fontSize: 11.5)),
                    ],
                    if (city.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 11, color: _muted),
                          const SizedBox(width: 3),
                          Text(city,
                              style: TextStyle(
                                  color: _muted, fontSize: 11.5)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Status pills
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isVerified) _pill('VERIFIED', kGreen),
                  if (isSuspended) ...[
                    const SizedBox(height: 4),
                    _pill('SUSPENDED', kRed),
                  ],
                ],
              ),
            ],
          ),

          // Row 2: action buttons
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _actionBtn(
                  icon: isVerified
                      ? Icons.verified_rounded
                      : Icons.verified_outlined,
                  label: isVerified ? 'Verified' : 'Verify',
                  color: kGreen,
                  active: isVerified,
                  onTap: () => _toggleVerified(doc, !isVerified),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _actionBtn(
                  icon: isSuspended
                      ? Icons.lock_open_rounded
                      : Icons.block_rounded,
                  label: isSuspended ? 'Unsuspend' : 'Suspend',
                  color: kRed,
                  active: isSuspended,
                  onTap: () => _toggleSuspended(doc, !isSuspended),
                ),
              ),
              const SizedBox(width: 8),
              _iconAction(
                icon: Icons.storefront_outlined,
                color: kBlue,
                onTap: () {
                  context.pushNamed(
                    SellerDashbordWidget.routeName,
                    queryParameters: {
                      'sellerRef': serializeParam(
                        doc.reference,
                        ParamType.DocumentReference,
                      ),
                    }.withoutNulls,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: active
              ? color.withOpacity(0.15)
              : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? color.withOpacity(0.5) : color.withOpacity(0.25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconAction({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════
  Future<void> _toggleVerified(DocumentSnapshot doc, bool value) async {
    try {
      await doc.reference.update({'isVerified': value});
      if (!mounted) return;
      _snack(value ? 'Seller verified' : 'Verification removed');
    } catch (e) {
      if (!mounted) return;
      _snack('Failed: $e', error: true);
    }
  }

  Future<void> _toggleSuspended(DocumentSnapshot doc, bool value) async {
    // Confirm when suspending
    if (value) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: _card,
          title: Text('Suspend seller?',
              style: TextStyle(
                color: _text,
                fontWeight: FontWeight.w700,
              )),
          content: Text(
            'This seller will no longer be able to list new products.',
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
                'Suspend',
                style: TextStyle(
                  color: kRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }

    try {
      await doc.reference.update({'isSuspended': value});
      if (!mounted) return;
      _snack(value ? 'Seller suspended' : 'Seller unsuspended');
    } catch (e) {
      if (!mounted) return;
      _snack('Failed: $e', error: true);
    }
  }

  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: error ? kRed : kGreen,
    ));
  }

  // ═══════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════
  Widget _state(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 40),
            ),
            const SizedBox(height: 16),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _text,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 6),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _muted, fontSize: 13, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
