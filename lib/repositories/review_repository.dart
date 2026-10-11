// ZanNext — ReviewRepository

import '../models/review.dart';
import '../services/api_client.dart';

class ReviewRepository {
  /// List all reviews (newest first) — for the Reviews screen.
  static Future<List<Review>> list({int limit = 100, int offset = 0}) async {
    final result = await ApiClient.get(
      '/reviews?limit=$limit&offset=$offset',
    ) as List;
    return result
        .map((j) => Review.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Get reviews for a product.
  static Future<List<Review>> listForProduct(String productId) async {
    final result = await ApiClient.get('/products/$productId/reviews') as List;
    return result
        .map((j) => Review.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// List reviews for a seller (across all their products).
  static Future<List<Review>> listForSeller(String sellerId) async {
    final result = await ApiClient.get(
      '/reviews?seller_id=$sellerId&limit=200',
    ) as List;
    return result
        .map((j) => Review.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Seller replies to a review.
  static Future<Review> reply(String reviewId, String text) async {
    final result = await ApiClient.patch(
      '/reviews/$reviewId/reply',
      body: {'seller_reply': text},
    );
    return Review.fromJson(result as Map<String, dynamic>);
  }

  /// Create a review for a product.
  static Future<Review> create(String productId, {required int rating, String? message}) async {
    final result = await ApiClient.post(
      '/products/$productId/reviews',
      body: {'rating': rating, if (message != null) 'message': message},
    );
    return Review.fromJson(result as Map<String, dynamic>);
  }

  /// Delete own review.
  static Future<void> delete(String reviewId) async {
    await ApiClient.delete('/reviews/$reviewId');
  }
}
