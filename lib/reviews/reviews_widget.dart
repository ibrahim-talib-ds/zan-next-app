import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/internationalization.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'reviews_model.dart';
export 'reviews_model.dart';

class ReviewsWidget extends StatefulWidget {
  const ReviewsWidget({super.key});

  static String routeName = 'Reviews';
  static String routePath = '/reviews';

  @override
  State<ReviewsWidget> createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {
  late ReviewsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kRed = Color(0xFFDC0F0F);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg =>
      _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _soft =>
      _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFF0F2F5);
  Color get _text => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted =>
      _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border =>
      _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReviewsModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 55,
          icon: Icon(Icons.arrow_back_rounded, color: _text, size: 24),
          onPressed: () => context.pop(),
        ),
        title: Text(
          FFLocalizations.of(context).getText('rev_title'),
          style: TextStyle(
            color: _text,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: kGreen,
        onRefresh: () async {
          safeSetState(() {});
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: StreamBuilder<List<ReviewsRecord>>(
          stream: queryReviewsRecord(
            queryBuilder: (r) => r.orderBy('date', descending: true),
            limit: 100,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(kGreen),
                    strokeWidth: 3,
                  ),
                ),
              );
            }

            final allReviews = snapshot.data!;
            final filtered = _filterReviews(allReviews);

            return ListView(
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                _buildSummaryCard(allReviews),
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildHeaderRow(allReviews.length),
                const SizedBox(height: 8),
                if (filtered.isEmpty)
                  _buildEmptyState()
                else
                  ...filtered.map((r) {
                    final isAdmin = valueOrDefault<bool>(
                            currentUserDocument?.isAdmin, false) ==
                        true;
                    if (!isAdmin) return _reviewRow(r);

                    return Dismissible(
                      key: ValueKey(r.reference.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC0F0F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.delete_rounded,
                                color: Colors.white, size: 22),
                            const SizedBox(width: 6),
                            Text(FFLocalizations.of(context).getText('rev_delete'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                )),
                          ],
                        ),
                      ),
                      confirmDismiss: (_) => _confirmDelete(),
                      onDismissed: (_) => _deleteReview(r),
                      child: _reviewRow(r),
                    );
                  }),
              ],
            );
          },
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // FILTER
  // ════════════════════════════════════════════════════════
  List<ReviewsRecord> _filterReviews(List<ReviewsRecord> src) {
    final q = (_model.textController?.text ?? '').trim().toLowerCase();
    var out = src;
    if (q.isNotEmpty) {
      out = out.where((r) {
        final name = r.reviewersName.toLowerCase();
        final msg = r.reviewsMessage.toLowerCase();
        return name.contains(q) || msg.contains(q);
      }).toList();
    }
    return out;
  }

  // ════════════════════════════════════════════════════════
  // SUMMARY CARD (real numbers, no fakes)
  // ════════════════════════════════════════════════════════
  Widget _buildSummaryCard(List<ReviewsRecord> reviews) {
    final total = reviews.length;
    double avg = 0;
    if (total > 0) {
      double sum = 0;
      for (final r in reviews) {
        sum += r.rating.toDouble();
      }
      avg = sum / total;
    }

    // Count per star
    final counts = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in reviews) {
      final s = r.rating.clamp(1, 5);
      counts[s] = (counts[s] ?? 0) + 1;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Left: big number
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                avg.toStringAsFixed(1),
                style: TextStyle(
                  color: _text,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              RatingBar.builder(
                ignoreGestures: true,
                initialRating: avg,
                itemCount: 5,
                itemSize: 15,
                itemBuilder: (_, __) =>
                    const Icon(Icons.star_rounded, color: kAmber),
                onRatingUpdate: (_) {},
              ),
              const SizedBox(height: 4),
              Text(
                '$total review${total == 1 ? '' : 's'}',
                style: TextStyle(color: _muted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Container(width: 1, color: _border),
          const SizedBox(width: 16),
          // Right: bars
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final c = counts[star] ?? 0;
                final pct = total == 0 ? 0.0 : c / total;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 12,
                        child: Text(
                          '$star',
                          style:
                              TextStyle(color: _muted, fontSize: 11),
                        ),
                      ),
                      const Icon(Icons.star_rounded,
                          color: kAmber, size: 11),
                      const SizedBox(width: 6),
                      Expanded(
                        child: LinearPercentIndicator(
                          percent: pct.clamp(0.0, 1.0),
                          lineHeight: 7,
                          animation: false,
                          progressColor: kGreen,
                          backgroundColor: _border,
                          barRadius: const Radius.circular(4),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 24,
                        child: Text(
                          '$c',
                          textAlign: TextAlign.right,
                          style:
                              TextStyle(color: _muted, fontSize: 11),
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
    );
  }

  // ════════════════════════════════════════════════════════
  // SEARCH BAR
  // ════════════════════════════════════════════════════════
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: _soft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        child: TextField(
          controller: _model.textController,
          focusNode: _model.textFieldFocusNode,
          onChanged: (_) => safeSetState(() {}),
          style: TextStyle(color: _text, fontSize: 14),
          cursorColor: kGreen,
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            hintText: FFLocalizations.of(context).getText('rev_search_hint'),
            hintStyle: TextStyle(color: _muted, fontSize: 13.5),
            prefixIcon:
                Icon(Icons.search_rounded, color: _muted, size: 20),
            contentPadding:
                const EdgeInsetsDirectional.fromSTEB(0, 14, 12, 14),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // HEADER ROW (count + sort dropdown)
  // ════════════════════════════════════════════════════════
  Widget _buildHeaderRow(int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            FFLocalizations.of(context).getText('rev_all_reviews'),
            style: TextStyle(
              color: _text,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            '$total',
            style: TextStyle(
              color: _muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // EMPTY STATE
  // ════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.reviews_outlined, color: _muted, size: 40),
            const SizedBox(height: 10),
            Text(FFLocalizations.of(context).getText('rev_no_reviews'),
                style: TextStyle(color: _muted, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // REVIEW ROW
  // ════════════════════════════════════════════════════════
  Future<bool> _confirmDelete() async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: _card,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Text(FFLocalizations.of(context).getText('rev_delete_title'),
                style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
            content: Text(
              FFLocalizations.of(context).getText('rev_delete_body'),
              style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(FFLocalizations.of(context).getText('rev_cancel'),
                    style: TextStyle(
                        color: _muted, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(FFLocalizations.of(context).getText('rev_delete'),
                    style: const TextStyle(
                        color: Color(0xFFDC0F0F),
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteReview(ReviewsRecord r) async {
    try {
      await r.reference.delete();

      // Recalc product rating if product_ref exists
      final prodRef = r.productRef;
      if (prodRef != null) {
        final snap = await FirebaseFirestore.instance
            .collection('reviews')
            .where('product_ref', isEqualTo: prodRef)
            .get();
        if (snap.docs.isEmpty) {
          await prodRef.update({'rating': 0.0, 'reviews': 0});
        } else {
          double total = 0;
          for (final d in snap.docs) {
            final rating = d.data()['rating'];
            if (rating is num) total += rating.toDouble();
          }
          await prodRef.update({
            'rating': total / snap.docs.length,
            'reviews': snap.docs.length,
          });
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(FFLocalizations.of(context).getText('rev_deleted')),
          backgroundColor: Color(0xFF1B7A4E),
          behavior: SnackBarBehavior.floating,
        ),
      );
      safeSetState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete: $e'),
          backgroundColor: const Color(0xFFDC0F0F),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _reviewRow(ReviewsRecord r) {
    final isMine = r.reviewerRef == currentUserReference;
    final hasReply = (r.sellerReply ?? '').isNotEmpty;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMine ? kGreen.withOpacity(0.35) : _border,
          width: isMine ? 1.3 : 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration:
                    BoxDecoration(color: _soft, shape: BoxShape.circle),
                clipBehavior: Clip.antiAlias,
                child: r.reviewersImage.isEmpty
                    ? Icon(Icons.person_rounded, color: _muted, size: 22)
                    : Image.network(
                        r.reviewersImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                            Icons.person_rounded,
                            color: _muted,
                            size: 22),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMine
                          ? '${r.reviewersName} (You)'
                          : r.reviewersName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _text,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: r.rating.toDouble(),
                          itemSize: 14,
                          itemCount: 5,
                          itemBuilder: (_, __) => const Icon(
                            Icons.star_rounded,
                            color: kAmber,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (r.date != null)
                          Text(
                            _timeAgo(r.date!),
                            style: TextStyle(
                                color: _muted, fontSize: 11),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (r.reviewsMessage.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              r.reviewsMessage,
              style: TextStyle(
                color: _text.withOpacity(0.85),
                fontSize: 13.5,
                height: 1.45,
              ),
            ),
          ],
          if (hasReply) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border(
                  left: BorderSide(color: kGreen, width: 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.storefront_rounded,
                          color: kGreen, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        FFLocalizations.of(context).getText('rev_seller_replied'),
                        style: TextStyle(
                          color: kGreen,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (r.sellerReplyDate != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          _timeAgo(r.sellerReplyDate!),
                          style: TextStyle(
                              color: _muted, fontSize: 10.5),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    r.sellerReply ?? '',
                    style: TextStyle(
                      color: _text.withOpacity(0.85),
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // TIME AGO
  // ════════════════════════════════════════════════════════
  String _timeAgo(DateTime when) {
    final d = DateTime.now().difference(when);
    if (d.inSeconds < 60) return FFLocalizations.of(context).getText('rev_time_just_now');
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    if (d.inDays < 7) return '${d.inDays}d ago';
    return '${when.day}/${when.month}/${when.year}';
  }
}
