import 'package:vehicle_rental_system/feature/profile/data/model/user_profile_model.dart';
import 'package:vehicle_rental_system/feature/profile/domain/entity/user_profile.dart';

/// Converts between the [UserProfile] domain entity and the
/// [UserProfileModel] data model.
class UserProfileMapper {
  const UserProfileMapper._();

  static UserProfile toEntity(UserProfileModel model) {
    return UserProfile(
      id: model.id,
      firstName: model.firstName,
      lastName: model.lastName,
      email: model.email,
      phone: model.phone,
      gender: model.gender,
      role: model.role,
      profilePicture: model.profilePicture,
      active: model.active,
      authProvider: model.authProvider,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}