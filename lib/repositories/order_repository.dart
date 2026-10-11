// ZanNext — OrderRepository

import '../models/order.dart';
import '../services/api_client.dart';

class OrderRepository {
  /// List orders where the given user is buyer or seller.
  static Future<List<Order>> listForUser(String userId) async {
    final result = await ApiClient.get('/orders?user_id=$userId') as List;
    return result
        .map((j) => Order.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Get a single order.
  static Future<Order> get(String orderId) async {
    final result = await ApiClient.get('/orders/$orderId');
    return Order.fromJson(result as Map<String, dynamic>);
  }

  /// Create a new order. Buyer is the current user.
  static Future<Order> create(Map<String, dynamic> data) async {
    final result = await ApiClient.post('/orders', body: data);
    return Order.fromJson(result as Map<String, dynamic>);
  }

  /// Update the status of an order.
  static Future<Order> updateStatus(String orderId, String status, {String? note}) async {
    final result = await ApiClient.patch(
      '/orders/$orderId/status',
      body: {'status': status, if (note != null) 'note': note},
    );
    return Order.fromJson(result as Map<String, dynamic>);
  }

  /// Soft-hide an order for the current user.
  static Future<void> hide(String orderId) async {
    await ApiClient.delete('/orders/$orderId');
  }
}
