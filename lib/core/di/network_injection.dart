import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/core/constants/api_constants.dart';

import 'package:vehicle_rental_system/core/network/api_client.dart';
import 'package:vehicle_rental_system/core/network/interceptors/logging_interceptor.dart';
import 'package:vehicle_rental_system/core/network/network_info.dart';
import 'package:vehicle_rental_system/core/network/interceptors/auth_interceptor.dart';
import 'package:vehicle_rental_system/core/storage/secure_storage_service.dart';

final sl = GetIt.instance;
void registerNetwork() {
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(sl<FlutterSecureStorage>()),
  );

  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(sl<SecureStorageService>()),
  );

  sl.registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor());

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(sl<AuthInterceptor>());

    dio.interceptors.add(sl<LoggingInterceptor>());

    return dio;
  });

  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));
}
