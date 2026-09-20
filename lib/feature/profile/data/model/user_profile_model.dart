/// Data-layer model for the `UserResponseDTO` returned by the Spring Boot
/// `/api/user-profiles` endpoints.
class UserProfileModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? gender;
  final String? role;
  final String? profilePicture;
  final bool active;
  final String? authProvider;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.gender,
    this.role,
    this.profilePicture,
    required this.active,
    this.authProvider,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      gender: json['gender']?.toString(),
      role: json['role']?.toString(),
      profilePicture: json['profilePicture']?.toString(),
      active: json['active'] as bool? ?? false,
      authProvider: json['authProvider']?.toString(),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'role': role,
      'profilePicture': profilePicture,
      'active': active,
      'authProvider': authProvider,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}