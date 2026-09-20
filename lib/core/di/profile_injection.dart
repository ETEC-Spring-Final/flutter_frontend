import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/core/network/api_client.dart';
import 'package:vehicle_rental_system/feature/profile/data/datasource/user_profile_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/profile/data/datasource/user_profile_remote_data_source_impl.dart';
import 'package:vehicle_rental_system/feature/profile/data/repository/user_profile_repository_impl.dart';
import 'package:vehicle_rental_system/feature/profile/domain/repository/user_profile_repository.dart';
import 'package:vehicle_rental_system/feature/profile/domain/usecase/get_user_profile.dart';
import 'package:vehicle_rental_system/feature/profile/domain/usecase/update_user_profile.dart';

final sl = GetIt.instance;

void profileInjection() {
  // ============================================================
  // Data
  // ============================================================

  sl.registerLazySingleton<UserProfileRemoteDataSource>(
    () => UserProfileRemoteDataSourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(remote: sl<UserProfileRemoteDataSource>()),
  );

  // ============================================================
  // Use Cases
  // ============================================================

  sl.registerFactory<GetUserProfile>(
    () => GetUserProfile(sl<UserProfileRepository>()),
  );

  sl.registerFactory<UpdateUserProfile>(
    () => UpdateUserProfile(sl<UserProfileRepository>()),
  );
}