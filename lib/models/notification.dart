// ZanNext — AppNotification model

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String? imageUrl;
  final String? productId;
  final String? type;
  final bool isRead;
  final DateTime? createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.imageUrl,
    this.productId,
    this.type,
    this.isRead = false,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        imageUrl: json['image_url'] as String?,
        productId: json['product_id'] as String?,
        type: json['type'] as String?,
        isRead: json['is_read'] as bool? ?? false,
        createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'body': body,
        'image_url': imageUrl,
        'product_id': productId,
        'type': type,
        'is_read': isRead,
        'created_at': createdAt?.toIso8601String(),
      };
}
