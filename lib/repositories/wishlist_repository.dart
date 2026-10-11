// ZanNext — WishlistRepository

import '../models/wishlist_item.dart';
import '../services/api_client.dart';

class WishlistRepository {
  /// List a user's wishlist items.
  static Future<List<WishlistItem>> listForUser(String userId) async {
    final result = await ApiClient.get('/wishlist?user_id=$userId') as List;
    return result
        .map((j) => WishlistItem.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Add a product to the current user's wishlist.
  static Future<Map<String, dynamic>> add(String productId) async {
    final result = await ApiClient.post('/wishlist/$productId');
    return result as Map<String, dynamic>;
  }

  /// Remove a product from the current user's wishlist.
  static Future<void> remove(String productId) async {
    await ApiClient.delete('/wishlist/$productId');
  }
}
