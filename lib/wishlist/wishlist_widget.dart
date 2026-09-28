import '/components/product_bottom_info.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/responsive.dart';
import '/flutter_flow/internationalization.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'wishlist_model.dart';
export 'wishlist_model.dart';

class WishlistWidget extends StatefulWidget {
  const WishlistWidget({super.key});

  static String routeName = 'Wishlist';
  static String routePath = '/wishlist';

  @override
  State<WishlistWidget> createState() => _WishlistWidgetState();
}

class _WishlistWidgetState extends State<WishlistWidget> {
  late WishlistModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF121212) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E7EB);

  String _imgUrl(String? url) {
    final u = (url ?? '').trim();
    if (u.isEmpty) return '';
    return u.startsWith('http://') ? u.replaceFirst('http://', 'https://') : u;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WishlistModel());
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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _bg,
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
    if (currentUserReference == null) {
      return _notLoggedInState();
    }

    return StreamBuilder<List<InventoryRecord>>(
      stream: queryInventoryRecord(
        queryBuilder: (r) =>
            r.where('product_liked_by', arrayContains: currentUserReference),
        limit: 100,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) return _errorState('${snapshot.error}');
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

        final items = List<InventoryRecord>.from(snapshot.data!);
        // Client-side sort by newest
        items.sort((a, b) {
          final at = a.createdAt ?? DateTime(1970);
          final bt = b.createdAt ?? DateTime(1970);
          return bt.compareTo(at);
        });

        if (items.isEmpty) return _emptyState();

        return Column(
          children: [
            _buildCountBar(items.length),
            Expanded(
              child: RefreshIndicator(
                color: kGreen,
                onRefresh: () async => safeSetState(() {}),
                child: GridView.builder(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.productCols(context),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, i) => _savedCard(items[i]),
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
              Text(FFLocalizations.of(context).getText('wishlist_title'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 2),
              Text(FFLocalizations.of(context).getText('wishlist_subtitle'),
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildCountBar(int count) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
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
            count == 1
                ? FFLocalizations.of(context).getText('wishlist_count_one')
                : '$count ${FFLocalizations.of(context).getText('wishlist_count_many')}',
            style: TextStyle(
              color: _text,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SAVED CARD
  // ═══════════════════════════════════════════════════════════
  Widget _savedCard(InventoryRecord item) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        context.pushNamed(
          ProductDetailsWidget.routeName,
          queryParameters: {
            'inventoryRef': serializeParam(
              item.reference,
              ParamType.DocumentReference,
            ),
          }.withoutNulls,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + heart
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Image.network(
                      _imgUrl(valueOrDefault<String>(
                        item.inventoryImages.firstOrNull,
                        '',
                      )),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported_outlined,
                        color: kGreen,
                        size: 32,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          await item.reference.update({
                            'product_liked_by':
                                FieldValue.arrayRemove([currentUserReference]),
                          });
                        } catch (e) {
                          debugPrint('Unsave failed: $e');
                        }
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Color(0xFFDC0F0F),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Name + price
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    valueOrDefault<String>(item.inventoryName, FFLocalizations.of(context).getText('wishlist_product_fallback')),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _text,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
              _pbDescription(item, color: _muted),
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
                  const SizedBox(height: 2),
                  _pbBottomRow(item),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite_border_rounded,
                    color: kGreen, size: 44),
              ),
              const SizedBox(height: 20),
              Text(FFLocalizations.of(context).getText('wishlist_empty_title'),
                  style: TextStyle(
                    color: _text,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 8),
              Text(
                FFLocalizations.of(context).getText('wishlist_empty_subtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () =>
                    context.pushNamed(HomeWidget.routeName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.storefront_outlined,
                    color: Colors.white, size: 18),
                label: Text(FFLocalizations.of(context).getText('wishlist_browse_products'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    )),
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
              Text(FFLocalizations.of(context).getText('wishlist_error_title'),
                  style: TextStyle(
                    color: _text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 8),
              Text(msg,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontSize: 12)),
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
              Icon(Icons.lock_outline_rounded, color: _muted, size: 48),
              const SizedBox(height: 12),
              Text(FFLocalizations.of(context).getText('wishlist_not_logged_in_title'),
                  style: TextStyle(
                    color: _text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 6),
              Text(
                FFLocalizations.of(context).getText('wishlist_not_logged_in_subtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 13),
              ),
            ],
          ),
        ),
      );


  // ── product description (2 lines + trailing "...") ──
  Widget _pbDescription(InventoryRecord r, {required Color color, double size = 10.5}) {
    String desc = '';
    try {
      final data = (r as dynamic).snapshotData;
      if (data is Map) {
        desc = (data['inventory_description'] ??
                data['description'] ??
                data['inventoryDescription'] ??
                '').toString().trim();
      }
    } catch (_) {}
    if (desc.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        '$desc...',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: size,
          height: 1.2,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // ── rotating bottom row ──
  Widget _pbBottomRow(InventoryRecord r) {
    DateTime? created;
    try {
      final data = (r as dynamic).snapshotData;
      if (data is Map) {
        final v = data['created_at'] ?? data['created_time'] ?? data['createdAt'];
        if (v is DateTime) created = v;
        else if (v is String) created = DateTime.tryParse(v);
        else if (v is int) created = DateTime.fromMillisecondsSinceEpoch(v);
        else if (v != null && v.runtimeType.toString().contains('Timestamp')) {
          try { created = (v as dynamic).toDate(); } catch (_) {}
        }
      }
    } catch (_) {}
    String ship = '';
    try {
      final data = (r as dynamic).snapshotData;
      if (data is Map) {
        ship = (data['shipping_days'] ??
                data['delivery_time'] ??
                '').toString().trim();
      }
    } catch (_) {}
    return ProductBottomInfo(
      sellerName: r.sellerName,
      shippingDays: ship,
      createdAt: created,
    );
  }
}
