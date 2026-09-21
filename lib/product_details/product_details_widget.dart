import '/components/report_sheet_widget.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:math';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share_plus/share_plus.dart';

import 'product_details_model.dart';
export 'product_details_model.dart';

class ProductDetailsWidget extends StatefulWidget {
  const ProductDetailsWidget({super.key, required this.inventoryRef});

  final DocumentReference? inventoryRef;

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
    if (widget.inventoryRef == null) return;
    if (currentUserReference == null) return;

    try {
      final viewerRef = widget.inventoryRef!
          .collection('viewers')
          .doc(currentUserReference!.id);

      final viewerSnap = await viewerRef.get();
      if (viewerSnap.exists) {
        // Already viewed by this user — do nothing
        return;
      }

      // First time — record the viewer and increment the count
      await viewerRef.set({
        'user_ref': currentUserReference,
        'viewed_at': FieldValue.serverTimestamp(),
      });

      await widget.inventoryRef!.update({
        'view_count': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint('View registration failed: $e');
    }
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
    if (widget.inventoryRef == null) {
      return Scaffold(
        backgroundColor: _bg,
        body: Center(
          child: Text('Product not found',
              style: TextStyle(color: _muted, fontSize: 14)),
        ),
      );
    }

    return StreamBuilder<InventoryRecord>(
      stream: InventoryRecord.getDocument(widget.inventoryRef!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: _bg,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Could not load product',
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
                            _buildSectionHeader('Product Details'),
                            _buildDescription(p),
                            const SizedBox(height: 20),
                            _buildSectionHeader('Quick Messages'),
                            _buildQuickMessages(p),
                            const SizedBox(height: 20),
                            _buildSectionHeader('Seller'),
                            _buildSellerCard(p),
                            const SizedBox(height: 20),
                            _buildReviewsSection(p),
                            const SizedBox(height: 24),
                            _buildSectionHeader('You may also like'),
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
              onTap: () async {
                try {
                  await Share.share(
                    'Check out ${valueOrDefault<String>(p.inventoryName, 'this product')} on ZanNext',
                    sharePositionOrigin: getWidgetBoundingBox(context),
                  );
                } catch (_) {}
              },
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
    if (p.sellersRef == currentUserReference) {
      return const SizedBox.shrink();
    }

    // Hide entirely if user not signed in
    if (currentUserReference == null) {
      return const SizedBox.shrink();
    }

    // Live check: has the current user already reported this product?
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reports')
          .where('reporter_ref', isEqualTo: currentUserReference)
          .where('target_ref', isEqualTo: p.reference)
          .limit(1)
          .snapshots(),
      builder: (context, snap) {
        final alreadyReported =
            (snap.data?.docs.isNotEmpty ?? false);

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
                      const SnackBar(
                        content: Text(
                            'You already reported this. Our team is reviewing it.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                : () => _openReportSheet(p),
          ),
        );
      },
    );
  }

  Future<void> _openReportSheet(InventoryRecord p) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportSheetWidget(
        targetType: 'product',
        targetRef: p.reference,
        targetLabel: valueOrDefault<String>(p.inventoryName, 'Product'),
      ),
    );
  }

