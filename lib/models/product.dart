// ZanNext — Product model

class Product {
  final String id;
  final String sellerId;
  final String? sellerName;
  final String? sellerNumber;
  final String? sellerWhatsapp;
  final String name;
  final String? description;
  final double price;
  final String? category;
  final String? mainCategory;
  final String? brand;
  final String? condition;
  final String? gender;
  final List<String>? materials;
  final List<String>? availableColors;
  final List<String>? availableAlphasize;
  final int stock;
  final String? shippingDays;
  final List<String>? images;
  final String? location;
  final double rating;
  final int reviewsCount;
  final int viewCount;
  final bool allProducts;
  final bool boosted;
  final bool newIn;
  final bool topSelling;
  final bool isOnline;
  final String? status;
  final DateTime? createdAt;
  final DateTime? lastActive;

  Product({
    required this.id,
    required this.sellerId,
    this.sellerName,
    this.sellerNumber,
    this.sellerWhatsapp,
    required this.name,
    this.description,
    required this.price,
    this.category,
    this.mainCategory,
    this.brand,
    this.condition,
    this.gender,
    this.materials,
    this.availableColors,
    this.availableAlphasize,
    this.stock = 0,
    this.shippingDays,
    this.images,
    this.location,
    this.rating = 0,
    this.reviewsCount = 0,
    this.viewCount = 0,
    this.allProducts = true,
    this.boosted = false,
    this.newIn = false,
    this.topSelling = false,
    this.isOnline = true,
    this.status,
    this.createdAt,
    this.lastActive,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        sellerId: json['seller_id'] as String,
        sellerName: json['seller_name'] as String?,
        sellerNumber: json['seller_number'] as String?,
        sellerWhatsapp: json['seller_whatsapp'] as String?,
        name: json['name'] as String,
        description: json['description'] as String?,
        price: (json['price'] as num).toDouble(),
        category: json['category'] as String?,
        mainCategory: json['main_category'] as String?,
        brand: json['brand'] as String?,
        condition: json['condition'] as String?,
        gender: json['gender'] as String?,
        materials: (json['materials'] as List?)?.cast<String>(),
        availableColors: (json['available_colors'] as List?)?.cast<String>(),
        availableAlphasize: (json['available_alphasize'] as List?)?.cast<String>(),
        stock: json['stock'] as int? ?? 0,
        shippingDays: json['shipping_days'] as String?,
        images: (json['images'] as List?)?.cast<String>(),
        location: json['location'] as String?,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        reviewsCount: json['reviews_count'] as int? ?? 0,
        viewCount: json['view_count'] as int? ?? 0,
        allProducts: json['all_products'] as bool? ?? true,
        boosted: json['boosted'] as bool? ?? false,
        newIn: json['new_in'] as bool? ?? false,
        topSelling: json['top_selling'] as bool? ?? false,
        isOnline: json['is_online'] as bool? ?? true,
        status: json['status'] as String?,
        createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
        lastActive: json['last_active'] != null ? DateTime.tryParse(json['last_active'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'seller_id': sellerId,
        'seller_name': sellerName,
        'seller_number': sellerNumber,
        'seller_whatsapp': sellerWhatsapp,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'main_category': mainCategory,
        'brand': brand,
        'condition': condition,
        'gender': gender,
        'materials': materials,
        'available_colors': availableColors,
        'available_alphasize': availableAlphasize,
        'stock': stock,
        'shipping_days': shippingDays,
        'images': images,
        'location': location,
        'rating': rating,
        'reviews_count': reviewsCount,
        'view_count': viewCount,
        'all_products': allProducts,
        'boosted': boosted,
        'new_in': newIn,
        'top_selling': topSelling,
        'is_online': isOnline,
        'status': status,
        'created_at': createdAt?.toIso8601String(),
        'last_active': lastActive?.toIso8601String(),
      };

  String? get primaryImage => (images != null && images!.isNotEmpty) ? images!.first : null;
}
