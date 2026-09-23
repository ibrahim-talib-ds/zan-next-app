import 'dart:async';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  final _scrollController = ScrollController();
  Timer? _debounce;

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
    _model = createModel(context, () => SearchModel());
    _model.searchController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();

    _scrollController.addListener(_onScroll);

    // Load recent + trending on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecentSearches();
      _loadTrendingSearches();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _model.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════
  // SCROLL — infinite pagination
  // ═══════════════════════════════════════════════════════════
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 400;
    if (_scrollController.position.pixels >= threshold &&
        _model.hasMore &&
        !_model.isLoading) {
      safeSetState(() {
        _model.page++;
        _model.applyFilters();
      });
    }
  }

  // ═══════════════════════════════════════════════════════════
  // SIDE DATA
  // ═══════════════════════════════════════════════════════════
  Future<void> _loadRecentSearches() async {
    if (currentUserReference == null) return;
    try {
      final snap = await FirebaseFirestore.instance
          .collection('search_history')
          .where('user_ref', isEqualTo: currentUserReference)
          .orderBy('timestamp', descending: true)
          .limit(20)
          .get();
      final seen = <String>{};
      final list = <String>[];
      for (final d in snap.docs) {
        final t = (d.data()['search_term'] ?? '').toString().trim();
        if (t.isEmpty) continue;
        if (seen.add(t.toLowerCase())) list.add(t);
        if (list.length >= 10) break;
      }
      if (mounted) safeSetState(() => _model.recentSearches = list);
    } catch (_) {}
  }

  Future<void> _loadTrendingSearches() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('search_history')
          .orderBy('timestamp', descending: true)
          .limit(200)
          .get();
      final counts = <String, int>{};
      for (final d in snap.docs) {
        final t = (d.data()['search_term'] ?? '').toString().trim();
        if (t.isEmpty) continue;
        final key = t.toLowerCase();
        counts[key] = (counts[key] ?? 0) + 1;
      }
      final sorted = counts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final top = sorted.take(5).map((e) => e.key).toList();
      if (mounted) safeSetState(() => _model.trendingSearches = top);
    } catch (_) {}
  }

  // ═══════════════════════════════════════════════════════════
  // SEARCH (debounced)
  // ═══════════════════════════════════════════════════════════
  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _model.query = value;
    // Live suggestion (client-side of the loaded results — instant)
    safeSetState(() {
      if (value.trim().isEmpty) {
        _model.suggestions = [];
        _model.allResults = [];
        _model.visibleResults = [];
      }
    });

    // Debounce the Firestore call 300ms
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _runSearch(value);
    });
  }

  Future<void> _runSearch(String rawQuery) async {
    final q = rawQuery.trim();
    if (q.isEmpty) return;

    safeSetState(() {
      _model.isLoading = true;
      _model.errorMessage = null;
      _model.reset();
    });

    try {
      // Firestore range query: prefix on inventory_name
      // Firestore supports "starts with" using \uf8ff as upper bound
      final upper = q + '\uf8ff';
      final snap = await FirebaseFirestore.instance
          .collection('Inventory')
          .where('inventory_name', isGreaterThanOrEqualTo: q)
          .where('inventory_name', isLessThan: upper)
          .limit(100)
          .get();

      // Client-side pass: also match description contains
      final lower = q.toLowerCase();
      final all = <InventoryRecord>[];

      for (final doc in snap.docs) {
        all.add(InventoryRecord.fromSnapshot(doc));
      }

      // Second query for description matches (only if not enough results)
      if (all.length < 20) {
        final fallbackSnap = await FirebaseFirestore.instance
            .collection('Inventory')
            .orderBy('inventory_name')
            .limit(200)
            .get();
        final seenIds = all.map((r) => r.reference.id).toSet();
        for (final doc in fallbackSnap.docs) {
          if (seenIds.contains(doc.id)) continue;
          final data = doc.data();
          final name = (data['inventory_name'] ?? '').toString().toLowerCase();
          final desc =
              (data['inventory_description'] ?? '').toString().toLowerCase();
          if (name.contains(lower) || desc.contains(lower)) {
            all.add(InventoryRecord.fromSnapshot(doc));
          }
        }
      }

      if (mounted) {
        safeSetState(() {
          _model.allResults = all;
          _model.isLoading = false;
          _model.applyFilters();

          // Save to history (async, no await)
          _saveSearchHistory(q);
        });
      }
    } catch (e) {
      if (mounted) {
        safeSetState(() {
          _model.isLoading = false;
          _model.errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _saveSearchHistory(String term) async {
    if (currentUserReference == null) return;
    try {
      // Prevent duplicates: delete older identical entries first
      final existing = await FirebaseFirestore.instance
          .collection('search_history')
          .where('user_ref', isEqualTo: currentUserReference)
          .where('search_term', isEqualTo: term)
          .get();
      for (final d in existing.docs) {
        await d.reference.delete();
      }
      await FirebaseFirestore.instance.collection('search_history').add({
        'user_ref': currentUserReference,
        'search_term': term,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  void _clearHistory() async {
    if (currentUserReference == null) return;
    try {
      final snap = await FirebaseFirestore.instance
          .collection('search_history')
          .where('user_ref', isEqualTo: currentUserReference)
          .get();
      for (final d in snap.docs) {
        await d.reference.delete();
      }
      if (mounted) safeSetState(() => _model.recentSearches = []);
    } catch (_) {}
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
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
              if (_model.showFilters) _buildFiltersPanel(),
              Expanded(child: _buildBody()),
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
      padding: EdgeInsetsDirectional.fromSTEB(0, topPad + 8, 0, 14),
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
      child: Column(
        children: [
          // Title row
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
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 22),
                  onPressed: () => context.safePop(),
                ),
                const SizedBox(width: 6),
                const Text('Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    )),
                const Spacer(),
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 24,
                  borderWidth: 1,
                  buttonSize: 40,
                  fillColor: Colors.white.withOpacity(0.18),
                  icon: Icon(
                    _model.showFilters
                        ? Icons.tune_rounded
                        : Icons.tune_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => safeSetState(
                      () => _model.showFilters = !_model.showFilters),
                ),
              ],
            ),
          ),

          // White search bar
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: Container(
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
                  const Icon(Icons.search_rounded, color: kMutedDark, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _model.searchController,
                      focusNode: _model.searchFocusNode,
                      autofocus: true,
                      onChanged: _onQueryChanged,
                      onSubmitted: (v) => _runSearch(v),
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: kGreen,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Search products...',
                        hintStyle: TextStyle(
                          color: kMutedDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  if (_model.searchController!.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: kMutedDark, size: 20),
                      onPressed: () {
                        _model.searchController?.clear();
                        safeSetState(() {
                          _model.query = '';
                          _model.allResults = [];
                          _model.visibleResults = [];
                        });
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
  // FILTERS PANEL
  // ═══════════════════════════════════════════════════════════
  Widget _buildFiltersPanel() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chips
          Text('CATEGORY',
              style: TextStyle(
                color: _muted,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              )),
          const SizedBox(height: 8),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: SearchModel.kCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final cat = SearchModel.kCategories[i];
                final active = (_model.selectedCategory ?? 'All') == cat;
                return GestureDetector(
                  onTap: () {
                    safeSetState(() {
                      _model.selectedCategory = cat == 'All' ? null : cat;
                      _model.reset();
                      _model.applyFilters();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? kGreen : _soft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: active ? Colors.white : _text,
                        fontSize: 12,
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          // Price range
          Row(
            children: [
              Text('PRICE',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  )),
              const Spacer(),
              Text(
                '${_model.priceRange.start.toStringAsFixed(0)} — ${_model.priceRange.end.toStringAsFixed(0)} TZS',
                style: TextStyle(
                  color: _text,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _model.priceRange,
            min: SearchModel.minPrice,
            max: SearchModel.maxPrice,
            divisions: 100,
            activeColor: kGreen,
            inactiveColor: _border,
            labels: RangeLabels(
              _model.priceRange.start.toStringAsFixed(0),
              _model.priceRange.end.toStringAsFixed(0),
            ),
            onChanged: (v) =>
                safeSetState(() => _model.priceRange = v),
            onChangeEnd: (_) {
              _model.reset();
              _model.applyFilters();
            },
          ),
          const SizedBox(height: 6),

          // Sort dropdown
          Row(
            children: [
              Text('SORT BY',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  )),
              const Spacer(),
              DropdownButtonHideUnderline(
                child: DropdownButton<SearchSort>(
                  value: _model.sort,
                  dropdownColor: _card,
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: _muted, size: 20),
                  style: TextStyle(color: _text, fontSize: 13),
                  onChanged: (v) {
                    if (v == null) return;
                    safeSetState(() {
                      _model.sort = v;
                      _model.reset();
                      _model.applyFilters();
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                        value: SearchSort.relevance,
                        child: Text('Relevance')),
                    DropdownMenuItem(
                        value: SearchSort.newest,
                        child: Text('Newest')),
                    DropdownMenuItem(
                        value: SearchSort.priceLow,
                        child: Text('Price ↑')),
                    DropdownMenuItem(
                        value: SearchSort.priceHigh,
                        child: Text('Price ↓')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // BODY
  // ═══════════════════════════════════════════════════════════
  Widget _buildBody() {
    final q = _model.searchController!.text.trim();

    // Idle state — show recent + trending
    if (q.isEmpty) return _buildIdle();

    // Loading
    if (_model.isLoading && _model.visibleResults.isEmpty) {
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

    // Error
    if (_model.errorMessage != null) {
      return _errorState(_model.errorMessage!);
    }

    // Empty
    if (_model.visibleResults.isEmpty) {
      return _emptyState(q);
    }

    // Results
    return _buildResults();
  }

  Widget _buildIdle() {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent
          if (_model.recentSearches.isNotEmpty) ...[
            Row(
              children: [
                Text('RECENT',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    )),
                const Spacer(),
                GestureDetector(
                  onTap: _clearHistory,
                  child: const Text('Clear',
                      style: TextStyle(
                        color: kGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _model.recentSearches.map((term) {
                return _chip(term, Icons.history_rounded, () {
                  _model.searchController?.text = term;
                  _model.query = term;
                  _runSearch(term);
                });
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Trending
          if (_model.trendingSearches.isNotEmpty) ...[
            Text('TRENDING',
                style: TextStyle(
                  color: _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                )),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _model.trendingSearches.asMap().entries.map((e) {
                return _chip(
                  e.value,
                  Icons.trending_up_rounded,
                  () {
                    _model.searchController?.text = e.value;
                    _model.query = e.value;
                    _runSearch(e.value);
                  },
                  rank: e.key + 1,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Category shortcuts
          Text('BROWSE BY CATEGORY',
              style: TextStyle(
                color: _muted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              )),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SearchModel.kCategories.skip(1).take(12).map((cat) {
              return _chip(cat, Icons.category_outlined, () {
                _model.searchController?.text = cat;
                _model.query = cat;
                _runSearch(cat);
              });
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, IconData icon, VoidCallback onTap,
      {int? rank}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (rank != null) ...[
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: rank <= 3 ? kGreen : _soft,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('$rank',
                      style: TextStyle(
                        color: rank <= 3 ? Colors.white : _muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      )),
                ),
              ),
              const SizedBox(width: 8),
            ] else ...[
              Icon(icon, color: _muted, size: 14),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: _text,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return RefreshIndicator(
      color: kGreen,
      onRefresh: () async {
        // Re-run the search with current query
        final q = _model.query.trim();
        if (q.isNotEmpty) {
          await _runSearch(q);
        }
        safeSetState(() {});
      },
      child: ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 24),
      itemCount: _model.visibleResults.length + (_model.hasMore ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= _model.visibleResults.length) {
          // Loading more strip
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                ),
              ),
            ),
          );
        }

        final r = _model.visibleResults[i];
        return _resultCard(r);
      },
      ),
    );
  }

  Widget _resultCard(InventoryRecord r) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.pushNamed(
        ProductDetailsWidget.routeName,
        queryParameters: {
          'inventoryRef':
              serializeParam(r.reference, ParamType.DocumentReference),
        }.withoutNulls,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(4),
              child: Image.network(
                _imgUrl(valueOrDefault<String>(
                    r.inventoryImages.firstOrNull, '')),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                    Icons.image_not_supported_outlined,
                    color: _muted,
                    size: 22),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    valueOrDefault<String>(r.inventoryName, 'Product'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _text,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: kGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          r.categories,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: kGreen,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        formatNumber(
                          r.inventoryPrice,
                          formatType: FormatType.decimal,
                          decimalType: DecimalType.automatic,
                          currency: 'TZS ',
                        ),
                        style: const TextStyle(
                          color: kGreen,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      if (r.rating > 0) ...[
                        const Icon(Icons.star_rounded,
                            color: kAmber, size: 13),
                        const SizedBox(width: 3),
                        Text(
                          r.rating.toStringAsFixed(1),
                          style: TextStyle(
                            color: _muted,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String q) {
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
                color: kGreen.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off_rounded,
                  color: kGreen, size: 40),
            ),
            const SizedBox(height: 16),
            Text('No results for "$q"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _text,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 6),
            Text(
              'Try a different keyword or check the spelling.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                _model.searchController?.clear();
                safeSetState(() {
                  _model.query = '';
                  _model.allResults = [];
                  _model.visibleResults = [];
                });
              },
              child: const Text('Clear search',
                  style: TextStyle(
                    color: kGreen,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: kRed, size: 48),
            const SizedBox(height: 12),
            Text('Search failed',
                style: TextStyle(
                  color: _text,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 6),
            Text(msg,
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

const Color kMutedDark = Color(0xFF6B7280);
