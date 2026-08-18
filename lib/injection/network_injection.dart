import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:vehicle_rental_system/core/network/api_client.dart';
import 'package:vehicle_rental_system/core/network/interceptors/logging_interceptor.dart';
import 'package:vehicle_rental_system/core/network/network_info.dart';
import 'package:vehicle_rental_system/core/network/interceptors/auth_interceptor.dart';
import 'package:vehicle_rental_system/core/storage/secure_storage_service.dart';

final GetIt getIt = GetIt.instance;

void registerNetwork() {
  // ==========================================
  // Connectivity
  // ==========================================

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // ==========================================
  // Network Info
  // ==========================================

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );

  // ==========================================
  // Secure Storage
  // ==========================================

  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(getIt<FlutterSecureStorage>()),
  );

  // ==========================================
  // Auth Interceptor
  // ==========================================

  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(getIt<SecureStorageService>()),
  );

  // ==========================================
  // Logging Interceptor
  // ==========================================

  getIt.registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor());

  // ==========================================
  // Dio
  // ==========================================

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8000/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(getIt<AuthInterceptor>() as Interceptor);

    dio.interceptors.add(getIt<LoggingInterceptor>() as Interceptor);

    return dio;
  });

  // ==========================================
  // API Client
  // ==========================================

  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));
}
