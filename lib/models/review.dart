// ZanNext — Review model

class Review {
  final String id;
  final String productId;
  final String? sellerId;
  final String reviewerId;
  final String? reviewersName;
  final String? reviewersImage;
  final int rating;
  final String? message;
  final String? sellerReply;
  final DateTime? sellerReplyDate;
  final DateTime? createdAt;

  Review({
    required this.id,
    required this.productId,
    this.sellerId,
    required this.reviewerId,
    this.reviewersName,
    this.reviewersImage,
    required this.rating,
    this.message,
    this.sellerReply,
    this.sellerReplyDate,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'] as String,
        productId: json['product_id'] as String,
        sellerId: json['seller_id'] as String?,
        reviewerId: json['reviewer_id'] as String,
        reviewersName: json['reviewers_name'] as String?,
        reviewersImage: json['reviewers_image'] as String?,
        rating: json['rating'] as int,
        message: json['message'] as String?,
        sellerReply: json['seller_reply'] as String?,
        sellerReplyDate: json['seller_reply_date'] != null
            ? DateTime.tryParse(json['seller_reply_date'] as String)
            : null,
        createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'seller_id': sellerId,
        'reviewer_id': reviewerId,
        'reviewers_name': reviewersName,
        'reviewers_image': reviewersImage,
        'rating': rating,
        'message': message,
        'seller_reply': sellerReply,
        'seller_reply_date': sellerReplyDate?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
      };
}
