import 'package:fpdart/fpdart.dart';

import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/profile/data/datasource/user_profile_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/profile/data/mapper/user_profile_mapper.dart';
import 'package:vehicle_rental_system/feature/profile/domain/entity/user_profile.dart';
import 'package:vehicle_rental_system/feature/profile/domain/repository/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remote;

  UserProfileRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, UserProfile>> getMyProfile() async {
    try {
      final model = await remote.getMyProfile();

      return Right(UserProfileMapper.toEntity(model));
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateMyProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? profilePicture,
  }) async {
    try {
      final model = await remote.updateMyProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        profilePicture: profilePicture,
      );

      return Right(UserProfileMapper.toEntity(model));
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(String filePath) async {
    try {
      final url = await remote.uploadImage(filePath);

      if (url.isEmpty) {
        return const Left(ServiceFailure('Image upload failed.'));
      }

      return Right(url);
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }
}