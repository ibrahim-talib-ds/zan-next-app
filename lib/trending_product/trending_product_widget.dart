import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';

import 'trending_product_model.dart';
export 'trending_product_model.dart';

/// Trending Products — modern Alibaba-style grid.
/// Green gradient header + sort chips + 2-col product grid.
class TrendingProductWidget extends StatefulWidget {
  const TrendingProductWidget({super.key});

  static String routeName = 'TrendingProduct';
  static String routePath = '/trendingProduct';

  @override
  State<TrendingProductWidget> createState() =>
      _TrendingProductWidgetState();
}

class _TrendingProductWidgetState extends State<TrendingProductWidget> {
  late TrendingProductModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
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

  dynamic _raw(InventoryRecord o, String key) {
    try {
      final data = (o as dynamic).snapshotData;
      if (data is Map) return data[key];
    } catch (_) {}
    return null;
  }

  String _rawStr(InventoryRecord o, String key) {
    final v = _raw(o, key);
    if (v == null) return '';
    return v.toString();
  }

  int _views(InventoryRecord o) {
    final v = _raw(o, 'view_count');
    if (v is int) return v;
    if (v is num) return v.toInt();
    return 0;
  }

  DateTime _createdAt(InventoryRecord o) {
    final v = _raw(o, 'created_time');
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v) ?? DateTime(1970);
    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
    return DateTime(1970);
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrendingProductModel());
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
            _header(),
            _sortChips(),
            Expanded(
              child: StreamBuilder<List<InventoryRecord>>(
                stream: queryInventoryRecord(
                  queryBuilder: (r) =>
                      r.where('top_selling', isEqualTo: true),
                  limit: 200,
                ),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return _errorState('${snap.error}');
                  }
                  if (!snap.hasData) return _loading();
                  final items = _sorted(snap.data!);
                  if (items.isEmpty) return _empty();
                  return RefreshIndicator(
                    color: kGreen,
                    onRefresh: () async => safeSetState(() {}),
                    child: _grid(items),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _header() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreen, kGreenDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 18),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Row(
            children: [
              FlutterFlowIconButton(
                borderRadius: 12,
                buttonSize: 42,
                fillColor: Colors.white.withOpacity(0.15),
                icon: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 20),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_fire_department_rounded,
                            color: Colors.white, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'Trending Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Most viewed products this week',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              FlutterFlowIconButton(
                borderRadius: 12,
                buttonSize: 42,
                fillColor: Colors.white.withOpacity(0.15),
                icon: const Icon(Icons.search_rounded,
                    color: Colors.white, size: 20),
                onPressed: () {
                  context.pushNamed(SearchWidget.routeName);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SORT CHIPS
  // ═══════════════════════════════════════════════════════════
  Widget _sortChips() {
    final chips = [
      ('popular', 'Most Viewed', Icons.visibility_rounded),
      ('newest', 'Newest', Icons.fiber_new_rounded),
      ('price_low', 'Price ↑', Icons.trending_up_rounded),
      ('price_high', 'Price ↓', Icons.trending_down_rounded),
    ];
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (key, label, icon) = chips[i];
          final active = _model.sortMode == key;
          return GestureDetector(
            onTap: () => safeSetState(() => _model.sortMode = key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: active ? kGreen : _card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? kGreen : _border,
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 15,
                      color: active ? Colors.white : _muted),
                  const SizedBox(width: 6),
                  Text(label,
                      style: TextStyle(
                        color: active ? Colors.white : _text,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<InventoryRecord> _sorted(List<InventoryRecord> items) {
    final list = List<InventoryRecord>.from(items);
    switch (_model.sortMode) {
      case 'price_low':
        list.sort((a, b) =>
            a.inventoryPrice.compareTo(b.inventoryPrice));
        break;
      case 'price_high':
        list.sort((a, b) =>
            b.inventoryPrice.compareTo(a.inventoryPrice));
        break;
      case 'newest':
        list.sort((a, b) => _createdAt(b).compareTo(_createdAt(a)));
        break;
      case 'popular':
      default:
        list.sort((a, b) => _views(b).compareTo(_views(a)));
        break;
    }
    return list;
  }

  // ═══════════════════════════════════════════════════════════
  // GRID
  // ═══════════════════════════════════════════════════════════
  Widget _grid(List<InventoryRecord> items) {
    return GridView.builder(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.62,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _productCard(items[i], index: i),
    );
  }

  Widget _productCard(InventoryRecord record, {required int index}) {
    final img = _imgUrl(record.inventoryImages.firstOrNull);
    final isTop3 = index < 3;

    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isDark ? 0.25 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          context.pushNamed(
            ProductDetailsWidget.routeName,
            queryParameters: {
              'inventoryRef': serializeParam(
                record.reference,
                ParamType.DocumentReference,
              ),
            }.withoutNulls,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        color: _soft,
                        child: Image.network(
                          img,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.image_not_supported_outlined,
                            color: _muted,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    if (isTop3)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: index == 0
                                ? const Color(0xFFFFB300)
                                : index == 1
                                    ? const Color(0xFFB0BEC5)
                                    : const Color(0xFFCD7F32),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_fire_department_rounded,
                                color: Colors.white,
                                size: 11,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '#${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
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
                style: TextStyle(
                  color: _text,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valueOrDefault<String>(
                  formatNumber(
                    record.inventoryPrice,
                    formatType: FormatType.decimal,
                    decimalType: DecimalType.automatic,
                    currency: 'TZS ',
                  ),
                  'TZS 0',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: kRed,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.visibility_rounded,
                      color: kGreen, size: 10),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      '${_views(record)} views',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _muted,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // STATES
  // ═══════════════════════════════════════════════════════════
  Widget _loading() {
    return GridView.builder(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.62,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_fire_department_rounded,
                  color: kGreen, size: 44),
            ),
            const SizedBox(height: 18),
            Text('No trending products yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _text,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                )),
            const SizedBox(height: 6),
            Text('Come back soon — popular items show up here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 12.5)),
          ],
        ),
      ),
    );
  }

  Widget _errorState(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: kRed, size: 44),
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
