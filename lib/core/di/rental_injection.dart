import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/core/network/api_client.dart';
import 'package:vehicle_rental_system/feature/rental/data/datasource/rental_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/rental/data/repository/rental_repository_impl.dart';
import 'package:vehicle_rental_system/feature/rental/domain/repository/rental_repository.dart';
import 'package:vehicle_rental_system/feature/rental/domain/usecase/get_user_rentals.dart';
import 'package:vehicle_rental_system/feature/rental/presentation/bloc/rental_bloc.dart';

final sl = GetIt.instance;

void rentalInjection() {
  // Data Source
  sl.registerLazySingleton<RentalRemoteDataSource>(
    () => RentalRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<RentalRepository>(
    () => RentalRepositoryImpl(sl<RentalRemoteDataSource>()),
  );

  // Use Case
  sl.registerFactory<GetUserRentals>(
    () => GetUserRentals(sl<RentalRepository>()),
  );

  // Bloc
  sl.registerFactory<RentalBloc>(() => RentalBloc(sl<RentalRepository>()));
}