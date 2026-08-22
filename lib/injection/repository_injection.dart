import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/datasource/location_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/repository/location_repository_impl.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/repository/location_repository.dart';

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

  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      remoteDataSource: getIt<LocationRemoteDataSource>(),
    ),
  );

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
