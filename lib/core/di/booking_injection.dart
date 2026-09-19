import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/core/network/api_client.dart';
import 'package:vehicle_rental_system/feature/booking/data/datasource/booking_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/booking/data/datasource/booking_remote_data_source_impl.dart';
import 'package:vehicle_rental_system/feature/booking/data/repository/booking_repository_impl.dart';
import 'package:vehicle_rental_system/feature/booking/domain/repository/booking_repository.dart';
import 'package:vehicle_rental_system/feature/booking/domain/usecase/create_booking.dart';
import 'package:vehicle_rental_system/feature/booking/domain/usecase/get_bookings.dart';
import 'package:vehicle_rental_system/feature/booking/domain/usecase/get_locations.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/datasource/vehicle_remote_data_source.dart';

final sl = GetIt.instance;

void bookingInjection() {
  // ============================================================
  // Remote Data Source
  // ============================================================
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(
      sl<ApiClient>(),
      sl<VehicleRemoteDataSource>(),
    ),
  );

  // ============================================================
  // Repository
  // ============================================================
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remote: sl<BookingRemoteDataSource>()),
  );

  // ============================================================
  // Use Cases
  // ============================================================
  sl.registerFactory<GetBookings>(() => GetBookings(sl<BookingRepository>()));

  sl.registerFactory<CreateBooking>(
    () => CreateBooking(sl<BookingRepository>()),
  );

  sl.registerFactory<GetLocations>(() => GetLocations(sl<BookingRepository>()));
}
