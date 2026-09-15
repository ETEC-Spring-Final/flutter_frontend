import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void registerServices() {
  // ==========================================
  // API Service
  // ==========================================

  // sl.registerLazySingleton<ApiService>(
  //   () => ApiService(),
  // );

  // ==========================================
  // Storage Service
  // ==========================================

  // sl.registerLazySingleton<StorageService>(
  //   () => StorageService(),
  // );

  // ==========================================
  // Auth Service
  // ==========================================

  // sl.registerLazySingleton<AuthService>(
  //   () => AuthService(
  //     sl(),
  //   ),
  // );
}
