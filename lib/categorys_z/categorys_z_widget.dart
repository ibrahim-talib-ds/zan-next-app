import '/auth/firebase_auth/auth_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/admin_category/admin_category_editor.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'categorys_z_model.dart';
export 'categorys_z_model.dart';

class CategorysZWidget extends StatefulWidget {
  const CategorysZWidget({super.key});

  static String routeName = 'CategorysZ';
  static String routePath = '/categorysZ';

  @override
  State<CategorysZWidget> createState() => _CategorysZWidgetState();
}

class _CategorysZWidgetState extends State<CategorysZWidget>
    with TickerProviderStateMixin {
  late CategorysZModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen     = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);

  // ─── Theme-aware colors (dark + light) ───
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get kBg     => _isDark ? Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get kCard   => _isDark ? Color(0xFF1C1C1E) : Colors.white;
  Color get kText   => _isDark ? Colors.white : Color(0xFF111827);
  Color get kMuted  => _isDark ? Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get kBorder => _isDark ? Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

  late final Stream<List<InventoryRecord>> _trendingStream;
  late final Stream<List<InventoryRecord>> _newStream;

  final List<List<String>> _categories = const [
    ['https://static.vecteezy.com/system/resources/thumbnails/070/259/583/small/men-s-autumnal-ensemble-on-isolated-transparent-background-displaying-elegant-fashion-png.png', "Men's Wear", 'Men’s Wear'],
    ['https://static.vecteezy.com/system/resources/thumbnails/042/154/757/small/ai-generated-beautiful-women-dress-isolated-on-transparent-background-free-png.png', "Women's Wear", 'Women’s Wear'],
    ['https://rosepng.com/wp-content/uploads/2025/07/s11728_kids_wear_isolated_on_white_background_-v_6-1_e752b563-39a6-4cfd-ab80-d300418034dd_0-photoroom.png', "Kids' Clothing", 'Kids’ Clothing'],
    ['https://cdn-icons-png.flaticon.com/512/2806/2806220.png', 'Shorts Sporty', 'Shorts Sporty'],
    ['https://static.vecteezy.com/system/resources/previews/070/649/690/non_2x/men-s-shorts-apparel-casual-summer-fashion-on-transparent-background-free-png.png', 'Shorts Casual', 'Shorts Casual'],
    ['https://img.vitkac.com/uploads/product_thumb/SLIPY%20M3D03J%20ONN97-S8291/lg/1.png', 'Underwear', 'Underwear'],
    ['https://png.pngtree.com/png-vector/20250210/ourmid/pngtree-aesthetic-single-sock-accessory-isolated-for-fashion-png-image_15432455.png', 'Socks', 'Socks'],
    ['https://png.pngtree.com/png-vector/20230501/ourmid/pngtree-sneakers-a-pair-of-running-shoes-png-image_7078541.png', 'Sneakers', 'Sneakers & Sports'],
    ['https://png.pngtree.com/png-vector/20250512/ourmid/pngtree-brown-formal-shoes-with-shining-leather-polish-neatly-arranged-elegant-style-png-image_16220207.png', 'Formal Shoes', 'Formal Shoes'],
    ['https://png.pngtree.com/png-vector/20260521/ourmid/pngtree-teal-colorful-strap-sandals-footwear-summer-vacation-beach-shoes-for-women-png-image_19274617.webp', 'Sandals', 'Sandals & Slippers'],
    ['https://png.pngtree.com/png-vector/20250320/ourmid/pngtree-trendy-blue-platform-high-heels-on-transparent-background-png-image_15748351.png', 'Heels', 'Heels & Wedge'],
    ['https://png.pngtree.com/png-vector/20250119/ourmid/pngtree-laptop-with-windows-11-pro-png-image_15276820.png', 'Computers', 'Computers & Laptops'],
    ['https://png.pngtree.com/png-clipart/20210309/original/pngtree-smart-mobile-phones-mockup-png-image_5893103.png', 'Smart Phone', 'Smart Phone'],
    ['https://png.pngtree.com/png-vector/20241124/ourmid/pngtree-towering-speakers-that-bring-style-and-sound-together-png-image_14523229.png', 'Audio', 'Audio & Sound'],
    ['https://static.vecteezy.com/system/resources/previews/035/197/725/non_2x/cosmetics-products-transparent-background-fashion-outfit-profucts-png.png', 'Skincare', 'Skincare'],
    ['https://png.pngtree.com/png-clipart/20210523/original/pngtree-perfume-fragrance-liquid-png-image_6325986.jpg', 'Fragrances', 'Fragrances'],
    ['https://static.vecteezy.com/system/resources/thumbnails/075/119/044/small/hair-care-product-bottle-with-blonde-hair-rose-png.png', 'Hair Care', 'Hair Care'],
    ['https://png.pngtree.com/png-clipart/20230506/original/pngtree-makeup-female-cosmetics-png-image_9143399.png', 'Makeup', 'Makeup'],
    ['https://png.pngtree.com/png-clipart/20240321/original/pngtree-light-bulb-isolated-on-white-or-transparent-background-cutout-png-image_14646805.png', 'Lighting', 'Lighting'],
    ['https://png.pngtree.com/png-clipart/20250207/original/pngtree-minimalist-wall-art-frame-for-modern-home-decor-with-transparent-background-png-image_20367147.png', 'Wall Art', 'Wall Art'],
    ['https://www.pngall.com/wp-content/uploads/11/Wooden-Furniture-Chair-PNG-Photo.png', 'Furniture', 'Furniture'],
    ['https://pngimg.com/uploads/bed/bed_PNG17409.png', 'Bedding', 'Bedding'],
    ['https://png.pngtree.com/png-vector/20231023/ourmid/pngtree-assortment-of-produce-on-a-blank-png-image_10173654.png', 'Fresh Produce', 'Fresh Produce'],
    ['https://png.pngtree.com/png-clipart/20231005/original/pngtree-full-bag-of-flour-with-wheat-ears-illustration-png-image_13123698.png', 'Grains', 'Grains & Flour'],
    ['https://png.pngtree.com/png-clipart/20250210/original/pngtree-refreshing-assortment-of-soft-drinks-on-transparent-background-1-png-image_20413963.png', 'Beverages', 'Beverages'],
    ['https://png.pngtree.com/png-clipart/20250111/original/pngtree-snacks-png-image_19912509.png', 'Snacks', 'Snacks'],
    ['https://png.pngtree.com/png-vector/20250422/ourmid/pngtree-smart-watch-white-color-png-image_16057996.png', 'Wearables', 'Wearables'],
    ['https://png.pngtree.com/png-vector/20240715/ourmid/pngtree-cell-phone-accessories-psd-png-image_13095675.png', 'Mobile Accessories', 'Mobile Accessories'],
    ['https://static.vecteezy.com/system/resources/thumbnails/071/183/345/small/smart-home-device-illustration-wifi-signal-png.png', 'Smart Home', 'Smart Home'],
    ['https://png.pngtree.com/png-vector/20230831/ourmid/pngtree-sports-balls-3d-illustration-png-image_9235520.png', 'Team Sports', 'Team Sports'],
    ['https://png.pngtree.com/png-clipart/20240905/original/pngtree-gym-fitness-t-shirts-design-it-never-gets-easier-you-just-png-image_15938057.png', 'Gym & Fitness', 'Gym & Fitness'],
    ['https://png.pngtree.com/png-vector/20250429/ourmid/pngtree-wicker-basket-ready-for-use-in-outdoor-concepts-png-image_16134181.png', 'Outdoor', 'Outdoor'],
    ['https://png.pngtree.com/png-clipart/20250111/original/pngtree-luxury-watche-png-image_19806288.png', 'Luxury Watches', 'Luxury Watches'],
    ['https://www.nixon.com/cdn/shop/files/A1370-5191-view1.png?v=1718725113', 'Digital Watches', 'Digital Watches'],
    ['https://png.pngtree.com/png-vector/20260527/ourmid/pngtree-wall-clock-image-png-image_19195399.webp', 'Wall Clocks', 'Wall Clocks'],
    ['https://png.pngtree.com/png-clipart/20241101/original/pngtree-colorful-learning-playthings-isolated-png-image_16591879.png', 'Educational Toys', 'Educational Toys'],
    ['https://freepngimg.com/thumb/baby_girl/35560-9-baby-girl-clipart-thumb.png', 'Baby Gear', 'Baby Gear'],
    ['https://png.pngtree.com/png-vector/20250801/ourmid/pngtree-cute-little-girl-driving-children39s-electric-toy-car-on-white-background-png-image_16952144.webp', 'Electronic Toys', 'Electronic Toys'],
    ['https://pngimg.com/uploads/vitamins/vitamins_PNG5.png', 'Supplements', 'Supplements'],
    ['https://static.vecteezy.com/system/resources/thumbnails/013/271/454/small/3d-render-hospital-patient-bed-png.png', 'Medical Equipment', 'Medical Equipment'],
    ['https://static.vecteezy.com/system/resources/previews/073/094/780/non_2x/assortment-of-personal-hygiene-products-in-a-green-container-transparent-background-free-png.png', 'Personal Hygiene', 'Personal Hygiene'],
    ['https://static.vecteezy.com/system/resources/thumbnails/059/322/044/small/3d-pen-holder-office-equipment-set-png.png', 'Stationery', 'Stationery'],
    ['https://png.pngtree.com/png-vector/20231115/ourmid/pngtree-set-of-stationery-items-office-png-image_10465196.png', 'Office Tech', 'Office Tech'],
    ['https://png.pngtree.com/png-vector/20241225/ourmid/pngtree-organized-office-desk-setup-png-image_14877007.png', 'Organization', 'Organization'],
    ['https://static.vecteezy.com/system/resources/thumbnails/024/952/067/small/car-tools-equipment-and-accessories-set-of-automobile-accessory-spare-parts-car-3d-illustration-png.png', 'Car Parts', 'Car Parts'],
    ['https://png.pngtree.com/png-clipart/20241001/original/pngtree-red-and-black-beautiful-car-seat-png-image_16154743.png', 'Interior Accessories', 'Interior Accessories'],
    ['https://png.pngtree.com/png-vector/20250715/ourmid/pngtree-realistic-stack-of-four-car-tires-with-shiny-alloy-wheels-on-png-image_16769611.webp', 'Tires & Rims', 'Tires & Rims'],
    ['https://png.pngtree.com/png-clipart/20250115/original/pngtree-aluminum-modular-kitchen-png-image_20150164.png', 'Kitchen', 'Kitchen'],
    ['https://png.pngtree.com/png-vector/20240403/ourmid/pngtree-washing-machine-isolated-on-transparent-background-png-image_12260985.png', 'Laundry', 'Laundry'],
    ['https://static.vecteezy.com/system/resources/thumbnails/073/193/979/small/modern-air-conditioner-unit-with-blue-glowing-fan-isolated-on-transparency-background-energy-efficient-contemporary-design-cooling-appliance-home-comfort-png.png', 'Cooling', 'Cooling'],
    ['https://png.pngtree.com/png-vector/20230206/ourmid/pngtree-wedding-ring-box-png-image_6583781.png', 'Rings & Wedding', 'Rings & Wedding'],
    ['https://png.pngtree.com/png-vector/20260204/ourmid/pngtree-luxury-gift-box-necklace-elegant-gold-png-image_18709483.webp', 'Necklaces', 'Necklaces & Pendants'],
    ['https://png.pngtree.com/png-vector/20250321/ourmid/pngtree-indian-gold-jewellery-set-png-image_15804105.png', 'Bracelets', 'Bracelets & Earrings'],
    ['https://static.vecteezy.com/system/resources/thumbnails/011/648/980/small_2x/gift-card-3d-render-icon-illustration-png.png', 'Digital Cards', 'Digital Cards'],
    ['https://png.pngtree.com/png-clipart/20240306/original/pngtree-gift-box-png-image_14516601.png', 'Physical Gifts', 'Physical Gifts'],
  ];

  String _imgUrl(String? url) {
    final u = (url ?? '').trim();
    if (u.isEmpty) return '';
    return u.startsWith('http://') ? u.replaceFirst('http://', 'https://') : u;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CategorysZModel());

    _trendingStream = queryInventoryRecord(limit: 50);
    _newStream = queryInventoryRecord(
      queryBuilder: (r) => r.where('new_in', isEqualTo: true),
      limit: 50,
    );

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    if (index == 0) {
      context.pushNamed(HomeWidget.routeName);
    } else if (index == 1) {
      context.pushNamed(WishlistWidget.routeName);
    } else if (index == 2) {
      context.pushNamed(SelectAdWidget.routeName);
    } else if (index == 3) {
      context.pushNamed(MessagelistWidget.routeName);
    } else if (index == 4) {
      context.pushNamed(ProfileWidget.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kBg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _model.tabBarController,
                children: [
                  _buildCategoryTab(),
                  _buildTrendingTab(),
                  _buildNewProductsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 10),
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
                  'All Categories',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter Tight',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: InkWell(
              onTap: () {
                context.pushNamed(
                  SearchWidget.routeName,
                  extra: <String, dynamic>{
                    '__transition_info__': TransitionInfo(
                      hasTransition: true,
                      transitionType: PageTransitionType.bottomToTop,
                      duration: const Duration(milliseconds: 250),
                    ),
                  },
                );
              },
              borderRadius: BorderRadius.circular(22),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 6, 0),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: kMuted, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search Products...',
                        style: TextStyle(
                          color: kMuted,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: kGreen,
                        borderRadius: BorderRadius.circular(17),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    const labels = ['Category', 'Trending', 'New'];

    return Container(
      color: kBg,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 10),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isActive = _model.tabBarController?.index == i;
          return Padding(
            padding: EdgeInsets.only(right: i < labels.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () {
                _model.tabBarController?.animateTo(i);
                safeSetState(() {});
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  color: isActive ? kGreen : kCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? kGreen : kBorder,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    color: isActive ? Colors.white : kText,
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryTab() {
    return Container(
      color: kBg,
      child: StreamBuilder<Map<String, Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('category_config')
            .snapshots()
            .map((snap) {
          final map = <String, Map<String, dynamic>>{};
          for (final doc in snap.docs) {
            map[doc.id] = doc.data();
          }
          return map;
        }),
        builder: (context, overrideSnap) {
          final overrides = overrideSnap.data ?? {};
          return _buildCategoryTabInner(overrides);
        },
      ),
    );
  }

  Widget _buildCategoryTabInner(Map<String, Map<String, dynamic>> overrides) {
    return Container(
      color: kBg,
      child: RefreshIndicator(
        color: kGreen,
        onRefresh: () async {
          safeSetState(() {});
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 0.72,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          // 🎨 Apply admin override if present
          final key = cat[2]; // categoryValue is the key
          final override = overrides[key];
          final displayImage = (override?['image_url'] as String?) ?? cat[0];
          final displayLabel = (override?['label'] as String?) ?? cat[1];
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () async {
              final isAdmin = valueOrDefault<bool>(
                      currentUserDocument?.isAdmin, false) ==
                  true;

              if (isAdmin) {
                await _showAdminCategoryMenu(key, displayImage, displayLabel);
                return;
              }

              FFAppState().categories = cat[2];
              safeSetState(() {});
              context.pushNamed(
                SpecificCategoriesWidget.routeName,
                extra: <String, dynamic>{
                  '__transition_info__': TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 250),
                  ),
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: kBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBorder.withOpacity(0.5)),
              ),
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _isDark
                            ? const Color(0xFF2A2A2C)
                            : const Color(0xFFF0F2F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Image.network(
                        _imgUrl(displayImage),
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          color: kGreen.withOpacity(0.1),
                          child: Icon(
                            Icons.category_outlined,
                            color: kGreen,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    displayLabel,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: kText,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      ),
    );
  }

  Widget _buildTrendingTab() => _buildProductTab(
        stream: _trendingStream,
        emptyMessage: 'No trending products yet',
        badgeFor: (_) => _fireBadge(),
      );

  Widget _buildNewProductsTab() => _buildProductTab(
        stream: _newStream,
        emptyMessage: 'No new products yet',
        badgeFor: (_) => _newBadge(),
      );

  Widget _buildProductTab({
    required Stream<List<InventoryRecord>> stream,
    required String emptyMessage,
    required Widget? Function(InventoryRecord) badgeFor,
  }) {
    return Container(
      color: kBg,
      child: StreamBuilder<List<InventoryRecord>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint('Inventory error: ${snapshot.error}');
            return _errorState('Could not load products\n${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                ),
              ),
            );
          }
          final items = snapshot.data!;
          if (items.isEmpty) return _emptyState(emptyMessage);

          // Responsive: 2 cols on phone, 3 on tablet, 4 on desktop
          final width = MediaQuery.of(context).size.width;
          final cols = width >= 1200
              ? 4
              : width >= 900
                  ? 3
                  : 2;

          return GridView.builder(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.66,
            ),
            itemCount: items.length,
            itemBuilder: (context, i) => _productCard(
              record: items[i],
              badge: badgeFor(items[i]),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PREMIUM PRODUCT CARD
  // ═══════════════════════════════════════════════════════════
  Widget _productCard({
    required InventoryRecord record,
    Widget? badge,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder, width: 1),
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
            extra: <String, dynamic>{
              '__transition_info__': TransitionInfo(
                hasTransition: true,
                transitionType: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 250),
              ),
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Image block ───
              Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        color: _isDark
                            ? const Color(0xFF2A2A2C)
                            : const Color(0xFFF0F2F5),
                        child: Image.network(
                          _imgUrl(valueOrDefault<String>(
                            record.inventoryImages.firstOrNull,
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyxz9T3n9wAdGgBp1oXZxkQMdECuc3cuvcOw&s',
                          )),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.image_not_supported_outlined,
                            color: kMuted,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    if (badge != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: badge,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // ─── Title ───
              Text(
                valueOrDefault<String>(record.inventoryName, 'Product'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 4),

              // ─── Price ───
              Text(
                valueOrDefault<String>(
                  formatNumber(
                    record.inventoryPrice,
                    formatType: FormatType.decimal,
                    decimalType: DecimalType.automatic,
                    currency: 'TZS ',
                  ),
                  'TZS 1,500',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFDC0F0F),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),

              // ─── Trust row ───
              Row(
                children: [
                  const Icon(Icons.verified_rounded,
                      color: kGreen, size: 10),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      valueOrDefault<String>(record.sellerName, 'Verified'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kMuted,
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

  Widget _fireBadge() => Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.local_fire_department_rounded,
          color: Color(0xFFE31B23),
          size: 18,
        ),
      );

  Widget _newBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFDC0F0F),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'NEW',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      );

  Widget _emptyState(String message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined, color: kMuted, size: 48),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: kMuted, fontSize: 14),
              ),
            ],
          ),
        ),
      );

  // ═══════════════════════════════════════════════════════════
  // ADMIN: Category menu (Edit / Continue)
  // ═══════════════════════════════════════════════════════════
  Future<void> _showAdminCategoryMenu(
    String categoryKey,
    String currentImage,
    String currentLabel,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44, height: 4,
              decoration: BoxDecoration(
                color: kBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              categoryKey,
              style: TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              'What do you want to do?',
              style: TextStyle(color: kMuted, fontSize: 12),
            ),
            const SizedBox(height: 20),
            _menuOption(
              ctx,
              icon: Icons.edit_rounded,
              label: 'Edit this category',
              subtitle: 'Change image or name',
              color: kGreen,
              value: 'edit',
            ),
            const SizedBox(height: 10),
            _menuOption(
              ctx,
              icon: Icons.arrow_forward_rounded,
              label: 'Continue to page',
              subtitle: 'Open category normally',
              color: const Color(0xFF3B82F6),
              value: 'continue',
            ),
          ],
        ),
      ),
    );

    if (!mounted || action == null) return;

    if (action == 'edit') {
      await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AdminCategoryEditor(
          categoryKey: categoryKey,
          currentImage: currentImage,
          currentLabel: currentLabel,
          currentRoute: 'Specific_categories',
        ),
      );
    } else if (action == 'continue') {
      FFAppState().categories = categoryKey;
      safeSetState(() {});
      context.pushNamed(
        SpecificCategoriesWidget.routeName,
        extra: <String, dynamic>{
          '__transition_info__': TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 250),
          ),
        },
      );
    }
  }

  Widget _menuOption(
    BuildContext ctx, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required String value,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pop(ctx, value),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(color: kMuted, fontSize: 11.5)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _errorState(String message) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: Color(0xFFDC0F0F), size: 48),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: kText, fontSize: 14),
              ),
            ],
          ),
        ),
      );
}
