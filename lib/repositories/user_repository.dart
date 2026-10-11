// ZanNext — UserRepository

import '../models/user.dart';
import '../services/api_client.dart';

class UserRepository {
  /// List users (hides placeholders by default).
  static Future<List<User>> list({bool includePlaceholders = false}) async {
    final path = includePlaceholders
        ? '/users?include_placeholders=true'
        : '/users';
    final result = await ApiClient.get(path) as List;
    return result
        .map((j) => User.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Get a single user by id.
  static Future<User> get(String userId) async {
    final result = await ApiClient.get('/users/$userId');
    return User.fromJson(result as Map<String, dynamic>);
  }

  /// Update own profile.
  static Future<User> update(String userId, Map<String, dynamic> patch) async {
    final result = await ApiClient.patch('/users/$userId', body: patch);
    return User.fromJson(result as Map<String, dynamic>);
  }
}
