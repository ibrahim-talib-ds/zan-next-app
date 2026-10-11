// ZanNext — CategoryService (API-backed)
//
// Same public API as before, but reads/writes from our Postgres backend
// instead of Firestore. Admin editor and any readers keep working unchanged.

import '/services/api_client.dart' as zannext_api;

/// Manages custom category data (image, name, route).
/// Admin can edit; all users see the result.
class CategoryService {
  /// Fetch all category overrides once.
  /// Returns Map<category_key, {label, image_url, route_name, updated_at}>
  static Future<Map<String, Map<String, dynamic>>> fetchAll() async {
    try {
      final raw = await zannext_api.ApiClient.get('/categories') as List;
      final map = <String, Map<String, dynamic>>{};
      for (final item in raw) {
        final d = (item as Map).cast<String, dynamic>();
        final key = (d['category_key'] ?? '').toString();
        if (key.isEmpty) continue;
        map[key] = {
          'label': d['label'],
          'image_url': d['image_url'],
          'route_name': d['route_name'],
          'updated_at': d['updated_at'],
        };
      }
      return map;
    } catch (_) {
      return {};
    }
  }

  /// Save override for a specific category.
  static Future<void> saveCategory(
    String categoryKey, {
    String? imageUrl,
    String? label,
    String? routeName,
  }) async {
    final body = <String, dynamic>{};
    if (imageUrl != null) body['image_url'] = imageUrl;
    if (label != null) body['label'] = label;
    if (routeName != null) body['route_name'] = routeName;

    if (body.isEmpty) return;

    await zannext_api.ApiClient.patch(
      '/categories/$categoryKey',
      body: body,
    );
  }

  /// Stream of one category's override.
  /// Our backend doesn't have realtime; we fetch once and return a single-value stream.
  /// Widgets that listened for updates will get one value on mount, which is fine.
  static Stream<Map<String, dynamic>?> streamCategory(String key) async* {
    try {
      final all = await fetchAll();
      yield all[key];
    } catch (_) {
      yield null;
    }
  }
}
