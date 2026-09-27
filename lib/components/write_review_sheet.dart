import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/internationalization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// Bottom sheet for writing a product review.
/// Returns `true` if a review was submitted.
class WriteReviewSheet extends StatefulWidget {
  const WriteReviewSheet({
    super.key,
    required this.product,
    this.existingReview,
  });

  final InventoryRecord product;
  final ReviewsRecord? existingReview;

  @override
  State<WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<WriteReviewSheet> {
  final TextEditingController _controller = TextEditingController();
  double _rating = 5;
  bool _saving = false;

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      _rating = widget.existingReview!.rating.toDouble();
      _controller.text = widget.existingReview!.reviewsMessage;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (currentUserReference == null) return;
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _snack(FFLocalizations.of(context).getText('wr_empty'));
      return;
    }

    setState(() => _saving = true);
    try {
      // Update existing OR create new
      if (widget.existingReview != null) {
        await widget.existingReview!.reference.update({
          'rating': _rating.round(),
          'reviews_message': text,
          'date': getCurrentTimestamp,
        });
      } else {
        // Check if user already reviewed this product
        final existing = await FirebaseFirestore.instance
            .collection('reviews')
            .where('product_ref', isEqualTo: widget.product.reference)
            .where('reviewer_ref', isEqualTo: currentUserReference)
            .limit(1)
            .get();

        if (existing.docs.isNotEmpty) {
          // Update their existing review
          await existing.docs.first.reference.update({
            'rating': _rating.round(),
            'reviews_message': text,
            'date': getCurrentTimestamp,
          });
        } else {
          // Create new review
          await ReviewsRecord.collection.doc().set({
            'reviewers_name': currentUserDisplayName,
            'reviewers_image': currentUserPhoto,
            'reviewer_ref': currentUserReference,
            'reviews_message': text,
            'rating': _rating.round(),
            'date': getCurrentTimestamp,
            'product_ref': widget.product.reference,
            'seller': widget.product.sellersRef,
          });
        }
      }

      // Recalculate product rating (simple avg)
      await _recalcProductRating();

      if (!mounted) return;
      Navigator.pop(context, true);
      _snack(FFLocalizations.of(context).getText('wr_saved'), success: true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _snack('${FFLocalizations.of(context).getText('wr_failed')}$e');
    }
  }

  Future<void> _recalcProductRating() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('reviews')
          .where('product_ref', isEqualTo: widget.product.reference)
          .get();
      if (snap.docs.isEmpty) return;
      double total = 0;
      for (final d in snap.docs) {
        final r = d.data()['rating'];
        if (r is num) total += r.toDouble();
      }
      final avg = total / snap.docs.length;
      await widget.product.reference.update({
        'rating': avg,
        'reviews': snap.docs.length,
      });
    } catch (_) {}
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? kGreen : kRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final text = isDark ? Colors.white : const Color(0xFF111827);
    final muted = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final border = isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);
    final soft = isDark ? const Color(0xFF2A2A2C) : const Color(0xFFF0F2F5);

    final isEditing = widget.existingReview != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: kGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.rate_review_rounded,
                      color: kGreen, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditing
                            ? FFLocalizations.of(context).getText('wr_edit_title')
                            : FFLocalizations.of(context).getText('wr_write_title'),
                        style: TextStyle(
                          color: text,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.product.inventoryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Star rating
            Text(
              FFLocalizations.of(context).getText('wr_your_rating'),
              style: TextStyle(
                color: muted,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 42,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (_, __) => const Icon(
                  Icons.star_rounded,
                  color: kAmber,
                ),
                onRatingUpdate: (v) => setState(() => _rating = v),
              ),
            ),
            const SizedBox(height: 22),

            // Review text
            Text(
              FFLocalizations.of(context).getText('wr_your_review'),
              style: TextStyle(
                color: muted,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: soft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: TextField(
                controller: _controller,
                maxLines: 5,
                minLines: 4,
                maxLength: 500,
                style: TextStyle(color: text, fontSize: 14, height: 1.4),
                cursorColor: kGreen,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: FFLocalizations.of(context).getText('wr_review_hint'),
                  hintStyle: TextStyle(color: muted, fontSize: 13.5),
                  contentPadding:
                      const EdgeInsetsDirectional.fromSTEB(14, 14, 14, 14),
                  counterStyle: TextStyle(color: muted, fontSize: 10.5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Save button
            GestureDetector(
              onTap: _saving ? null : _submit,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kGreen, Color(0xFF0A3A22)],
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
                child: Center(
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              isEditing
                                  ? FFLocalizations.of(context).getText('wr_update')
                                  : FFLocalizations.of(context).getText('wr_post'),
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
  }
}
