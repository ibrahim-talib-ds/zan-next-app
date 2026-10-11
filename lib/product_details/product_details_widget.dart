import '/components/buy_now_sheet_widget.dart';
import '/components/write_review_sheet.dart';
import '/components/report_sheet_widget.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/repositories/chat_repository.dart';
import '/repositories/product_repository.dart';
import '/repositories/review_repository.dart';
import '/models/chat.dart';
import '/components/product_bottom_info.dart';
import '/components/product_badge.dart';
import '/services/api_client.dart' as zannext_api;
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/internationalization.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';


import 'product_details_model.dart';
export 'product_details_model.dart';

class ProductDetailsWidget extends StatefulWidget {
  const ProductDetailsWidget({super.key, this.productId});

  final String? productId;

  static String routeName = 'Product_Details';
  static String routePath = '/productDetails';

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  late ProductDetailsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kAmber = Color(0xFFFFB300);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _soft   => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFF0F2F5);
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);


  // ═══════════════════════════════════════════════════════════
  // UNIQUE VIEW TRACKING
  // Increments view_count only the FIRST time this user
  // views this product. Uses a subcollection `viewers`.
  // ═══════════════════════════════════════════════════════════
  Future<void> _registerView() async {
    final pid = widget.productId;
    if (pid == null || pid.isEmpty) return;
    try {
      await ProductRepository.recordView(pid);
    } catch (_) {}
  }

  String _imgUrl(String? url) {
    final u = (url ?? '').trim();
    if (u.isEmpty) return '';
    return u.startsWith('http://') ? u.replaceFirst('http://', 'https://') : u;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductDetailsModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _registerView();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    if (widget.productId == null || widget.productId!.isEmpty) {
      return Scaffold(
        backgroundColor: _bg,
        body: Center(
          child: Text(FFLocalizations.of(context).getText('pd_product_not_found'),
              style: TextStyle(color: _muted, fontSize: 14)),
        ),
      );
    }

    return StreamBuilder<InventoryRecord>(
      stream: InventoryRecord.getByIdStream(widget.productId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: _bg,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(FFLocalizations.of(context).getText('pd_could_not_load'),
                    style: TextStyle(color: _muted)),
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: _bg,
            body: const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                  strokeWidth: 3,
                ),
              ),
            ),
          );
        }

        final p = snapshot.data!;

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: _bg,
          body: SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 64, bottom: 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImageCarousel(p),
                            const SizedBox(height: 16),
                            _buildCategoryRatingRow(p),
                            const SizedBox(height: 12),
                            _buildNamePrice(p),
                            const SizedBox(height: 20),
                            _buildRatingBreakdown(p),
                            const SizedBox(height: 20),
                            _buildSectionHeader(FFLocalizations.of(context).getText('pd_section_product_details')),
                            _buildDescription(p),
                            const SizedBox(height: 20),
                            _buildSectionHeader(FFLocalizations.of(context).getText('pd_section_quick_messages')),
                            _buildQuickMessages(p),
                            const SizedBox(height: 20),
                            _buildSectionHeader(FFLocalizations.of(context).getText('pd_section_seller')),
                            _buildSellerCard(p),
                            const SizedBox(height: 20),
                            _buildReviewsSection(p),
                            const SizedBox(height: 24),
                            _buildSectionHeader(FFLocalizations.of(context).getText('pd_section_recommended')),
                            const SizedBox(height: 12),
                            _buildRecommended(p),
                          ],
                        ),
                      ),
                      _buildTopBar(p),
                    ],
                  ),
                ),
                _buildBottomBar(p),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════
  // TOP BAR
  // ═══════════════════════════════════════════════════════════
  Widget _buildTopBar(InventoryRecord p) {
    final topPad = MediaQuery.of(context).padding.top;
    return Align(
      alignment: AlignmentDirectional(0, -1),
      child: Container(
        color: _bg.withOpacity(0.96),
        padding: EdgeInsetsDirectional.fromSTEB(8, topPad + 8, 8, 8),
        child: Row(
          children: [
            _roundBtn(
              icon: Icons.arrow_back_rounded,
              onTap: () => context.safePop(),
            ),
            const Spacer(),
            _roundBtn(
              icon: Icons.share_outlined,
              onTap: () => _shareProductWithImage(p),
            ),
            const SizedBox(width: 8),
            _buildReportBtn(p),
            const SizedBox(width: 8),
            _buildWishlistBtn(p),
          ],
        ),
      ),
    );
  }

  Widget _roundBtn({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        shape: BoxShape.circle,
        border: Border.all(color: _border),
      ),
      child: FlutterFlowIconButton(
        borderRadius: 22,
        buttonSize: 42,
        fillColor: Colors.transparent,
        icon: Icon(icon, color: _text, size: 20),
        onPressed: onTap,
      ),
    );
  }


  // ═══════════════════════════════════════════════════════════
  // REPORT BUTTON — with already-reported check
  // ═══════════════════════════════════════════════════════════
  Widget _buildReportBtn(InventoryRecord p) {
    // Owners can't report their own product
    if (p.sellersId == currentUserReference) {
      return const SizedBox.shrink();
    }

    // Hide entirely if user not signed in
    if (currentUserReference == null) {
      return const SizedBox.shrink();
    }

    // Live check replaced with static state — no Firestore.
    // TODO (later): swap for GET /products/{id}/has-reported.
    const alreadyReported = false;

    return Container(
      decoration: BoxDecoration(
        color: alreadyReported
            ? kAmber.withOpacity(0.12)
            : _card,
        shape: BoxShape.circle,
        border: Border.all(
          color: alreadyReported ? kAmber : _border,
          width: alreadyReported ? 1.5 : 1,
        ),
      ),
      child: FlutterFlowIconButton(
        borderRadius: 22,
        buttonSize: 42,
        fillColor: Colors.transparent,
        icon: Icon(
          alreadyReported
              ? Icons.flag_rounded
              : Icons.flag_outlined,
          color: alreadyReported ? kAmber : _text,
          size: 20,
        ),
        onPressed: alreadyReported
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(FFLocalizations.of(context).getText('pd_already_reported')),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            : () => _openReportSheet(p),
      ),
    );
  }

  Future<void> _openReportSheet(InventoryRecord p) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportSheetWidget(
        targetType: 'product',
        targetId: p.id,
        targetLabel: valueOrDefault<String>(p.inventoryName, FFLocalizations.of(context).getText('pd_product_fallback')),
      ),
    );
  }

  bool _liked = false;
  bool _likeLoaded = false;

  Future<void> _loadLikeState(String productId) async {
    final uid = currentUserUid;
    if (uid.isEmpty) {
      if (mounted) safeSetState(() => _likeLoaded = true);
      return;
    }
    try {
      final raw = await zannext_api.ApiClient.get(
        '/wishlist?user_id=$uid',
      ) as List;
      final liked = raw.any((item) =>
          (item as Map)['product_id']?.toString() == productId);
      if (mounted) {
        safeSetState(() {
          _liked = liked;
          _likeLoaded = true;
        });
      }
    } catch (_) {
      if (mounted) safeSetState(() => _likeLoaded = true);
    }
  }

  Future<void> _toggleLike(String productId) async {
    if (currentUserUid.isEmpty) return;
    try {
      if (_liked) {
        await zannext_api.ApiClient.delete('/wishlist/$productId');
      } else {
        await zannext_api.ApiClient.post('/wishlist/$productId');
      }
      if (mounted) safeSetState(() => _liked = !_liked);
    } catch (e) {
      debugPrint('Wishlist toggle failed: $e');
    }
  }

  Widget _buildWishlistBtn(InventoryRecord p) {
    // Trigger load once per product
    if (!_likeLoaded) {
      _loadLikeState(p.id);
    }
    return Container(
      decoration: BoxDecoration(
        color: _card,
        shape: BoxShape.circle,
        border: Border.all(color: _border),
      ),
      child: FlutterFlowIconButton(
        borderRadius: 22,
        buttonSize: 42,
        fillColor: Colors.transparent,
        icon: Icon(
          _liked ? Icons.favorite_rounded : Icons.favorite_border,
          color: _liked ? const Color(0xFFDC0F0F) : _text,
          size: 20,
        ),
        onPressed: () => _toggleLike(p.id),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // IMAGE CAROUSEL — tappable to open fullscreen
  // ═══════════════════════════════════════════════════════════
  Widget _buildImageCarousel(InventoryRecord p) {
    final images = p.inventoryImages.toList();
    if (images.isEmpty) images.add('');

    _model.pageViewController ??= PageController(initialPage: 0);

    return Container(
      width: double.infinity,
      height: 380,
      color: _card,
      child: Stack(
        children: [
          PageView.builder(
            controller: _model.pageViewController,
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            onPageChanged: (_) => safeSetState(() {}),
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () => _openFullScreen(images, i),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _soft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Center(
                      child: i == 0
                          ? Hero(
                              tag: 'product-image-${p.id}',
                              child: Image.network(
                                _imgUrl(images[i]),
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.image_not_supported_outlined,
                                  color: _muted,
                                  size: 40,
                                ),
                              ),
                            )
                          : Image.network(
                              _imgUrl(images[i]),
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.image_not_supported_outlined,
                                color: _muted,
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Counter badge
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${(_model.pageViewCurrentIndex + 1)} / ${images.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Zoom hint
          Positioned(
            bottom: 12,
            left: 16,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.zoom_in_rounded,
                      color: Colors.white, size: 12),
                  const SizedBox(width: 4),
                  Text(FFLocalizations.of(context).getText('pd_tap_to_zoom'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
            ),
          ),

          // Dots
          if (images.length > 1)
            Align(
              alignment: AlignmentDirectional(0, 1),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: smooth_page_indicator.SmoothPageIndicator(
                  controller: _model.pageViewController!,
                  count: images.length,
                  axisDirection: Axis.horizontal,
                  onDotClicked: (i) async {
                    await _model.pageViewController!.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  effect: smooth_page_indicator.ExpandingDotsEffect(
                    expansionFactor: 2.5,
                    spacing: 6,
                    radius: 4,
                    dotWidth: 7,
                    dotHeight: 7,
                    dotColor: _border,
                    activeDotColor: kGreen,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  
  // ═══════════════════════════════════════════════════════════
  // SHARE PRODUCT WITH IMAGE — downloads the first product image
  // and shares it as a real photo attachment.
  // ═══════════════════════════════════════════════════════════
}

  void _openFullScreen(List<String> images, int startIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => _FullscreenImageViewer(
          images: images,
          startIndex: startIndex,
          imgUrl: _imgUrl,
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // CATEGORY + RATING
  // ═══════════════════════════════════════════════════════════
  Widget _buildCategoryRatingRow(InventoryRecord p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: kGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              valueOrDefault<String>(p.categories, FFLocalizations.of(context).getText('pd_general')),
              style: const TextStyle(
                color: kGreen,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.pushNamed(ReviewsWidget.routeName),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: kAmber, size: 18),
                const SizedBox(width: 4),
                Text(
                  valueOrDefault<String>(
                      p.rating.toStringAsFixed(1), '0.0'),
                  style: TextStyle(
                    color: _text,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Text('(${p.reviews})',
                    style: TextStyle(color: _muted, fontSize: 12.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // NAME + PRICE
  // ═══════════════════════════════════════════════════════════
  Widget _buildNamePrice(InventoryRecord p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            valueOrDefault<String>(p.inventoryName, FFLocalizations.of(context).getText('pd_product_fallback')),
            style: TextStyle(
              color: _text,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                valueOrDefault<String>(
                  formatNumber(
                    p.inventoryPrice,
                    formatType: FormatType.decimal,
                    decimalType: DecimalType.automatic,
                    currency: 'TZS ',
                  ),
                  'TZS 0',
                ),
                style: const TextStyle(
                  color: kGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  FFLocalizations.of(context).getText('pd_in_stock'),
                  style: const TextStyle(
                    color: Color(0xFF16A34A),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, size: 14, color: _muted),
              const SizedBox(width: 4),
              Text(FFLocalizations.of(context).getText('pd_free_delivery'),
                  style: TextStyle(color: _muted, fontSize: 12.5)),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // RATING BREAKDOWN
  // ═══════════════════════════════════════════════════════════
  Widget _buildRatingBreakdown(InventoryRecord p) {
    final rating = valueOrDefault<double>(p.rating, 0);
    final reviewCount = p.reviews;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  rating.toStringAsFixed(1),
                  style: TextStyle(
                    color: _text,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                RatingBar.builder(
                  ignoreGestures: true,
                  initialRating: rating,
                  itemCount: 5,
                  itemSize: 15,
                  itemBuilder: (_, __) =>
                      const Icon(Icons.star_rounded, color: kAmber),
                  onRatingUpdate: (_) {},
                ),
                const SizedBox(height: 4),
                Text('$reviewCount ${FFLocalizations.of(context).getText('pd_reviews_suffix')}',
                    style: TextStyle(color: _muted, fontSize: 11)),
              ],
            ),
            const SizedBox(width: 18),
            Container(width: 1, color: _border),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                children: [5, 4, 3, 2, 1].map((star) {
                  double percent = 0;
                  if (star == 5) percent = 0.8;
                  else if (star == 4) percent = 0.4;
                  else if (star == 3) percent = 0.7;
                  else if (star == 2) percent = 0.2;
                  else percent = 0.1;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text('$star',
                            style: TextStyle(color: _muted, fontSize: 11)),
                        const SizedBox(width: 4),
                        const Icon(Icons.star_rounded,
                            color: kAmber, size: 11),
                        const SizedBox(width: 6),
                        Expanded(
                          child: LinearPercentIndicator(
                            percent: percent,
                            lineHeight: 7,
                            animation: false,
                            progressColor: kGreen,
                            backgroundColor: _border,
                            barRadius: const Radius.circular(4),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SECTION HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _buildSectionHeader(String text, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: kGreen,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(text,
                  style: TextStyle(
                    color: _text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  )),
            ],
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildDescription(InventoryRecord p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        valueOrDefault<String>(
            p.inventoryDescription, FFLocalizations.of(context).getText('pd_no_description')),
        style: TextStyle(color: _muted, fontSize: 14, height: 1.6),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // QUICK MESSAGES — actually sends to chat
  // ═══════════════════════════════════════════════════════════
  Widget _buildQuickMessages(InventoryRecord p) {
    final suggestions = [
      FFLocalizations.of(context).getText('pd_quick_available'),
      FFLocalizations.of(context).getText('pd_quick_last_price'),
      FFLocalizations.of(context).getText('pd_quick_deliver_today'),
      FFLocalizations.of(context).getText('pd_quick_negotiable'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: suggestions.map((s) {
          return GestureDetector(
            onTap: () => _sendQuickMessage(p, s),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.send_rounded, size: 12, color: kGreen),
                  const SizedBox(width: 6),
                  Text(s,
                      style: TextStyle(
                        color: _text,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _sendQuickMessage(InventoryRecord p, String message) async {
    if (p.sellersId == currentUserReference) return;
    try {
      final chat = await _ensureChat(p);
      await ChatRepository.sendMessage(chat.id, message);

      if (!mounted) return;
      context.pushNamed(
        ChatDWidget.routeName,
        queryParameters: {
          'chatId': serializeParam(chat.id, ParamType.String),
        }.withoutNulls,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${FFLocalizations.of(context).getText('pd_could_not_send')}$e')),
      );
    }
  }

  Future<Chat> _ensureChat(InventoryRecord p) async {
    // 🚫 Block self-chat — seller cannot chat with themselves
    if (p.sellersId == currentUserReference) {
      throw Exception(FFLocalizations.of(context).getText('pd_cannot_message_self'));
    }
    // Backend /chats does find-or-create on buyer+seller+product.
    return ChatRepository.create({
      'seller_id': p.sellersId,
      'product_id': p.id,
      'product_name': p.inventoryName,
      'price': p.inventoryPrice,
      'item_images': [
        valueOrDefault<String>(
          p.inventoryImages.elementAtOrNull(0),
          'https://static.thenounproject.com/png/4974686-200.png',
        )
      ],
    });
  }

  // ═══════════════════════════════════════════════════════════
  // SELLER CARD
  // ═══════════════════════════════════════════════════════════
  Widget _buildSellerCard(InventoryRecord p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          if (p.sellersId.isEmpty) return;
          context.pushNamed(
            SellerDashbordWidget.routeName,
            queryParameters: {
              'sellerRef': serializeParam(
                p.sellersId, ParamType.String),
            }.withoutNulls,
          );
        },
        child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.all(14),
        child: FutureBuilder<UsersRecord?>(
          future: _getSeller(p.sellersId),
          builder: (context, snap) {
            final user = snap.data;
            final photo = user?.photoUrl ?? '';
            final name = user?.displayName ??
                valueOrDefault<String>(p.sellerName, FFLocalizations.of(context).getText('pd_section_seller'));
            final city = user?.city ?? '';

            return Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _soft,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: photo.isEmpty
                      ? Icon(Icons.person_rounded, color: _muted, size: 26)
                      : Image.network(
                          _imgUrl(photo),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                              Icons.person_rounded,
                              color: _muted,
                              size: 26),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: _text,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 13, color: _muted),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              city.isNotEmpty
                                  ? city
                                  : valueOrDefault<String>(
                                      p.location, FFLocalizations.of(context).getText('pd_seller_zanzibar')),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: _muted, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _ensureChat(p).then((chat) {
                    if (!mounted) return;
                    context.pushNamed(
                      ChatDWidget.routeName,
                      queryParameters: {
                        'chatId': serializeParam(chat.id, ParamType.String),
                      }.withoutNulls,
                    );
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: kGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(FFLocalizations.of(context).getText('pd_chat'),
                        style: const TextStyle(
                          color: kGreen,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ),
              ],
            );
          },
        ),
        ),
      ),
    );
  }

  Future<UsersRecord?> _getSeller(String? sellerId) async {
    if (sellerId == null || sellerId.isEmpty) return null;
    try {
      return await UsersRecord.getByIdOnce(sellerId);
    } catch (_) {
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // REVIEWS
  // ═══════════════════════════════════════════════════════════
  Widget _buildReviewsSection(InventoryRecord p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          FFLocalizations.of(context).getText('pd_section_reviews'),
          trailing: GestureDetector(
            onTap: () => _openWriteReview(p),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kGreen.withOpacity(0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit_rounded, color: kGreen, size: 14),
                  const SizedBox(width: 6),
                  Text(FFLocalizations.of(context).getText('pd_write_review'),
                      style: const TextStyle(
                        color: kGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      )),
                ],
              ),
            ),
          ),
        ),
        FutureBuilder<List<dynamic>>(
          future: _fetchReviews(p.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                    '${FFLocalizations.of(context).getText('pd_could_not_load')}\n${snapshot.error}',
                    style: TextStyle(color: _muted, fontSize: 12)),
              );
            }
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                    ),
                  ),
                ),
              );
            }
            final items = snapshot.data!;
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _border),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.reviews_outlined, color: _muted, size: 32),
                        const SizedBox(height: 8),
                        Text(FFLocalizations.of(context).getText('pd_no_reviews'),
                            style: TextStyle(color: _muted, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(
                            FFLocalizations.of(context)
                                .getText('pd_be_first_review'),
                            style: TextStyle(
                                color: kGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: items
                    .map((r) => _reviewCard(r as Map<String, dynamic>, p))
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<List<dynamic>> _fetchReviews(String productId) async {
    try {
      final raw = await zannext_api.ApiClient.get('/products/$productId/reviews');
      return (raw as List).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _openWriteReview(InventoryRecord p) async {
    if (currentUserUid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(FFLocalizations.of(context).getText('pd_sign_in_to_review')),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Map<String, dynamic>? myReview;
    try {
      final raw =
          await zannext_api.ApiClient.get('/products/${p.id}/reviews') as List;
      for (final item in raw) {
        final m = Map<String, dynamic>.from(item as Map);
        final rid = (m['reviewer_id'] ?? m['reviewerId'] ?? '').toString();
        if (rid == currentUserUid) {
          myReview = m;
          break;
        }
      }
    } catch (_) {}

    if (!mounted) return;
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WriteReviewSheet(
        productId: p.id,
        productName: p.inventoryName,
        existingReviewId: myReview?['id']?.toString(),
        existingRating: myReview?['rating'] as num?,
        existingMessage:
            (myReview?['message'] ?? myReview?['reviews_message'] ?? '').toString(),
      ),
    );

    if (result == true) {
      safeSetState(() {});
    }
  }

  Future<bool> _confirmDeleteReview(Map<String, dynamic> r) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: _card,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Text(FFLocalizations.of(context).getText('pd_delete_review'),
                style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
            content: Text(
              FFLocalizations.of(context).getText('pd_delete_review_body'),
              style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(FFLocalizations.of(context).getText('pd_cancel'),
                    style: TextStyle(
                        color: _muted, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(FFLocalizations.of(context).getText('pd_delete'),
                    style: const TextStyle(
                        color: Color(0xFFDC0F0F),
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteReview(Map<String, dynamic> r, InventoryRecord p) async {
    try {
      await ReviewRepository.delete((r['id'] ?? '').toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(FFLocalizations.of(context).getText('pd_review_deleted')),
          backgroundColor: kGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      safeSetState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${FFLocalizations.of(context).getText('pd_delete_failed')}$e'),
          backgroundColor: const Color(0xFFDC0F0F),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _reviewCard(Map<String, dynamic> r, InventoryRecord p) {
    final rid = (r['reviewer_id'] ?? r['reviewerId'] ?? '').toString();
    final isMine = rid.isNotEmpty && rid == currentUserUid;
    final isAdmin =
        valueOrDefault<bool>(currentUserDocument?.isAdmin, false) == true;
    final canDelete = isMine || isAdmin;
    final name = (r['reviewers_name'] ?? r['reviewersName'] ?? 'User').toString();
    final img = (r['reviewers_image'] ?? r['reviewersImage'] ?? '').toString();
    final msg = (r['message'] ?? r['reviews_message'] ?? '').toString();
    final rating = (r['rating'] as num?)?.toDouble() ?? 0;
    final when = DateTime.tryParse((r['created_at'] ?? r['date'] ?? '').toString());

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMine ? kGreen.withOpacity(0.35) : _border,
          width: isMine ? 1.3 : 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _soft,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  _imgUrl(img),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                      Icons.person_rounded,
                      color: _muted,
                      size: 20),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            isMine
                                ? '$name${FFLocalizations.of(context).getText('pd_you_suffix')}'
                                : name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _text,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (isAdmin && !isMine) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: kAmber.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                                FFLocalizations.of(context)
                                    .getText('pd_admin_view'),
                                style: TextStyle(
                                  color: kAmber,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.4,
                                )),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    RatingBarIndicator(
                      rating: rating,
                      itemSize: 13,
                      itemCount: 5,
                      itemBuilder: (_, __) => const Icon(
                        Icons.star_rounded,
                        color: kAmber,
                      ),
                    ),
                  ],
                ),
              ),
              if (when != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    _timeAgo(when),
                    style: TextStyle(color: _muted, fontSize: 11),
                  ),
                ),
              if (canDelete)
                GestureDetector(
                  onTap: () async {
                    final okr = await _confirmDeleteReview(r);
                    if (okr) await _deleteReview(r, p);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC0F0F).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFDC0F0F),
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          if (msg.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              msg,
              style: TextStyle(
                color: _text.withOpacity(0.85),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _timeAgo(DateTime when) {
    final d = DateTime.now().difference(when);
    if (d.inSeconds < 60) return FFLocalizations.of(context).getText('pd_time_just_now');
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    if (d.inDays < 7) return '${d.inDays}d';
    return '${when.day}/${when.month}/${when.year}';
  }

  // ═══════════════════════════════════════════════════════════
  // RECOMMENDED
  // ═══════════════════════════════════════════════════════════
  Widget _buildRecommended(InventoryRecord p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<List<InventoryRecord>>(
        stream: queryInventoryRecord(
          filterCategory: p.categories,
          limit: 10,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          final items = snapshot.data!
              .where((i) => i.id != p.id)
              .take(6)
              .toList();
          if (items.isEmpty) return const SizedBox.shrink();

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemCount: items.length,
            itemBuilder: (context, i) => _miniCard(items[i]),
          );
        },
      ),
    );
  }

  Widget _miniCard(InventoryRecord item) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.pushNamed(
        ProductDetailsWidget.routeName,
        queryParameters: {
          'inventoryRef': serializeParam( item.id, ParamType.String),
        }.withoutNulls,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _soft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Image.network(
                      _imgUrl(valueOrDefault<String>(
                          item.inventoryImages.firstOrNull, '')),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.image_not_supported_outlined,
                        color: _muted,
                        size: 24,
                      ),
                    ),
                  ),
                  if (productBadge(context, item) != null)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: productBadge(context, item)!,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              valueOrDefault<String>(item.inventoryName, FFLocalizations.of(context).getText('pd_product_fallback')),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _text,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              valueOrDefault<String>(
                formatNumber(
                  item.inventoryPrice,
                  formatType: FormatType.decimal,
                  decimalType: DecimalType.automatic,
                  currency: 'TZS ',
                ),
                'TZS 0',
              ),
              style: const TextStyle(
                color: Color(0xFFDC0F0F),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            _pbBottomRow(item),
          ],
        ),
      ),
    );
  }

  Widget _pbBottomRow(InventoryRecord r) {
    return ProductBottomInfo(
      sellerName: r.sellerName,
      shippingDays: r.shippingDays,
      createdAt: r.createdAt,
    );
  }

  // ═══════════════════════════════════════════════════════════
  // STICKY BOTTOM BAR
  // ═══════════════════════════════════════════════════════════
  Widget _buildBottomBar(InventoryRecord p) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(
          12, 12, 12, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: _card,
        border: Border(top: BorderSide(color: _border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _iconBarBtn(
            icon: Icons.call_rounded,
            onTap: () async {
              final phone = p.sellerWhatsap;
              if (phone.isNotEmpty) {
                try {
                  await launchURL('tel:$phone');
                } catch (_) {}
              }
            },
          ),
          const SizedBox(width: 8),
          _iconBarBtn(
            icon: Icons.chat_rounded,
            onTap: () async {
              if (p.sellersId == currentUserReference) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(FFLocalizations.of(context).getText('pd_cant_chat_self')),
                  ),
                );
                return;
              }
              try {
                final chat = await _ensureChat(p);
                if (!mounted) return;
                context.pushNamed(
                  ChatDWidget.routeName,
                  queryParameters: {
                    'chatId': serializeParam(chat.id, ParamType.String),
                  }.withoutNulls,
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$e')),
                );
              }
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: _buyNowBtn(context, p),
          ),
        ],
      ),
    );
  }


  // ═══════════════════════════════════════════════════════════
  // BOTTOM BAR — compact icon button
  // ═══════════════════════════════════════════════════════════
  Widget _iconBarBtn({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: kGreen.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: kGreen, size: 22),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // BOTTOM BAR — Buy Now (primary, wide)
  // ═══════════════════════════════════════════════════════════
  Widget _buyNowBtn(BuildContext context, InventoryRecord p) {
    final isOwner = p.sellersId == currentUserReference;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: isOwner
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(FFLocalizations.of(context).getText('pd_cant_buy_own')),
                ),
              );
            }
          : () => _openBuyNow(context, p),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kGreen, kGreenDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: kGreen.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_checkout_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              FFLocalizations.of(context).getText('pd_buy_now'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openBuyNow(BuildContext ctx, InventoryRecord p) async {
    await showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BuyNowSheetWidget(product: p),
    );
  }


  // ═══════════════════════════════════════════════════════════
  // SHARE PRODUCT WITH IMAGE — downloads the first product image
  // and shares it as a real photo attachment.
  // ═══════════════════════════════════════════════════════════
  Future<void> _shareProductWithImage(InventoryRecord p) async {
    try {
      final name = valueOrDefault<String>(
        p.inventoryName,
        FFLocalizations.of(context).getText('pd_this_product'),
      );
      final priceStr = valueOrDefault<String>(
        formatNumber(
          p.inventoryPrice,
          formatType: FormatType.decimal,
          decimalType: DecimalType.automatic,
          currency: 'TZS ',
        ),
        'TZS 0',
      );
      final caption = '$name — $priceStr\n'
          '${FFLocalizations.of(context).getText('pd_share_check')}'
          'ZanNext';

      final imageUrl = _imgUrl(p.inventoryImages.firstOrNull);

      if (imageUrl.isEmpty) {
        await Share.share(caption, subject: name);
        return;
      }

      final resp = await http.get(Uri.parse(imageUrl));
      if (resp.statusCode != 200) {
        await Share.share(caption, subject: name);
        return;
      }

      final tmp = await getTemporaryDirectory();
      final ext = imageUrl.contains('.')
          ? imageUrl.split('.').last.split('?').first
          : 'jpg';
      final file = File('${tmp.path}/zannext_share_${p.id}.$ext');
      await file.writeAsBytes(resp.bodyBytes);

      final box = context.findRenderObject() as RenderBox?;
      await Share.shareXFiles(
        [XFile(file.path)],
        text: caption,
        subject: name,
        sharePositionOrigin: box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : null,
      );
    } catch (e) {
      debugPrint('Share image failed: $e');
      try {
        final name = valueOrDefault<String>(
          p.inventoryName,
          FFLocalizations.of(context).getText('pd_this_product'),
        );
        await Share.share(
          '$name\n${FFLocalizations.of(context).getText('pd_share_check')}ZanNext',
          subject: name,
        );
      } catch (_) {}
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// FULLSCREEN IMAGE VIEWER
// ═══════════════════════════════════════════════════════════════



class _FullscreenImageViewer extends StatefulWidget {
  const _FullscreenImageViewer({
    required this.images,
    required this.startIndex,
    required this.imgUrl,
  });

  final List<String> images;
  final int startIndex;
  final String Function(String?) imgUrl;

  @override
  State<_FullscreenImageViewer> createState() =>
      _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<_FullscreenImageViewer> {
  late PageController _controller;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.startIndex;
    _controller = PageController(initialPage: widget.startIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              onPageChanged: (i) => setState(() => _current = i),
              itemCount: widget.images.length,
              itemBuilder: (context, i) {
                return InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  child: Center(
                    child: Image.network(
                      widget.imgUrl(widget.images[i]),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white54,
                        size: 60,
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_current + 1} / ${widget.images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (widget.images.length > 1)
              Align(
                alignment: AlignmentDirectional(0, 1),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: smooth_page_indicator.SmoothPageIndicator(
                    controller: _controller,
                    count: widget.images.length,
                    axisDirection: Axis.horizontal,
                    effect:
                        smooth_page_indicator.ExpandingDotsEffect(
                      expansionFactor: 2,
                      spacing: 6,
                      radius: 4,
                      dotWidth: 7,
                      dotHeight: 7,
                      dotColor: Colors.white24,
                      activeDotColor: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
