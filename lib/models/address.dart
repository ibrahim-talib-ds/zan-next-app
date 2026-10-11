// ZanNext — Address model

class Address {
  final String id;
  final String userId;
  final String? label;
  final String? city;
  final String? district;
  final String? streetAddress;
  final String? houseNo;
  final String? landmark;
  final String? phone;
  final String? notes;
  final DateTime? createdAt;

  Address({
    required this.id,
    required this.userId,
    this.label,
    this.city,
    this.district,
    this.streetAddress,
    this.houseNo,
    this.landmark,
    this.phone,
    this.notes,
    this.createdAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        label: json['label'] as String?,
        city: json['city'] as String?,
        district: json['district'] as String?,
        streetAddress: json['street_address'] as String?,
        houseNo: json['house_no'] as String?,
        landmark: json['landmark'] as String?,
        phone: json['phone'] as String?,
        notes: json['notes'] as String?,
        createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'label': label,
        'city': city,
        'district': district,
        'street_address': streetAddress,
        'house_no': houseNo,
        'landmark': landmark,
        'phone': phone,
        'notes': notes,
        'created_at': createdAt?.toIso8601String(),
      };
}
