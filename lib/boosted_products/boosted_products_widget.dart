import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
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
                  final items = snap.data!;
                  if (items.isEmpty) return _empty();
                  return RefreshIndicator(
                    color: kGreen,
                    onRefresh: () async => safeSetState(() {}),
                    child: GridView.builder(
                      padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 24),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.68,
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
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('⭐ Boosted',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              SizedBox(height: 2),
              Text('Featured products',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
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
                        child: const Text('BOOSTED',
                          style: TextStyle(
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
                valueOrDefault<String>(record.inventoryName, 'Product'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: _text, fontSize: 12, fontWeight: FontWeight.w500, height: 1.25),
              ),
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
        Text('No boosted products',
          style: TextStyle(color: _text, fontSize: 16, fontWeight: FontWeight.w700)),
      ],
    ),
  );
}
