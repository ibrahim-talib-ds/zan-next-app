import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'search_model.dart';
export 'search_model.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  static String routeName = 'Search';
  static String routePath = '/search';

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late SearchModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // ─── Explicit light-theme colors ───────────────────────────
  static const Color kGreen  = Color(0xFF1B7A4E);
  static const Color kBg     = Color(0xFFF5F7F8);
  static const Color kCard   = Colors.white;
  static const Color kText   = Color(0xFF111827);
  static const Color kMuted  = Color(0xFF6B7280);
  static const Color kBorder = Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ─── Live search: called on every keystroke ────────────────
  void _runSearch(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      safeSetState(() => _model.filteredResults = []);
      return;
    }
    final results = _model.allProducts.where((record) {
      final name = (record.inventoryName ?? '').toString().toLowerCase();
      final desc = (record.inventoryDescription ?? '').toString().toLowerCase();
      return name.contains(q) || desc.contains(q);
    }).toList();
    safeSetState(() => _model.filteredResults = results);
  }

  // ─── Navigation helpers ────────────────────────────────────
  void _openProduct(InventoryRecord record) {
    context.pushNamed(
      ProductDetailsWidget.routeName,
      queryParameters: {
        'inventoryRef': serializeParam(
          record.reference,
          ParamType.DocumentReference,
        ),
      }.withoutNulls,
      extra: <String, dynamic>{
        '__transition_info__': TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 250),
        ),
      },
    );
  }

  // ─── Image helper ──────────────────────────────────────────
  String _imgUrl(String? url) {
    final u = (url ?? '').trim();
    if (u.isEmpty) return '';
    return u.startsWith('http://') ? u.replaceFirst('http://', 'https://') : u;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: kBg,
        body: SafeArea(
          top: false,
          child: StreamBuilder<List<InventoryRecord>>(
            stream: queryInventoryRecord(
              queryBuilder: (r) => r.orderBy('inventory_name'),
              limit: 200,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                    ),
                  ),
                );
              }
              // Cache the full list once for client-side filtering.
              _model.allProducts = snapshot.data!;

              return Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _model.textController!.text.trim().isEmpty
                        ? _buildIdleContent(snapshot.data!)
                        : _buildResults(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HEADER — green top + white search bar
  // ═══════════════════════════════════════════════════════════
  Widget _buildHeader() {
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(0, topPad + 8, 0, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreen, Color(0xFF0A3A22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Title row ─────────────────────────────────────
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 16, 10),
            child: Row(
              children: [
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 24,
                  borderWidth: 1,
                  buttonSize: 44,
                  fillColor: Colors.white.withOpacity(0.18),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () => context.safePop(),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.filter_list_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ],
            ),
          ),

          // ── WHITE search bar ──────────────────────────────
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 6, 0),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: kMuted, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      autofocus: false,
                      onChanged: (v) {
                        safeSetState(() {});
                        _runSearch(v);
                      },
                      style: const TextStyle(
                        color: kText,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: kGreen,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Tafuta bidhaa...',
                        hintStyle: TextStyle(
                          color: kMuted,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  if (_model.textController!.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: kMuted,
                        size: 20,
                      ),
                      onPressed: () {
                        _model.textController?.clear();
                        safeSetState(() {});
                        _runSearch('');
                        _model.textFieldFocusNode?.requestFocus();
                      },
                    )
                  else
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: kGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // IDLE — Recent Search + Last Seen
  // ═══════════════════════════════════════════════════════════
  Widget _buildIdleContent(List<InventoryRecord> allProducts) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecentSearch(),
          const SizedBox(height: 24),
          _buildLastSeen(),
        ],
      ),
    );
  }

  Widget _buildRecentSearch() {
    return StreamBuilder<List<SearchHistoryRecord>>(
      stream: querySearchHistoryRecord(
        queryBuilder: (r) => r
            .where('user_ref', isEqualTo: currentUserReference)
            .orderBy('timestamp', descending: true),
        limit: 8,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final items = snapshot.data!;
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Search',
                    style: TextStyle(
                      color: kText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      for (final h in items) {
                        await h.reference.delete();
                      }
                      safeSetState(() {});
                    },
                    child: const Text(
                      'Clear all',
                      style: TextStyle(
                        color: kMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...items.map(
              (h) => InkWell(
                onTap: () {
                  _model.textController?.text = h.searchTerm ?? '';
                  _runSearch(h.searchTerm ?? '');
                  safeSetState(() {});
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 6),
                  child: Row(
                    children: [
                      const Icon(Icons.history_rounded,
                          color: kMuted, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          h.searchTerm ?? '',
                          style: const TextStyle(
                            color: kText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await h.reference.delete();
                          safeSetState(() {});
                        },
                        child: const Icon(Icons.close_rounded,
                            color: kMuted, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLastSeen() {
    return StreamBuilder<List<InventoryRecord>>(
      stream: queryInventoryRecord(limit: 10),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final items = snapshot.data!;
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 10),
              child: Text(
                'Last Seen',
                style: TextStyle(
                  color: kText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 210,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) =>
                    _miniProductCard(items[i]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _miniProductCard(InventoryRecord record) {
    return GestureDetector(
      onTap: () => _openProduct(record),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.network(
                _imgUrl(valueOrDefault<String>(
                  record.inventoryImages.firstOrNull,
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTBFoD5UgVLKI4PMwREWzsAHbHoQSOs7cXhQ&s',
                )),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported_outlined,
                  color: kMuted,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              valueOrDefault<String>(record.inventoryName, 'Product'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kText,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
            const Spacer(),
            Text(
              formatNumber(
                record.inventoryPrice,
                formatType: FormatType.decimal,
                decimalType: DecimalType.automatic,
                currency: 'TZS ',
              ),
              style: const TextStyle(
                color: kGreen,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // RESULTS — live filtered list
  // ═══════════════════════════════════════════════════════════
  Widget _buildResults() {
    final results = _model.filteredResults;

    if (results.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, color: kMuted, size: 48),
              SizedBox(height: 12),
              Text(
                'Hakuna bidhaa iliyopatikana',
                style: TextStyle(color: kMuted, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final record = results[i] as InventoryRecord;
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            await SearchHistoryRecord.collection.doc().set(
                  createSearchHistoryRecordData(
                    userRef: currentUserReference,
                    searchTerm: _model.textController!.text,
                    timestamp: getCurrentTimestamp,
                  ),
                );
            _openProduct(record);
          },
          child: Container(
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kBorder),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Image.network(
                    _imgUrl(valueOrDefault<String>(
                      record.inventoryImages.firstOrNull,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTBFoD5UgVLKI4PMwREWzsAHbHoQSOs7cXhQ&s',
                    )),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported_outlined,
                      color: kMuted,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        valueOrDefault<String>(
                            record.inventoryName, 'Product'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatNumber(
                          record.inventoryPrice,
                          formatType: FormatType.decimal,
                          decimalType: DecimalType.automatic,
                          currency: 'TZS ',
                        ),
                        style: const TextStyle(
                          color: kGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_outward_rounded,
                    color: kMuted, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
