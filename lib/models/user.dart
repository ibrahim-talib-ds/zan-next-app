// ZanNext — User model

class User {
  final String id;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final String? gender;
  final DateTime? birthday;
  final String? city;
  final String? district;
  final bool isAdmin;
  final bool isOnline;
  final DateTime? lastActive;
  final String? fcmToken;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.gender,
    this.birthday,
    this.city,
    this.district,
    this.isAdmin = false,
    this.isOnline = false,
    this.lastActive,
    this.fcmToken,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        email: json['email'] as String,
        displayName: json['display_name'] as String?,
        phoneNumber: json['phone_number'] as String?,
        photoUrl: json['photo_url'] as String?,
        gender: json['gender'] as String?,
        birthday: json['birthday'] != null ? DateTime.tryParse(json['birthday'] as String) : null,
        city: json['city'] as String?,
        district: json['district'] as String?,
        isAdmin: json['is_admin'] as bool? ?? false,
        isOnline: json['is_online'] as bool? ?? false,
        lastActive: json['last_active'] != null ? DateTime.tryParse(json['last_active'] as String) : null,
        fcmToken: json['fcm_token'] as String?,
        createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'display_name': displayName,
        'phone_number': phoneNumber,
        'photo_url': photoUrl,
        'gender': gender,
        'birthday': birthday?.toIso8601String(),
        'city': city,
        'district': district,
        'is_admin': isAdmin,
        'is_online': isOnline,
        'last_active': lastActive?.toIso8601String(),
        'fcm_token': fcmToken,
        'created_at': createdAt?.toIso8601String(),
      };
}
