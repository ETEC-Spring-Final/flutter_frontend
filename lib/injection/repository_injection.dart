import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void registerRepositories() {
  // ==========================================
  // Authentication
  // ==========================================

  // getIt.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(
  //     getIt(),
  //   ),
  // );

  // ==========================================
  // Vehicle
  // ==========================================

  // getIt.registerLazySingleton<VehicleRepository>(
  //   () => VehicleRepositoryImpl(
  //     getIt(),
  //   ),
  // );

  // ==========================================
  // Customer
  // ==========================================

  // getIt.registerLazySingleton<CustomerRepository>(
  //   () => CustomerRepositoryImpl(
  //     getIt(),
  //   ),
  // );

  // ==========================================
  // Booking
  // ==========================================

  // getIt.registerLazySingleton<BookingRepository>(
  //   () => BookingRepositoryImpl(
  //     getIt(),
  //   ),
  // );
}
