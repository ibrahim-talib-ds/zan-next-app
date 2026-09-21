import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import 'search_widget.dart' show SearchWidget;
import 'package:flutter/material.dart';

/// Search sort options
enum SearchSort { relevance, newest, priceLow, priceHigh }

/// Full search state
class SearchModel extends FlutterFlowModel<SearchWidget> {
  // ─── Query ───
  FocusNode? searchFocusNode;
  TextEditingController? searchController;
  String query = '';
  bool isLoading = false;
  String? errorMessage;

  // ─── Filters ───
  String? selectedCategory;        // null = all categories
  RangeValues priceRange = const RangeValues(0, 10000000); // TZS
  SearchSort sort = SearchSort.relevance;
  bool showFilters = false;

  // ─── Results ───
  List<InventoryRecord> allResults = [];
  List<InventoryRecord> visibleResults = [];
  int page = 1;
  static const int pageSize = 20;
  bool hasMore = false;

  // ─── Sidebar data ───
  List<String> recentSearches = [];      // last 10 from this user
  List<String> trendingSearches = [];    // top 5 from all users
  List<String> suggestions = [];         // live autocomplete

  // Categories for chip filter
  static const List<String> kCategories = [
    'All',
    "Men's Wear",
    "Women's Wear",
    'Kids’ Clothing',
    'Sneakers & Sports',
    'Formal Shoes',
    'Sandals & Slippers',
    'Heels & Wedge',
    'Computers & Laptops',
    'Smart Phone',
    'Audio & Sound',
    'Skincare',
    'Fragrances',
    'Hair Care',
    'Makeup',
    'Lighting',
    'Wall Art',
    'Furniture',
    'Bedding',
    'Fresh Produce',
    'Grains & Flour',
    'Beverages',
    'Snacks',
    'Wearables',
    'Mobile Accessories',
    'Smart Home',
    'Team Sports',
    'Gym & Fitness',
    'Outdoor',
    'Luxury Watches',
    'Digital Watches',
    'Wall Clocks',
    'Educational Toys',
    'Baby Gear',
    'Electronic Toys',
    'Supplements',
    'Medical Equipment',
    'Personal Hygiene',
    'Stationery',
    'Office Tech',
    'Organization',
    'Car Parts',
    'Interior Accessories',
    'Tires & Rims',
    'Kitchen',
    'Laundry',
    'Cooling',
    'Rings & Wedding',
    'Necklaces & Pendants',
    'Bracelets & Earrings',
  ];

  // ─── Range limits ───
  static const double minPrice = 0;
  static const double maxPrice = 10000000;

  /// Apply filters + sort + pagination to `allResults`, updating `visibleResults`
  void applyFilters() {
    var filtered = List<InventoryRecord>.from(allResults);

    // 1. Category
    if (selectedCategory != null && selectedCategory != 'All') {
      filtered = filtered.where((r) =>
          r.categories.toLowerCase() ==
          selectedCategory!.toLowerCase()).toList();
    }

    // 2. Price range
    filtered = filtered
        .where((r) =>
            r.inventoryPrice >= priceRange.start &&
            r.inventoryPrice <= priceRange.end)
        .toList();

    // 3. Sort
    switch (sort) {
      case SearchSort.newest:
        filtered.sort((a, b) {
          final at = a.createdAt ?? DateTime(1970);
          final bt = b.createdAt ?? DateTime(1970);
          return bt.compareTo(at);
        });
        break;
      case SearchSort.priceLow:
        filtered.sort(
            (a, b) => a.inventoryPrice.compareTo(b.inventoryPrice));
        break;
      case SearchSort.priceHigh:
        filtered.sort(
            (a, b) => b.inventoryPrice.compareTo(a.inventoryPrice));
        break;
      case SearchSort.relevance:
        // Already sorted by relevance from the query stage — leave as-is
        break;
    }

    // 4. Pagination
    visibleResults = filtered.take(page * pageSize).toList();
    hasMore = filtered.length > page * pageSize;
  }

  void reset() {
    page = 1;
    visibleResults = [];
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchController?.dispose();
  }
}
