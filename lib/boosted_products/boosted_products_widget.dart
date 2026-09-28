import 'dart:math';
import '/components/product_bottom_info.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/responsive.dart';
import '/flutter_flow/internationalization.dart';
import '/index.dart';
import '/backend/backend.dart';
import 'package:flutter/material.dart';

import 'boosted_products_model.dart';
export 'boosted_products_model.dart';

class BoostedProductsWidget extends StatefulWidget {
  const BoostedProductsWidget({super.key});
  static String routeName = 'BoostedProducts';
  static String routePath = '/boostedProducts';
  @override
  State<BoostedProductsWidget> createState() => _BoostedProductsWidgetState();
}

class _BoostedProductsWidgetState extends State<BoostedProductsWidget> {
  late BoostedProductsModel _model;

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);

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
    _model = createModel(context, () => BoostedProductsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _header(),
            Expanded(
              child: StreamBuilder<List<InventoryRecord>>(
                stream: queryInventoryRecord(
                  queryBuilder: (r) => r.where('boosted', isEqualTo: true),
                  limit: 100,
                ),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                      ),
                    );
                  }
                  final items = _shuffleList(snap.data!);
                  if (items.isEmpty) return _empty();
                  return RefreshIndicator(
                    color: kGreen,
                    onRefresh: () async => _reshuffle(),
                    child: GridView.builder(
                      padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 24),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.productCols(context),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: items.length,
                      itemBuilder: (_, i) => _productCard(items[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(8, topPad + 8, 16, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kAmber, Color(0xFF7A4A00)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          FlutterFlowIconButton(
            borderRadius: 24, buttonSize: 44,
            fillColor: Colors.white.withOpacity(0.18),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(FFLocalizations.of(context).getText('bp_header_title'),
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(FFLocalizations.of(context).getText('bp_header_sub'),
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _productCard(InventoryRecord record) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.pushNamed(
          ProductDetailsWidget.routeName,
          queryParameters: {
            'inventoryRef': serializeParam(record.reference, ParamType.DocumentReference),
          }.withoutNulls,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _soft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        _imgUrl(record.inventoryImages.firstOrNull),
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.image_not_supported_outlined,
                          color: _muted, size: 28,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4, left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: kAmber,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(FFLocalizations.of(context).getText('bp_badge'),
                          style: const TextStyle(
                            color: Colors.white, fontSize: 8.5,
                            fontWeight: FontWeight.w900, letterSpacing: 0.4,
                          )),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                valueOrDefault<String>(record.inventoryName, FFLocalizations.of(context).getText('bp_product_fallback')),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: _text, fontSize: 12, fontWeight: FontWeight.w500, height: 1.25),
              ),
              _pbDescription(record, color: _muted),
              const SizedBox(height: 4),
              Text(
                valueOrDefault<String>(
                  formatNumber(record.inventoryPrice,
                      formatType: FormatType.decimal,
                      decimalType: DecimalType.automatic, currency: 'TZS '),
                  'TZS 0',
                ),
                style: const TextStyle(color: kRed, fontSize: 14, fontWeight: FontWeight.w900),
              ),
                  const SizedBox(height: 2),
                  _pbBottomRow(record),
            ],
          ),
        ),
      ),
    );
  }

  Widget _empty() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: kAmber.withOpacity(0.10), shape: BoxShape.circle),
          child: const Icon(Icons.star_rounded, color: kAmber, size: 40),
        ),
        const SizedBox(height: 16),
        Text(FFLocalizations.of(context).getText('bp_empty'),
          style: TextStyle(color: _text, fontSize: 16, fontWeight: FontWeight.w700)),
      ],
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


  // ── seeded shuffle: stable within a build, fresh on refresh ──
  int _shuffleSeed = 0;
  void _reshuffle() {
    if (mounted) setState(() => _shuffleSeed++);
  }
  List<T> _shuffleList<T>(List<T> items, {int keepTop = 0}) {
    if (items.length <= keepTop + 1) return items;
    final head = items.take(keepTop).toList();
    final tail = items.skip(keepTop).toList();
    tail.shuffle(Random(_shuffleSeed));
    return <T>[...head, ...tail];
  }
}
