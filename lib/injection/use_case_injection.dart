import 'package:get_it/get_it.dart';

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

  // getIt.registerFactory<CreateBookingUseCase>(
  //   () => CreateBookingUseCase(
  //     getIt(),
  //   ),
  // );
}
