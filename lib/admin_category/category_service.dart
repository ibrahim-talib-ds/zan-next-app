import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Manages custom category data (image, name, route).
/// Admin can edit; all users see the result.
class CategoryService {
  static const String collection = 'category_config';

  /// Fetch all category overrides once.
  static Future<Map<String, Map<String, dynamic>>> fetchAll() async {
    try {
      final snap =
          await FirebaseFirestore.instance.collection(collection).get();
      final map = <String, Map<String, dynamic>>{};
      for (final doc in snap.docs) {
        map[doc.id] = doc.data();
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
    final data = <String, dynamic>{
      'updated_at': FieldValue.serverTimestamp(),
    };
    if (imageUrl != null) data['image_url'] = imageUrl;
    if (label != null) data['label'] = label;
    if (routeName != null) data['route_name'] = routeName;

    await FirebaseFirestore.instance
        .collection(collection)
        .doc(categoryKey)
        .set(data, SetOptions(merge: true));
  }

  /// Stream of one category's override (live).
  static Stream<Map<String, dynamic>?> streamCategory(String key) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(key)
        .snapshots()
        .map((d) => d.data());
  }
}
