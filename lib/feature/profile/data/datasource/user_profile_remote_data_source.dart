import 'package:vehicle_rental_system/feature/profile/data/model/user_profile_model.dart';

/// Contract for the current user's profile remote data source.
abstract class UserProfileRemoteDataSource {
  /// Fetches the signed-in user's profile.
  Future<UserProfileModel> getMyProfile();

  /// Updates the signed-in user's profile and returns the refreshed profile.
  Future<UserProfileModel> updateMyProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? profilePicture,
  });

  /// Uploads the image at [filePath] and returns its public URL.
  Future<String> uploadImage(String filePath);
}