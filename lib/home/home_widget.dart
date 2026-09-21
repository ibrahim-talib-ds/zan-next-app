import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/location_modal/location_modal_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'package:badges/badges.dart' as badges;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'home_model.dart';
export 'home_model.dart';

/// ZanNext Home — professional e-commerce layout
/// Inspired by modern marketplace apps (AliExpress / Shopee style):
/// • Gradient header with location + notification
/// • Rounded search pill with orange border
/// • Horizontal category chip strip
/// • Clean banner slider (4 slides)
/// • "Shop by Category" grid
/// • Trending horizontal scroll
/// • New Arrivals horizontal scroll
/// • Full Catalog grid
class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = 'Home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Home'});

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('HOME_PAGE_Home_ON_INIT_STATE');
      logFirebaseEvent('Home_backend_call');

      if (currentUserReference != null) {
        await currentUserReference!.update(createUsersRecordData(
          isOnline: true,
          lastActive: getCurrentTimestamp,
          fcmToken: 'fcm_token ',
        ));
      }
    });

    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.9, 0.9),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              // ============ MAIN SCROLL CONTENT ============
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reserve space for the fixed header (170px tall)
                    SizedBox(height: 178),

                    // ============ BANNER SLIDER ============
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                      child: Container(
                        width: double.infinity,
                        height: 165,
                        child: Stack(
                          children: [
                            PageView(
                              controller: _model.pageViewController ??=
                                  PageController(initialPage: 0),
                              scrollDirection: Axis.horizontal,
                              children: [
                                _bannerSlide(
                                  context,
                                  title: 'Welcome to ZanNext!',
                                  subtitle: 'Get 20% OFF your first order',
                                  buttonLabel: 'Claim Offer',
                                  imageUrl:
                                      'https://file.aiquickdraw.com/imgcompressed/img/compressed_a7c9025e07be618d506d670cfefc3a95.webp',
                                  gradientColors: [
                                    theme.primary,
                                    Color(0xFF053020),
                                  ],
                                ),
                                _bannerSlide(
                                  context,
                                  title: 'Fresh Today',
                                  subtitle: 'Shop the latest trends in town',
                                  buttonLabel: 'Shop Newest',
                                  imageUrl:
                                      'https://file.aiquickdraw.com/imgcompressed/img/compressed_a7c9025e07be618d506d670cfefc3a95.webp',
                                  gradientColors: [
                                    theme.primary,
                                    theme.tertiary,
                                  ],
                                ),
                                _bannerSlide(
                                  context,
                                  title: 'Fast & Secure Delivery',
                                  subtitle: 'From our store to your door',
                                  buttonLabel: 'Order Now',
                                  imageUrl:
                                      'https://file.aiquickdraw.com/imgcompressed/img/compressed_a7c9025e07be618d506d670cfefc3a95.webp',
                                  gradientColors: [
                                    theme.primary,
                                    theme.primary,
                                  ],
                                ),
                                _bannerSlide(
                                  context,
                                  title: 'Quality You Can Trust',
                                  subtitle: 'Premium products, best prices',
                                  buttonLabel: 'Shop Quality',
                                  imageUrl:
                                      'https://file.aiquickdraw.com/imgcompressed/img/compressed_a7c9025e07be618d506d670cfefc3a95.webp',
                                  gradientColors: [
                                    theme.primary,
                                    theme.tertiary,
                                  ],
                                ),
                                _bannerSlide(
                                  context,
                                  title: 'We\'re Here for You',
                                  subtitle: '24/7 Dedicated Customer Support',
                                  buttonLabel: 'Chat With Us',
                                  imageUrl:
                                      'https://file.aiquickdraw.com/imgcompressed/img/compressed_a7c9025e07be618d506d670cfefc3a95.webp',
                                  gradientColors: [
                                    theme.primary,
                                    Color(0xFF053020),
                                  ],
                                ),
                              ],
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 1),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child:
                                    smooth_page_indicator.SmoothPageIndicator(
                                  controller: _model.pageViewController ??=
                                      PageController(initialPage: 0),
                                  count: 5,
                                  axisDirection: Axis.horizontal,
                                  onDotClicked: (i) async {
                                    await _model.pageViewController!
                                        .animateToPage(
                                      i,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease,
                                    );
                                    safeSetState(() {});
                                  },
                                  effect: smooth_page_indicator.SlideEffect(
                                    spacing: 6,
                                    radius: 6,
                                    dotWidth: 16,
                                    dotHeight: 6,
                                    dotColor: Colors.white54,
                                    activeDotColor: Colors.white,
                                    paintStyle: PaintingStyle.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 18),

                    // ============ SHOP CATEGORY HEADER ============
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText(
                              'c7gxdsxp' /* Shop Category */,
                            ),
                            style: theme.titleMedium.override(
                              font: GoogleFonts.interTight(
                                fontWeight: FontWeight.w700,
                                fontStyle: theme.titleMedium.fontStyle,
                              ),
                              color: theme.primaryText,
                              fontSize: 17,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w700,
                              fontStyle: theme.titleMedium.fontStyle,
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              logFirebaseEvent(
                                  'HOME_PAGE_Text_hg2jy5i1_ON_TAP');
                              logFirebaseEvent('Text_navigate_to');

                              context.pushNamed(
                                CategorysZWidget.routeName,
                                extra: <String, dynamic>{
                                  '__transition_info__': TransitionInfo(
                                    hasTransition: true,
                                    transitionType:
                                        PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 250),
                                  ),
                                },
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'pmhmguyd' /* See all */,
                                  ),
                                  style: theme.bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: theme.bodyMedium.fontStyle,
                                    ),
                                    color: theme.primary,
                                    fontSize: 13,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: theme.bodyMedium.fontStyle,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: theme.primary,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12),

                    // ============ CATEGORY GRID (2 ROWS x 4) ============
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      child: GridView(
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.72,
                        ),
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          _categoryTile(
                            context,
                            assetImage: 'assets/images/copm.png',
                            labelKey: 'hi3oa9pn',
                            fallback: 'Computers & Laptops',
                            categoryValue: 'Computers & Laptops',
                          ),
                          _categoryTile(
                            context,
                            assetImage: 'assets/images/mean.webp',
                            labelKey: 'ckkjz6bw',
                            fallback: 'Men’s Wear',
                            categoryValue: 'Men’s Wear',
                          ),
                          _categoryTile(
                            context,
                            assetImage: 'assets/images/furniture.png',
                            labelKey: '4gctyhxj',
                            fallback: 'Furniture',
                            categoryValue: 'Furniture',
                          ),
                          _categoryTile(
                            context,
                            assetImage: 'assets/images/W.webp',
                            labelKey: 'pv0ughiu',
                            fallback: 'Wearables',
                            categoryValue: 'Wearables',
                          ),
                          _categoryTile(
                            context,
                            assetImage: 'assets/images/Luxiary.webp',
                            labelKey: 'bbomrrnb',
                            fallback: 'Luxury Watches',
                            categoryValue: 'Luxury Watches',
                          ),
                          _categoryTile(
                            context,
                            assetImage: 'assets/images/9f05b_B.png',
                            labelKey: 'w9tkhbbf',
                            fallback: 'Bracelets & Earrings',
                            categoryValue: 'Bracelets & Earrings',
                          ),
                          _categoryTile(
                            context,
                            assetImage: 'assets/images/1yi0p_L.png',
                            labelKey: 'ywg5460f',
                            fallback: 'Laundry',
                            categoryValue: 'Laundry',
                          ),
                          _moreTile(context),
                        ],
                      ),
                    ),

                    SizedBox(height: 22),

                    // ============ TRENDING PRODUCTS ============
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: theme.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                FFLocalizations.of(context).getText(
                                  '4n96ea24' /* Trending Products */,
                                ),
                                style: theme.titleMedium.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: theme.titleMedium.fontStyle,
                                  ),
                                  color: theme.primaryText,
                                  fontSize: 17,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: theme.titleMedium.fontStyle,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              logFirebaseEvent(
                                  'HOME_PAGE_Text_f472uas1_ON_TAP');
                              logFirebaseEvent('Text_navigate_to');

                              context.pushNamed(
                                TrendingProductWidget.routeName,
                                extra: <String, dynamic>{
                                  '__transition_info__': TransitionInfo(
                                    hasTransition: true,
                                    transitionType:
                                        PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 250),
                                  ),
                                },
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'jvt45nus' /* See All */,
                                  ),
                                  style: theme.bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: theme.bodyMedium.fontStyle,
                                    ),
                                    color: theme.primary,
                                    fontSize: 13,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: theme.bodyMedium.fontStyle,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: theme.primary,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8),

                    SizedBox(
                      height: 258,
                      child: StreamBuilder<List<InventoryRecord>>(
                        stream: queryInventoryRecord(
                          queryBuilder: (inventoryRecord) => inventoryRecord
                              .where('top_selling', isEqualTo: true)
                              .orderBy('view_count', descending: true),
                          limit: 200,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.primary,
                                  ),
                                ),
                              ),
                            );
                          }
                          final items = snapshot.data!;

                          if (items.isEmpty) {
                            return _emptyState(
                              context,
                              'No trending products yet',
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 6, 10, 6),
                                child: _productCard(
                                  context,
                                  record: items[index],
                                  badge: _badgeFire(context),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20),

                    // ============ NEW ARRIVALS ============
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: theme.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                FFLocalizations.of(context).getText(
                                  'nysb51jq' /* New Arrivals */,
                                ),
                                style: theme.titleMedium.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: theme.titleMedium.fontStyle,
                                  ),
                                  color: theme.primaryText,
                                  fontSize: 17,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: theme.titleMedium.fontStyle,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              logFirebaseEvent(
                                  'HOME_PAGE_Text_qig1o0ss_ON_TAP');
                              logFirebaseEvent('Text_navigate_to');

                              context.pushNamed(
                                NewProductsWidget.routeName,
                                extra: <String, dynamic>{
                                  '__transition_info__': TransitionInfo(
                                    hasTransition: true,
                                    transitionType:
                                        PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 250),
                                  ),
                                },
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    '1s49pc9s' /* See All */,
                                  ),
                                  style: theme.bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: theme.bodyMedium.fontStyle,
                                    ),
                                    color: theme.primary,
                                    fontSize: 13,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: theme.bodyMedium.fontStyle,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: theme.primary,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8),

                    SizedBox(
                      height: 248,
                      child: StreamBuilder<List<InventoryRecord>>(
                        stream: queryInventoryRecord(
                          queryBuilder: (inventoryRecord) =>
                              inventoryRecord.where('new_in', isEqualTo: true),
                          limit: 100,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.primary,
                                  ),
                                ),
                              ),
                            );
                          }
                          final items = snapshot.data!;

                          if (items.isEmpty) {
                            return _emptyState(
                              context,
                              'No new arrivals yet',
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 6, 10, 6),
                                child: _productCard(
                                  context,
                                  record: item,
                                  badge: item.newIn == true
                                      ? _badgeNew(context)
                                      : null,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20),

                    // ============ SELLER CTA BANNER ============
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          logFirebaseEvent(
                              'HOME_PAGE_Container_pvqlulbp_ON_TAP');
                          logFirebaseEvent('Container_navigate_to');

                          context.pushNamed(
                            SelectAdWidget.routeName,
                            extra: <String, dynamic>{
                              '__transition_info__': TransitionInfo(
                                hasTransition: true,
                                transitionType:
                                    PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 250),
                              ),
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            color: theme.secondary,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.asset(
                                'assets/images/Sub_banner.png',
                              ).image,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'npwssap5' /* Start selling and achieve
your goals */,
                                  ),
                                  style: theme.bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: theme.bodyMedium.fontStyle,
                                    ),
                                    color: theme.primary,
                                    fontSize: 18,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: theme.bodyMedium.fontStyle,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  width: 190,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: theme.secondaryBackground,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Center(
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        '1ks3t7d1' /* New Products */,
                                      ),
                                      style: theme.bodyMedium.override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              theme.bodyMedium.fontStyle,
                                        ),
                                        color: theme.primaryText,
                                        fontSize: 16,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle:
                                            theme.bodyMedium.fontStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 22),

                    // ============ FULL CATALOG ============
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 18,
                            decoration: BoxDecoration(
                              color: theme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            FFLocalizations.of(context).getText(
                              '4gyar5ix' /* Full Catalog */,
                            ),
                            style: theme.titleMedium.override(
                              font: GoogleFonts.interTight(
                                fontWeight: FontWeight.w700,
                                fontStyle: theme.titleMedium.fontStyle,
                              ),
                              color: theme.primaryText,
                              fontSize: 17,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w700,
                              fontStyle: theme.titleMedium.fontStyle,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12),

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      child: StreamBuilder<List<InventoryRecord>>(
                        stream: queryInventoryRecord(
                          queryBuilder: (inventoryRecord) => inventoryRecord
                              .where('all_products', isEqualTo: true),
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          final items = snapshot.data!;

                          if (items.isEmpty) {
                            return _emptyState(
                              context,
                              'No products available',
                            );
                          }

                          return GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.68,
                            ),
                            primary: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return _productCard(
                                context,
                                record: item,
                                badge: null,
                                width: null,
                                height: null,
                              );
                            },
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 24),
                  ],
                ),
              ),

              // ============ FIXED PROFESSIONAL HEADER ============
              _buildHeader(context),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER — gradient top bar with location + notification
  // + rounded search pill
  // ============================================================
  Widget _buildHeader(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final topPad = MediaQuery.of(context).padding.top;

    return Align(
      alignment: AlignmentDirectional(0, -1),
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primary,
              Color(0xFF053020),
            ],
            stops: [0, 1],
            begin: AlignmentDirectional(0, -1),
            end: AlignmentDirectional(0, 1),
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: topPad + 12),

            // -------- Row 1: location + notification --------
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Location pill
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        logFirebaseEvent('HOME_PAGE_Row_rh81ucyu_ON_TAP');
                        logFirebaseEvent('Row_bottom_sheet');
                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Color(0x98000000),
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: LocationModalWidget(),
                              ),
                            );
                          },
                        ).then((value) => safeSetState(() {}));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/zannext_logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Deliver to',
                                  style: theme.bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.normal,
                                      fontStyle:
                                          theme.bodyMedium.fontStyle,
                                    ),
                                    color: Colors.white70,
                                    fontSize: 11,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: theme.bodyMedium.fontStyle,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: StreamBuilder<List<AddressRecord>>(
                                        stream: queryAddressRecord(
                                          queryBuilder: (r) => r.where('user',
                                              isEqualTo: currentUserReference),
                                          singleRecord: true,
                                        ),
                                        builder: (context, snapshot) {
                                          // Default fallback = Zanzibar
                                          String label = 'Zanzibar';
                                          if (snapshot.hasData &&
                                              snapshot.data!.isNotEmpty) {
                                            final a = snapshot.data!.first;
                                            if (a.hasCity() &&
                                                a.city.isNotEmpty &&
                                                a.city != 'Set your city') {
                                              label = a.city;
                                            }
                                          }
                                          return Text(
                                            label,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.bodyMedium.override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w700,
                                                fontStyle:
                                                    theme.bodyMedium.fontStyle,
                                              ),
                                              color: Colors.white,
                                              fontSize: 14,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w700,
                                              fontStyle:
                                                  theme.bodyMedium.fontStyle,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Notification button — always visible, real-time count
                  AuthUserStreamWidget(
                    builder: (context) => StreamBuilder<
                        List<NotificationsRecord>>(
                      stream: queryNotificationsRecord(
                        queryBuilder: (notificationsRecord) =>
                            notificationsRecord
                                .where('user_ref',
                                    isEqualTo: currentUserReference)
                                .where('is_read', isEqualTo: false),
                      ),
                      builder: (context, snapshot) {
                        final count = snapshot.data?.length ?? 0;
                        return _notificationButton(
                          context,
                          count: count,
                          showBadge: count >= 1,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // -------- Row 2: search pill --------
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  logFirebaseEvent('HOME_PAGE_Container_is0fbmqo_ON_TAP');
                  logFirebaseEvent('Container_navigate_to');

                  context.pushNamed(
                    SearchWidget.routeName,
                    extra: <String, dynamic>{
                      '__transition_info__': TransitionInfo(
                        hasTransition: true,
                        transitionType: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 250),
                      ),
                    },
                  );
                },
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: theme.primary,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 6, 0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: theme.secondaryText,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'gdj7z02c' /* Search for products... */,
                          ),
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontStyle: theme.bodyMedium.fontStyle,
                            ),
                            color: theme.secondaryText,
                            fontSize: 14,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: theme.bodyMedium.fontStyle,
                          ),
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.primary,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
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
      ),
    );
  }

  Widget _notificationButton(
    BuildContext context, {
    required int count,
    required bool showBadge,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return badges.Badge(
      showBadge: showBadge,
      badgeContent: Text(
        valueOrDefault<String>(
          formatNumber(count, formatType: FormatType.compact),
          '0',
        ),
        style: theme.titleSmall.override(
          font: GoogleFonts.interTight(
            fontWeight: theme.titleSmall.fontWeight,
            fontStyle: theme.titleSmall.fontStyle,
          ),
          color: Colors.white,
          fontSize: 10,
          letterSpacing: 0.0,
          fontWeight: theme.titleSmall.fontWeight,
          fontStyle: theme.titleSmall.fontStyle,
        ),
      ),
      shape: badges.BadgeShape.circle,
      badgeColor: Color(0xFFF8070A),
      elevation: 4,
      padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      position: badges.BadgePosition.topEnd(),
      animationType: badges.BadgeAnimationType.scale,
      toAnimate: true,
      child: FlutterFlowIconButton(
        borderRadius: 12,
        buttonSize: 42,
        fillColor: Colors.white.withOpacity(0.15),
        icon: Icon(
          Icons.notifications_active_outlined,
          color: Colors.white,
          size: 22,
        ),
        onPressed: () async {
          logFirebaseEvent('HOME_notifications_active_ICN_ON_TAP');
          logFirebaseEvent('IconButton_navigate_to');

          context.pushNamed(
            NotificationWidget.routeName,
            extra: <String, dynamic>{
              '__transition_info__': TransitionInfo(
                hasTransition: true,
                transitionType: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 250),
              ),
            },
          );

          logFirebaseEvent('IconButton_update_app_state');
          FFAppState().notificationSeen = true;
          safeSetState(() {});
        },
      ),
    );
  }

  // ============================================================
  // BANNER SLIDE
  // ============================================================
  Widget _bannerSlide(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String buttonLabel,
    required String imageUrl,
    required List<Color> gradientColors,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              stops: [0, 1],
              begin: AlignmentDirectional(-1, 0),
              end: AlignmentDirectional(1, 0),
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(1, 1),
                child: Transform.translate(
                  offset: Offset(30, 20),
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.network(
                          (imageUrl),
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontStyle: theme.bodyMedium.fontStyle,
                            ),
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w700,
                            fontStyle: theme.bodyMedium.fontStyle,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          subtitle,
                          maxLines: 2,
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              fontStyle: theme.bodyMedium.fontStyle,
                            ),
                            color: Colors.white70,
                            fontSize: 12.5,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                            fontStyle: theme.bodyMedium.fontStyle,
                            lineHeight: 1.4,
                          ),
                        ),
                      ],
                    ),
                    FFButtonWidget(
                      onPressed: () {
                        print('Banner button pressed ...');
                      },
                      text: buttonLabel,
                      options: FFButtonOptions(
                        height: 32,
                        padding:
                            EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        iconPadding: EdgeInsets.zero,
                        color: Colors.white,
                        textStyle: theme.titleSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700,
                            fontStyle: theme.titleSmall.fontStyle,
                          ),
                          color: theme.primary,
                          fontSize: 13,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w700,
                          fontStyle: theme.titleSmall.fontStyle,
                        ),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY TILE
  // ============================================================
  Widget _categoryTile(
    BuildContext context, {
    required String assetImage,
    required String labelKey,
    required String fallback,
    required String categoryValue,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        logFirebaseEvent('HOME_PAGE_Column_cat_ON_TAP');
        logFirebaseEvent('Column_navigate_to');

        context.pushNamed(
          SpecificCategoriesWidget.routeName,
          extra: <String, dynamic>{
            '__transition_info__': TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 250),
            ),
          },
        );

        logFirebaseEvent('Column_update_app_state');
        FFAppState().categories = categoryValue;
        safeSetState(() {});
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: theme.secondary,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: EdgeInsets.all(10),
            child: Image.asset(
              assetImage,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.category_outlined,
                  color: theme.primary,
                  size: 28,
                );
              },
            ),
          ),
          SizedBox(height: 6),
          Text(
            FFLocalizations.of(context).getText(labelKey),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontStyle: theme.bodyMedium.fontStyle,
              ),
              color: theme.primaryText,
              fontSize: 11,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              fontStyle: theme.bodyMedium.fontStyle,
              lineHeight: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _moreTile(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        logFirebaseEvent('HOME_PAGE_Column_more_ON_TAP');
        logFirebaseEvent('Column_navigate_to');

        context.pushNamed(
          CategorysZWidget.routeName,
          extra: <String, dynamic>{
            '__transition_info__': TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 250),
            ),
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: theme.secondary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.grid_view_rounded,
              color: theme.primary,
              size: 26,
            ),
          ),
          SizedBox(height: 6),
          Text(
            FFLocalizations.of(context).getText(
              'hhkgn4p5' /* More */,
            ),
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontStyle: theme.bodyMedium.fontStyle,
              ),
              color: theme.primary,
              fontSize: 11,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              fontStyle: theme.bodyMedium.fontStyle,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT CARD
  // ============================================================
  Widget _productCard(
    BuildContext context, {
    required InventoryRecord record,
    Widget? badge,
    double? width = 165,
    double? height = 245,
  }) {
    final theme = FlutterFlowTheme.of(context);

    final card = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          logFirebaseEvent('HOME_PAGE_product_card_ON_TAP');
          logFirebaseEvent('product_card_navigate_to');

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
                duration: Duration(milliseconds: 250),
              ),
            },
          );
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional(1, -1),
                children: [
                  Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                          valueOrDefault<String>(
                            record.inventoryImages.firstOrNull,
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyxz9T3n9wAdGgBp1oXZxkQMdECuc3cuvcOw&s',
                          ),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported_outlined,
                            color: theme.secondaryText,
                            size: 32,
                          );
                        },
                      ),
                    ),
                  ),
                  if (badge != null)
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),
                      child: badge,
                    ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                valueOrDefault<String>(record.inventoryName, 'Product'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontStyle: theme.bodyMedium.fontStyle,
                  ),
                  color: theme.primaryText,
                  fontSize: 13,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: theme.bodyMedium.fontStyle,
                  lineHeight: 1.25,
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      valueOrDefault<String>(
                        formatNumber(
                          record.inventoryPrice,
                          formatType: FormatType.decimal,
                          decimalType: DecimalType.automatic,
                          currency: 'TZS ',
                        ),
                        '1,500',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.baiJamjuree(
                          fontWeight: FontWeight.w900,
                          fontStyle: theme.bodyMedium.fontStyle,
                        ),
                        color: theme.error,
                        fontSize: 15,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w900,
                        fontStyle: theme.bodyMedium.fontStyle,
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

    if (width == null && height == null) {
      // For the GridView in Full Catalog, we don't force width/height
      return Container(
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
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
                  duration: Duration(milliseconds: 250),
                ),
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                          valueOrDefault<String>(
                            record.inventoryImages.firstOrNull,
                            'https://upload.wikimedia.org/wikipedia/commons/0/04/Prezenty_EXP_096_%28ubt%29.JPG',
                          ),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported_outlined,
                            color: theme.secondaryText,
                            size: 32,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        valueOrDefault<String>(
                            record.inventoryName, 'Product'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle: theme.bodyMedium.fontStyle,
                          ),
                          color: theme.primaryText,
                          fontSize: 13,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle: theme.bodyMedium.fontStyle,
                          lineHeight: 1.25,
                        ),
                      ),
                      Spacer(),
                      Text(
                        valueOrDefault<String>(
                          formatNumber(
                            record.inventoryPrice,
                            formatType: FormatType.decimal,
                            decimalType: DecimalType.automatic,
                            currency: 'TZS ',
                          ),
                          '1,500',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.bodyMedium.override(
                          font: GoogleFonts.baiJamjuree(
                            fontWeight: FontWeight.w900,
                            fontStyle: theme.bodyMedium.fontStyle,
                          ),
                          color: theme.error,
                          fontSize: 15,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w900,
                          fontStyle: theme.bodyMedium.fontStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return card;
  }

  Widget _badgeFire(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
          ),
        ],
      ),
      child: Icon(
        Icons.local_fire_department_rounded,
        color: Color(0xFFE31B23),
        size: 18,
      ),
    );
  }

  Widget _badgeNew(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Color(0xFFDC0F0F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'NEW',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context, String message) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: theme.secondaryText,
            size: 40,
          ),
          SizedBox(height: 8),
          Text(
            message,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontStyle: theme.bodyMedium.fontStyle,
              ),
              color: theme.secondaryText,
              fontSize: 13,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
              fontStyle: theme.bodyMedium.fontStyle,
            ),
          ),
        ],
      ),
    );
  }
}