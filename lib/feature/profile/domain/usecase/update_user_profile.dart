import 'package:fpdart/fpdart.dart';

import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/profile/domain/entity/user_profile.dart';
import 'package:vehicle_rental_system/feature/profile/domain/repository/user_profile_repository.dart';

class UpdateUserProfile {
  final UserProfileRepository repository;

  const UpdateUserProfile(this.repository);

  Future<Either<Failure, UserProfile>> call({
    required String firstName,
    required String lastName,
    required String phone,
    String? profilePicture,
  }) {
    return repository.updateMyProfile(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      profilePicture: profilePicture,
    );
  }
}