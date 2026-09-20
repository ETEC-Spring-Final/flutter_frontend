import 'package:fpdart/fpdart.dart';

import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/profile/domain/entity/user_profile.dart';

/// Contract for loading and updating the current user's profile.
abstract class UserProfileRepository {
  /// Fetches the signed-in user's profile (`GET /api/user-profiles/me`).
  Future<Either<Failure, UserProfile>> getMyProfile();

  /// Updates the signed-in user's profile (`PUT /api/user-profiles/me`).
  Future<Either<Failure, UserProfile>> updateMyProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? profilePicture,
  });

  /// Uploads [filePath] to the image host and returns its public URL.
  Future<Either<Failure, String>> uploadProfileImage(String filePath);
}