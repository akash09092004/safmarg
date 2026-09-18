class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final bool isActive;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.role = 'user',
    this.isActive = true,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString() ?? 'user',
      isActive: _toBool(
        json['is_active'] ?? json['status'],
      ),
      profileImage:
          json['profile_image']?.toString(),
      createdAt: _parseDate(
        json['created_at'],
      ),
      updatedAt: _parseDate(
        json['updated_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'is_active': isActive ? 1 : 0,
      'profile_image': profileImage,
      'created_at':
          createdAt?.toIso8601String(),
      'updated_at':
          updatedAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    bool? isActive,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive:
          isActive ?? this.isActive,
      profileImage:
          profileImage ?? this.profileImage,
      createdAt:
          createdAt ?? this.createdAt,
      updatedAt:
          updatedAt ?? this.updatedAt,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value.toInt() == 1;
    }

    final text =
        value?.toString().toLowerCase();

    return text == '1' ||
        text == 'true' ||
        text == 'active';
  }

  static DateTime? _parseDate(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(
      value
          .toString()
          .replaceFirst(' ', 'T'),
    );
  }
}

