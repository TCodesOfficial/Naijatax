class UserModel {
  final String id;
  final String? email;
  final String? phone;
  final String? displayName;
  final String role;
  final String? avatarUrl;
  final bool onboarded;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    this.email,
    this.phone,
    this.displayName,
    this.role = 'USER',
    this.avatarUrl,
    this.onboarded = false,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        displayName: json['displayName'] as String?,
        role: json['role'] as String? ?? 'USER',
        avatarUrl: json['avatarUrl'] as String?,
        onboarded: json['onboarded'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'phone': phone,
        'displayName': displayName,
        'role': role,
        'avatarUrl': avatarUrl,
        'onboarded': onboarded,
        'createdAt': createdAt.toIso8601String(),
      };
}
