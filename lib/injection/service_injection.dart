import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void registerServices() {
  // ==========================================
  // API Service
  // ==========================================

  // getIt.registerLazySingleton<ApiService>(
  //   () => ApiService(),
  // );

  // ==========================================
  // Storage Service
  // ==========================================

  // getIt.registerLazySingleton<StorageService>(
  //   () => StorageService(),
  // );

  // ==========================================
  // Auth Service
  // ==========================================

  // getIt.registerLazySingleton<AuthService>(
  //   () => AuthService(
  //     getIt(),
  //   ),
  // );
}
