/// The current user's profile, backed by the Spring Boot
/// `UserResponseDTO` returned by the `/api/user-profiles/me` endpoints.
class UserProfile {
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

  const UserProfile({
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

  String get fullName {
    return [firstName, lastName]
        .where((name) => name.trim().isNotEmpty)
        .join(' ')
        .trim();
  }

  UserProfile copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    String? role,
    String? profilePicture,
    bool? active,
    String? authProvider,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      active: active ?? this.active,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}