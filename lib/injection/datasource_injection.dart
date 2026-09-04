import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/core/network/api_client.dart';
import 'package:vehicle_rental_system/feature/booking/data/datasource/booking_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/booking/data/datasource/booking_remote_data_source_impl.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/datasource/location_remote_data_source.dart';

final getIt = GetIt.instance;

void registerDataSource() {
  getIt.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // ==========================================
  // Booking
  // ==========================================

  getIt.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(getIt<ApiClient>()),
  );
}
