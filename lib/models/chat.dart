// ZanNext — Chat model

class Chat {
  final String id;
  final String buyerId;
  final String sellerId;
  final String? productId;
  final String? productName;
  final double? price;
  final List<String>? itemImages;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? buyerName;
  final String? sellerName;
  final List<String>? lastMessageSeenBy;
  final DateTime? createdAt;

  Chat({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    this.productId,
    this.productName,
    this.price,
    this.itemImages,
    this.lastMessage,
    this.lastMessageTime,
    this.buyerName,
    this.sellerName,
    this.lastMessageSeenBy,
    this.createdAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'] as String,
        buyerId: json['buyer_id'] as String,
        sellerId: json['seller_id'] as String,
        productId: json['product_id'] as String?,
        productName: json['product_name'] as String?,
        price: (json['price'] as num?)?.toDouble(),
        itemImages: (json['item_images'] as List?)?.cast<String>(),
        lastMessage: json['last_message'] as String?,
        lastMessageTime: json['last_message_time'] != null ? DateTime.tryParse(json['last_message_time'] as String) : null,
        buyerName: json['buyer_name'] as String?,
        sellerName: json['seller_name'] as String?,
        lastMessageSeenBy: (json['last_message_seen_by'] as List?)?.cast<String>(),
        createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'buyer_id': buyerId,
        'seller_id': sellerId,
        'product_id': productId,
        'product_name': productName,
        'price': price,
        'item_images': itemImages,
        'last_message': lastMessage,
        'last_message_time': lastMessageTime?.toIso8601String(),
        'buyer_name': buyerName,
        'seller_name': sellerName,
        'last_message_seen_by': lastMessageSeenBy,
        'created_at': createdAt?.toIso8601String(),
      };
}
