import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin_products_model.dart';
export 'admin_products_model.dart';

class AdminProductsWidget extends StatefulWidget {
  const AdminProductsWidget({super.key});
  static String routeName = 'AdminProducts';
  static String routePath = '/adminProducts';
  @override
  State<AdminProductsWidget> createState() => _AdminProductsWidgetState();
}

class _AdminProductsWidgetState extends State<AdminProductsWidget> {
  late AdminProductsModel _model;

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
    _model = createModel(context, () => AdminProductsModel());
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Inventory')
                    .snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                      ),
                    );
                  }
                  final docs = snap.data!.docs;
                  if (docs.isEmpty) return _empty();
                  return RefreshIndicator(
                    color: kGreen,
                    onRefresh: () async => safeSetState(() {}),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final doc = docs[i];
                        final d = doc.data() as Map<String, dynamic>;
                        return Dismissible(
                          key: ValueKey('product_${doc.id}'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                            decoration: BoxDecoration(
                              color: kRed,
                              borderRadius: BorderRadius.circular(14),
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
                          confirmDismiss: (_) => _confirmDelete(d['inventory_name'] ?? 'Product'),
                          onDismissed: (_) => _deleteProduct(doc),
                          child: _productTile(doc),
                        );
                      },
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
          colors: [kGreen, kGreenDeep],
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
              Text('All Products',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              SizedBox(height: 2),
              Text('Swipe left to delete',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _productTile(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    final name = (d['inventory_name'] ?? 'Product').toString();
    final price = (d['inventory_price'] as num?)?.toDouble() ?? 0;
    final images = (d['inventory_images'] as List?) ?? [];
    final photo = images.isNotEmpty ? _imgUrl(images.first.toString()) : '';
    final sellerName = (d['seller_name'] ?? 'Unknown seller').toString();

    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: photo.isEmpty
                ? Icon(Icons.image_outlined, color: _muted, size: 22)
                : Image.network(photo, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported_outlined, color: _muted, size: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: _text, fontSize: 14, fontWeight: FontWeight.w700, height: 1.25)),
                const SizedBox(height: 4),
                Text(
                  formatNumber(price,
                      formatType: FormatType.decimal,
                      decimalType: DecimalType.automatic,
                      currency: 'TZS '),
                  style: const TextStyle(color: kRed, fontSize: 13, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text('By $sellerName', maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: _muted, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(String name) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete product?',
            style: TextStyle(color: _text, fontWeight: FontWeight.w800, fontSize: 16)),
        content: Text('"$name" will be permanently removed.',
            style: TextStyle(color: _muted, fontSize: 13, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: _muted, fontWeight: FontWeight.w600))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: kRed, fontWeight: FontWeight.w800))),
        ],
      ),
    ) ?? false;
  }

  Future<void> _deleteProduct(DocumentSnapshot doc) async {
    try {
      await doc.reference.delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Product deleted'),
        backgroundColor: kGreen, behavior: SnackBarBehavior.floating,
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not delete: $e'),
        backgroundColor: kRed, behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: kGreen.withOpacity(0.10), shape: BoxShape.circle),
            child: const Icon(Icons.inventory_2_outlined, color: kGreen, size: 36),
          ),
          const SizedBox(height: 16),
          Text('No products yet', style: TextStyle(color: _text, fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
