// ZanNext — CategoryRepository

import '../models/category_config.dart';
import '../services/api_client.dart';

class CategoryRepository {
  /// List all categories.
  static Future<List<CategoryConfig>> list() async {
    final result = await ApiClient.get('/categories') as List;
    return result
        .map((j) => CategoryConfig.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
