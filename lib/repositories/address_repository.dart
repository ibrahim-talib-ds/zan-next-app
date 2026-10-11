// ZanNext — AddressRepository

import '../models/address.dart';
import '../services/api_client.dart';

class AddressRepository {
  /// List a user's addresses.
  static Future<List<Address>> listForUser(String userId) async {
    final result = await ApiClient.get('/addresses?user_id=$userId') as List;
    return result
        .map((j) => Address.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Create a new address.
  static Future<Address> create(Map<String, dynamic> data) async {
    final result = await ApiClient.post('/addresses', body: data);
    return Address.fromJson(result as Map<String, dynamic>);
  }

  /// Update an address.
  static Future<Address> update(String addressId, Map<String, dynamic> patch) async {
    final result = await ApiClient.patch('/addresses/$addressId', body: patch);
    return Address.fromJson(result as Map<String, dynamic>);
  }

  /// Delete an address.
  static Future<void> delete(String addressId) async {
    await ApiClient.delete('/addresses/$addressId');
  }
}