  Widget _buildWishlistBtn(InventoryRecord p) {
    return StreamBuilder<DocumentSnapshot>(
      stream: p.reference.snapshots(),
      builder: (context, snapshot) {
        bool liked = false;
        if (snapshot.hasData) {
          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final list = (data['product_liked_by'] as List?) ?? [];
          liked = list.contains(currentUserReference);
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
              liked ? Icons.favorite_rounded : Icons.favorite_border,
              color: liked ? const Color(0xFFDC0F0F) : _text,
              size: 20,
            ),
            onPressed: () async {
              if (currentUserReference == null) return;
              try {
                if (liked) {
                  await p.reference.update({
                    'product_liked_by':
                        FieldValue.arrayRemove([currentUserReference]),
                  });
                } else {
                  await p.reference.update({
                    'product_liked_by':
                        FieldValue.arrayUnion([currentUserReference]),
                  });
                }
              } catch (e) {
                debugPrint('Wishlist toggle failed: $e');
              }
            },
          ),
        );
      },
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
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _soft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Image.network(
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
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.zoom_in_rounded,
                      color: Colors.white, size: 12),
                  SizedBox(width: 4),
                  Text('Tap to zoom',
                      style: TextStyle(
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
              valueOrDefault<String>(p.categories, 'General'),
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
            valueOrDefault<String>(p.inventoryName, 'Product'),
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
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  'In Stock',
                  style: TextStyle(
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
              Text('Free delivery in Zanzibar',
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
                Text('$reviewCount reviews',
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
            p.inventoryDescription, 'No description available.'),
        style: TextStyle(color: _muted, fontSize: 14, height: 1.6),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // QUICK MESSAGES — actually sends to chat
  // ═══════════════════════════════════════════════════════════
  Widget _buildQuickMessages(InventoryRecord p) {
    final suggestions = [
      'Is it available?',
      'Last price?',
      'Can you deliver today?',
      'Is it negotiable?',
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
    try {
      final chatRef = await _ensureChat(p);
      // Send the message
      await ChatMessagesRecord.createDoc(chatRef).set(
        createChatMessagesRecordData(
          user: currentUserReference,
          text: message,
          timestamp: getCurrentTimestamp,
          nameSender: currentUserDisplayName,
        ),
      );
      await chatRef.update({
        'last_message': message,
        'last_message_time': getCurrentTimestamp,
        'last_message_seen_by': FieldValue.arrayUnion([currentUserReference]),
      });

      if (!mounted) return;
      context.pushNamed(
        ChatDWidget.routeName,
        queryParameters: {
          'receiveChats':
              serializeParam(chatRef, ParamType.DocumentReference),
        }.withoutNulls,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not send: $e')),
      );
    }
  }

  Future<DocumentReference> _ensureChat(InventoryRecord p) async {
    // Look for existing chat for this product + this buyer
    final existing = await FirebaseFirestore.instance
        .collection('Chats')
        .where('product_ref', isEqualTo: p.reference)
        .where('buyer_ref', isEqualTo: currentUserReference)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) return existing.docs.first.reference;

    // Create a new one
    final newDoc = ChatsRecord.collection.doc();
    await newDoc.set({
      ...createChatsRecordData(
        lastMessage: '',
        lastMessageTime: getCurrentTimestamp,
        productRef: p.reference,
        buyerRef: currentUserReference,
        sellerRef: p.sellersRef,
        productName: p.inventoryName,
        price: p.inventoryPrice,
      ),
      ...mapToFirestore({
        'users': functions.generatelistofusers(
          currentUserReference!,
          p.sellersRef!,
        ),
        'User_name': functions.generatelistofnames(
          currentUserDisplayName,
          valueOrDefault<String>(p.sellerName, 'Seller'),
        ),
        'items_images': [
          valueOrDefault<String>(
            p.inventoryImages.elementAtOrNull(0),
            'https://static.thenounproject.com/png/4974686-200.png',
          )
        ],
      }),
    });
    return newDoc;
  }

  // ═══════════════════════════════════════════════════════════
  // SELLER CARD
  // ═══════════════════════════════════════════════════════════
  Widget _buildSellerCard(InventoryRecord p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.all(14),
        child: FutureBuilder<UsersRecord?>(
          future: _getSeller(p.sellersRef),
          builder: (context, snap) {
            final user = snap.data;
            final photo = user?.photoUrl ?? '';
            final name = user?.displayName ??
                valueOrDefault<String>(p.sellerName, 'Seller');
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
                                      p.location, 'Zanzibar'),
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
                  onTap: () => _ensureChat(p).then((ref) {
                    if (!mounted) return;
                    context.pushNamed(
                      ChatDWidget.routeName,
                      queryParameters: {
                        'receiveChats': serializeParam(
                            ref, ParamType.DocumentReference),
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
                    child: const Text('Chat',
                        style: TextStyle(
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
    );
  }

  Future<UsersRecord?> _getSeller(DocumentReference? ref) async {
    if (ref == null) return null;
    try {
      final snap = await ref.get();
      if (snap.exists) return UsersRecord.fromSnapshot(snap);
    } catch (_) {}
    return null;
  }

  // ═══════════════════════════════════════════════════════════
  // REVIEWS
  // ═══════════════════════════════════════════════════════════
  Widget _buildReviewsSection(InventoryRecord p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Reviews',
          trailing: GestureDetector(
            onTap: () => context.pushNamed(ReviewsWidget.routeName),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('See all',
                    style: TextStyle(
                      color: kGreen,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    )),
                Icon(Icons.chevron_right_rounded,
                    color: kGreen, size: 18),
              ],
            ),
          ),
        ),
        if (p.sellersRef != null)
          StreamBuilder<List<ReviewsRecord>>(
            stream: queryReviewsRecord(
              queryBuilder: (r) =>
                  r.where('seller', isEqualTo: p.sellersRef),
              limit: 3,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kGreen),
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
                          Icon(Icons.reviews_outlined,
                              color: _muted, size: 32),
                          const SizedBox(height: 8),
                          Text('No reviews yet',
                              style: TextStyle(
                                  color: _muted, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: items.map(_reviewCard).toList(),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _reviewCard(ReviewsRecord r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
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
                  _imgUrl(r.reviewersImage),
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
                    Text(r.reviewersName,
                        style: TextStyle(
                          color: _text,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 3),
                    RatingBarIndicator(
                      rating: r.rating?.toDouble() ?? 0,
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
              if (r.date != null)
                Text(
                  _timeAgo(r.date!),
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
            ],
          ),
          if (r.reviewsMessage.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              r.reviewsMessage,
              style: TextStyle(
                color: _text.withOpacity(0.8),
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
    if (d.inSeconds < 60) return 'Just now';
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
          queryBuilder: (r) =>
              r.where('categories', isEqualTo: p.categories),
          limit: 10,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          final items = snapshot.data!
              .where((i) => i.reference != p.reference)
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
          'inventoryRef': serializeParam(
              item.reference, ParamType.DocumentReference),
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
              child: Container(
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
            ),
            const SizedBox(height: 6),
            Text(
              valueOrDefault<String>(item.inventoryName, 'Product'),
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
                color: kGreen,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
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
          Expanded(
            flex: 4,
            child: _barBtn(
              icon: Icons.call_rounded,
              label: 'Call',
              onTap: () async {
                final phone = p.sellerWhatsap;
                if (phone.isNotEmpty) {
                  try {
                    await launchURL('tel:$phone');
                  } catch (_) {}
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: _barBtn(
              icon: Icons.chat_rounded,
              label: 'Message Seller',
              primary: true,
              onTap: () async {
                final ref = await _ensureChat(p);
                if (!mounted) return;
                context.pushNamed(
                  ChatDWidget.routeName,
                  queryParameters: {
                    'receiveChats':
                        serializeParam(ref, ParamType.DocumentReference),
                  }.withoutNulls,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _barBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool primary = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: primary ? kGreen : kGreen.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: primary ? Colors.white : kGreen, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: primary ? Colors.white : kGreen,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
