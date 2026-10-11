// ZanNext — Order model

class Order {
  final String id;
  final String buyerId;
  final String sellerId;
  final String? productId;
  final String? buyerName;
  final String? buyerPhone;
  final String? buyerNotes;
  final String? sellerName;
  final String? productName;
  final List<String>? itemImages;
  final double? price;
  final String? address;
  final String status;
  final List<dynamic> statusHistory;
  final bool hiddenForBuyer;
  final bool hiddenForSeller;
  final DateTime? createdAt;
  final int totalItems;
  final String? orderNo;
  final String? driverName;
  final String? driverNumber;

  Order({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    this.productId,
    this.buyerName,
    this.buyerPhone,
    this.buyerNotes,
    this.sellerName,
    this.productName,
    this.itemImages,
    this.price,
    this.address,
    this.status = 'pending',
    this.statusHistory = const [],
    this.hiddenForBuyer = false,
    this.hiddenForSeller = false,
    this.createdAt,
    this.totalItems = 1,
    this.orderNo,
    this.driverName,
    this.driverNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String,
        buyerId: json['buyer_id'] as String,
        sellerId: json['seller_id'] as String,
        productId: json['product_id'] as String?,
        buyerName: json['buyer_name'] as String?,
        buyerPhone: json['buyer_phone'] as String?,
        buyerNotes: json['buyer_notes'] as String?,
        sellerName: json['seller_name'] as String?,
        productName: json['product_name'] as String?,
        itemImages: (json['item_images'] as List?)?.cast<String>(),
        price: (json['price'] as num?)?.toDouble(),
        address: json['address'] as String?,
        status: json['status'] as String? ?? 'pending',
        statusHistory: (json['status_history'] as List?) ?? const [],
        hiddenForBuyer: json['hidden_for_buyer'] as bool? ?? false,
        hiddenForSeller: json['hidden_for_seller'] as bool? ?? false,
        createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
        totalItems: json['total_items'] as int? ?? 1,
        orderNo: json['order_no'] as String?,
        driverName: json['driver_name'] as String?,
        driverNumber: json['driver_number'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'buyer_id': buyerId,
        'seller_id': sellerId,
        'product_id': productId,
        'buyer_name': buyerName,
        'buyer_phone': buyerPhone,
        'buyer_notes': buyerNotes,
        'seller_name': sellerName,
        'product_name': productName,
        'item_images': itemImages,
        'price': price,
        'address': address,
        'status': status,
        'status_history': statusHistory,
        'hidden_for_buyer': hiddenForBuyer,
        'hidden_for_seller': hiddenForSeller,
        'created_at': createdAt?.toIso8601String(),
        'total_items': totalItems,
        'order_no': orderNo,
        'driver_name': driverName,
        'driver_number': driverNumber,
      };
}
