import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'specific_categories_model.dart';
export 'specific_categories_model.dart';

/// Modern category page — Alibaba-style.
/// • Gradient header with back + title + count
/// • Sort / filter chip row
/// • 2-column masonry grid with image-forward cards
/// • Bold red price, verified seller row
/// • Clean empty state
class SpecificCategoriesWidget extends StatefulWidget {
  const SpecificCategoriesWidget({super.key});

  static String routeName = 'Specific_categories';
  static String routePath = '/specificCategories';

  @override
  State<SpecificCategoriesWidget> createState() =>
      _SpecificCategoriesWidgetState();
}

class _SpecificCategoriesWidgetState extends State<SpecificCategoriesWidget> {
  late SpecificCategoriesModel _model;

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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SpecificCategoriesModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = FFAppState().categories;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _bg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _header(category),
            _sortChips(),
            Expanded(
              child: StreamBuilder<List<InventoryRecord>>(
                stream: queryInventoryRecord(
                  queryBuilder: (r) => r.where('categories', isEqualTo: category),
                ),
                builder: (context, snap) {
                  if (!snap.hasData) return _loading();
                  final items = _sorted(snap.data!);
                  if (items.isEmpty) return _empty(category);
                  return _grid(items);
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
  Widget _header(String category) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kGreen, kGreenDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: kGreen.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Browse · Compare · Buy',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
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
  // SORT CHIP ROW
  // ═══════════════════════════════════════════════════════════
  Widget _sortChips() {
    final chips = [
      ('popular', 'Popular', Icons.local_fire_department_rounded),
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
                  Icon(
                    icon,
                    size: 15,
                    color: active ? Colors.white : _muted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: active ? Colors.white : _text,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SORT
  // ═══════════════════════════════════════════════════════════
  /// Read an arbitrary Firestore field from a record (for fields not
  /// exposed on the generated InventoryRecord class).
  dynamic _raw(InventoryRecord o, String key) {
    try {
      final data = (o as dynamic).snapshotData;
      if (data is Map) return data[key];
    } catch (_) {}
    return null;
  }

  DateTime _createdAt(InventoryRecord o) {
    final v = _raw(o, 'created_time');
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v) ?? DateTime(1970);
    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
    return DateTime(1970);
  }

  List<InventoryRecord> _sorted(List<InventoryRecord> items) {
    final list = List<InventoryRecord>.from(items);
    switch (_model.sortMode) {
      case 'price_low':
        list.sort((a, b) =>
            (a.inventoryPrice).compareTo(b.inventoryPrice));
        break;
      case 'price_high':
        list.sort((a, b) =>
            (b.inventoryPrice).compareTo(a.inventoryPrice));
        break;
      case 'newest':
        list.sort((a, b) {
          final ad = _createdAt(a);
          final bd = _createdAt(b);
          return bd.compareTo(ad);
        });
        break;
      case 'popular':
      default:
        list.sort((a, b) =>
            (b.viewCount ?? 0).compareTo(a.viewCount ?? 0));
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
      itemBuilder: (_, i) => _productCard(items[i]),
    );
  }

  Widget _productCard(InventoryRecord record) {
    final img = _imgUrl(record.inventoryImages.firstOrNull);

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
                child: ClipRRect(
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
                  const Icon(Icons.verified_rounded,
                      color: kGreen, size: 11),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      valueOrDefault<String>(record.sellerName, 'Verified'),
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

  Widget _empty(String category) {
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
              child: const Icon(Icons.inventory_2_outlined,
                  color: kGreen, size: 44),
            ),
            const SizedBox(height: 18),
            Text(
              'Nothing in $category yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _text,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try another category or check back later.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}
