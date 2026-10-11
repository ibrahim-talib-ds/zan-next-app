// ZanNext — ProductRepository

import '../models/product.dart';
import '../services/api_client.dart';

class ProductRepository {
  /// List products with optional filters.
  static Future<List<Product>> list({
    String? category,
    String? mainCategory,
    String? sellerId,
    String? brand,
    bool? boosted,
    bool? newIn,
    bool? topSelling,
    double? minPrice,
    double? maxPrice,
    bool includePlaceholders = false,
    int limit = 50,
    int offset = 0,
  }) async {
    final q = <String, String>{};
    if (category != null) q['category'] = category;
    if (mainCategory != null) q['main_category'] = mainCategory;
    if (sellerId != null) q['seller_id'] = sellerId;
    if (brand != null) q['brand'] = brand;
    if (boosted != null) q['boosted'] = boosted.toString();
    if (newIn != null) q['new_in'] = newIn.toString();
    if (topSelling != null) q['top_selling'] = topSelling.toString();
    if (minPrice != null) q['min_price'] = minPrice.toString();
    if (maxPrice != null) q['max_price'] = maxPrice.toString();
    if (includePlaceholders) q['include_placeholders'] = 'true';
    q['limit'] = limit.toString();
    q['offset'] = offset.toString();

    final queryString = q.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final result = await ApiClient.get('/products?$queryString') as List;
    return result
        .map((j) => Product.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Get a single product.
  static Future<Product> get(String productId) async {
    final result = await ApiClient.get('/products/$productId');
    return Product.fromJson(result as Map<String, dynamic>);
  }

  /// Create a new product. The current user becomes the seller.
  static Future<Product> create(Map<String, dynamic> data) async {
    final result = await ApiClient.post('/products', body: data);
    return Product.fromJson(result as Map<String, dynamic>);
  }

  /// Update own product.
  static Future<Product> update(String productId, Map<String, dynamic> patch) async {
    final result = await ApiClient.patch('/products/$productId', body: patch);
    return Product.fromJson(result as Map<String, dynamic>);
  }

  /// Soft-delete own product.
  static Future<void> delete(String productId) async {
    await ApiClient.delete('/products/$productId');
  }

  /// Record a view on a product.
  static Future<Map<String, dynamic>> recordView(String productId) async {
    final result = await ApiClient.post('/products/$productId/view');
    return result as Map<String, dynamic>;
  }

  /// Get reviews for a product.
  static Future<List<dynamic>> reviews(String productId) async {
    final result = await ApiClient.get('/products/$productId/reviews') as List;
    return result;
  }
}
