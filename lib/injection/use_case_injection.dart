import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/feature/booking/domain/repository/booking_repository.dart';
import 'package:vehicle_rental_system/feature/booking/domain/usecase/create_booking.dart';
import 'package:vehicle_rental_system/feature/booking/domain/usecase/get_bookings.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/repository/location_repository.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/usecase/get_location_name.dart';

final getIt = GetIt.instance;

void registerUseCases() {
  // ==========================================
  // Authentication
  // ==========================================

  // getIt.registerFactory<LoginUseCase>(
  //   () => LoginUseCase(
  //     getIt(),
  //   ),
  // );

  // ==========================================
  // Vehicle
  // ==========================================

  getIt.registerLazySingleton<GetLocationName>(
    () => GetLocationName(repository: getIt<LocationRepository>()),
  );

  // getIt.registerFactory<GetVehiclesUseCase>(
  //   () => GetVehiclesUseCase(
  //     getIt(),
  //   ),
  // );

  // getIt.registerFactory<GetVehicleByIdUseCase>(
  //   () => GetVehicleByIdUseCase(
  //     getIt(),
  //   ),
  // );

  // ==========================================
  // Booking
  // ==========================================

  getIt.registerFactory<GetBookings>(
    () => GetBookings(getIt<BookingRepository>()),
  );

  getIt.registerFactory<CreateBooking>(
    () => CreateBooking(getIt<BookingRepository>()),
  );
}
