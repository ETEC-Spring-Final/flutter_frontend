import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/core/storage/secure_storage_service.dart';
import 'package:vehicle_rental_system/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:vehicle_rental_system/feature/auth/domain/repository/auth_repository.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

void registerAuth() {
  // dio
  //getit.registerLazySingleton<Dio>(() => DioClient.create());

  // getIt.registerLazySingleton<SecureStorageService>(
  //   () => SecureStorageService(getIt<FlutterSecureStorage>()),
  // );

  // data
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<Dio>()),
  );

  // repo

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<SecureStorageService>(),
    ),
  );
  // use case

  // bloc
  getIt.registerFactory(
    () => AuthBloc(getIt<AuthRepository>(), getIt<FlutterSecureStorage>()),
  );
}
