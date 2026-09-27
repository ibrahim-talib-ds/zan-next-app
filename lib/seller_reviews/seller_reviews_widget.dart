import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'seller_reviews_model.dart';
export 'seller_reviews_model.dart';

class SellerReviewsWidget extends StatefulWidget {
  const SellerReviewsWidget({super.key, required this.sellerRef});

  final DocumentReference? sellerRef;

  static String routeName = 'SellerReviews';
  static String routePath = '/sellerReviews';

  @override
  State<SellerReviewsWidget> createState() => _SellerReviewsWidgetState();
}

class _SellerReviewsWidgetState extends State<SellerReviewsWidget> {
  late SellerReviewsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kRed = Color(0xFFDC0F0F);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _soft => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFF0F2F5);
  Color get _text => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SellerReviewsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: _text),
          onPressed: () => context.safePop(),
        ),
        title: Text(
          'Customer Reviews',
          style: TextStyle(
            color: _text,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<ReviewsRecord>>(
        stream: queryReviewsRecord(
          queryBuilder: (r) => r
              .where('seller', isEqualTo: widget.sellerRef)
              .orderBy('date', descending: true),
          limit: 200,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load reviews.\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontSize: 13),
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(kGreen),
                  strokeWidth: 3,
                ),
              ),
            );
          }

          final all = snapshot.data!;
          final filter = _model.filter ?? 'all';
          final list = filter == 'unreplied'
              ? all.where((r) => r.sellerReply.isEmpty).toList()
              : all;

          return Column(
            children: [
              _buildFilterChips(all),
              Expanded(
                child: list.isEmpty
                    ? _buildEmpty(filter)
                    : RefreshIndicator(
                        color: kGreen,
                        onRefresh: () async {
                          safeSetState(() {});
                          await Future.delayed(
                              const Duration(milliseconds: 400));
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                          itemCount: list.length,
                          itemBuilder: (_, i) => _reviewCard(list[i]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(List<ReviewsRecord> all) {
    final unreplied =
        all.where((r) => r.sellerReply.isEmpty).length;
    final chips = [
      ('all', 'All (${all.length})'),
      ('unreplied', 'Unreplied ($unreplied)'),
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: chips.map((c) {
          final selected = (_model.filter ?? 'all') == c.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => safeSetState(() => _model.filter = c.$1),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? kGreen : _card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? kGreen : _border,
                  ),
                ),
                child: Text(
                  c.$2,
                  style: TextStyle(
                    color: selected ? Colors.white : _text,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmpty(String filter) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.reviews_outlined, color: _muted, size: 48),
            const SizedBox(height: 12),
            Text(
              filter == 'unreplied'
                  ? 'No unreplied reviews 🎉'
                  : 'No reviews yet',
              style: TextStyle(color: _muted, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewCard(ReviewsRecord r) {
    final hasReply = r.sellerReply.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasReply ? _border : kAmber.withOpacity(0.5),
          width: hasReply ? 1 : 1.5,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _soft,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.antiAlias,
                child: r.reviewersImage.isEmpty
                    ? Icon(Icons.person_rounded, color: _muted, size: 20)
                    : Image.network(
                        r.reviewersImage,
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
                    Text(
                      r.reviewersName,
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
                        ...List.generate(
                          5,
                          (i) => Icon(
                            i < r.rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: kAmber,
                            size: 14,
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
              if (!hasReply)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: kAmber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'NEEDS REPLY',
                    style: TextStyle(
                      color: kAmber,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.4,
                    ),
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
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ],
          if (hasReply) ...[
            const SizedBox(height: 10),
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
                          color: kGreen, size: 13),
                      const SizedBox(width: 5),
                      Text(
                        'Your reply',
                        style: TextStyle(
                          color: kGreen,
                          fontSize: 11,
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
                  const SizedBox(height: 5),
                  Text(
                    r.sellerReply,
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _openReplySheet(r),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: hasReply
                          ? kGreen.withOpacity(0.10)
                          : kGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          hasReply
                              ? Icons.edit_rounded
                              : Icons.reply_rounded,
                          color: hasReply ? kGreen : Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          hasReply ? 'Edit reply' : 'Reply',
                          style: TextStyle(
                            color: hasReply ? kGreen : Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openReplySheet(ReviewsRecord r) async {
    final controller = TextEditingController(text: r.sellerReply);
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: _card,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: kGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(Icons.storefront_rounded,
                          color: kGreen, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.sellerReply.isEmpty
                                ? 'Reply to review'
                                : 'Edit your reply',
                            style: TextStyle(
                              color: _text,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'From ${r.reviewersName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: _muted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'YOUR REPLY',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: _soft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _border),
                  ),
                  child: TextField(
                    controller: controller,
                    maxLines: 5,
                    minLines: 4,
                    maxLength: 500,
                    style:
                        TextStyle(color: _text, fontSize: 14, height: 1.4),
                    cursorColor: kGreen,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText:
                          'Thank the customer, answer questions...',
                      hintStyle:
                          TextStyle(color: _muted, fontSize: 13.5),
                      contentPadding: const EdgeInsetsDirectional.fromSTEB(
                          14, 14, 14, 14),
                      counterStyle:
                          TextStyle(color: _muted, fontSize: 10.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final text = controller.text.trim();
                    if (text.isEmpty) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(
                          content: Text('Please write a reply'),
                          backgroundColor: kRed,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    try {
                      await r.reference.update({
                        'seller_reply': text,
                        'seller_reply_date': getCurrentTimestamp,
                      });
                      if (ctx.mounted) Navigator.pop(ctx, true);
                    } catch (e) {
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(
                            content: Text('Failed: $e'),
                            backgroundColor: kRed,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kGreen, Color(0xFF0A3A22)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_rounded,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            r.sellerReply.isEmpty
                                ? 'Post Reply'
                                : 'Update Reply',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
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
      },
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reply saved'),
          backgroundColor: kGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      safeSetState(() {});
    }
    controller.dispose();
  }

  String _timeAgo(DateTime when) {
    final d = DateTime.now().difference(when);
    if (d.inSeconds < 60) return 'Just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    if (d.inDays < 7) return '${d.inDays}d ago';
    return '${when.day}/${when.month}/${when.year}';
  }
}
