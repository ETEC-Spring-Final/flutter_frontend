import 'package:fpdart/fpdart.dart';

import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/profile/domain/entity/user_profile.dart';
import 'package:vehicle_rental_system/feature/profile/domain/repository/user_profile_repository.dart';

class GetUserProfile {
  final UserProfileRepository repository;

  const GetUserProfile(this.repository);

  Future<Either<Failure, UserProfile>> call() {
    return repository.getMyProfile();
  }
}