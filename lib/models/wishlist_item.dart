// ZanNext — WishlistItem model

class WishlistItem {
  final String id;
  final String userId;
  final String productId;
  final DateTime? createdAt;
  final String? productName;
  final double? productPrice;
  final List<String>? productImages;
  final String? category;
  final String? productStatus;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.productId,
    this.createdAt,
    this.productName,
    this.productPrice,
    this.productImages,
    this.category,
    this.productStatus,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        productId: json['product_id'] as String,
        createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
        productName: json['product_name'] as String?,
        productPrice: (json['product_price'] as num?)?.toDouble(),
        productImages: (json['product_images'] as List?)?.cast<String>(),
        category: json['category'] as String?,
        productStatus: json['product_status'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'product_id': productId,
        'created_at': createdAt?.toIso8601String(),
        'product_name': productName,
        'product_price': productPrice,
        'product_images': productImages,
        'category': category,
        'product_status': productStatus,
      };

  String? get primaryImage => (productImages != null && productImages!.isNotEmpty) ? productImages!.first : null;
}
