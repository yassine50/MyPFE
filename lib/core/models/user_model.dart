class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String profileImage;
  final DateTime createdAt;

  // User preferences (persisted in Firebase)
  final String language;
  final String currency;
  final bool pushNotifications;
  final bool emailUpdates;
  final bool faceIdLogin;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.createdAt,
    this.language = 'en',
    this.currency = 'EUR',
    this.pushNotifications = true,
    this.emailUpdates = false,
    this.faceIdLogin = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      language: json['language'] as String? ?? 'en',
      currency: json['currency'] as String? ?? 'EUR',
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      emailUpdates: json['emailUpdates'] as bool? ?? false,
      faceIdLogin: json['faceIdLogin'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'language': language,
      'currency': currency,
      'pushNotifications': pushNotifications,
      'emailUpdates': emailUpdates,
      'faceIdLogin': faceIdLogin,
    };
  }
}
