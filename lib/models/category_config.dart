// ZanNext — CategoryConfig model

class CategoryConfig {
  final String categoryKey;
  final String? label;
  final String? imageUrl;
  final String? routeName;
  final DateTime? updatedAt;

  CategoryConfig({
    required this.categoryKey,
    this.label,
    this.imageUrl,
    this.routeName,
    this.updatedAt,
  });

  factory CategoryConfig.fromJson(Map<String, dynamic> json) => CategoryConfig(
        categoryKey: json['category_key'] as String,
        label: json['label'] as String?,
        imageUrl: json['image_url'] as String?,
        routeName: json['route_name'] as String?,
        updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'category_key': categoryKey,
        'label': label,
        'image_url': imageUrl,
        'route_name': routeName,
        'updated_at': updatedAt?.toIso8601String(),
      };
}
