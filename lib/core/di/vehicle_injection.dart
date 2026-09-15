import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/datasource/vehicle_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/datasource/vehicle_remote_data_source_fake.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/datasource/vehicle_remote_data_source_impl.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/repository/vehicle_repository_impl.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/repository/vehicle_repository.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/usecase/get_vehicles_use_case.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/bloc/vehicle_bloc.dart';

final sl = GetIt.instance;

void vehiclInjection() {
  // Data Source
  sl.registerLazySingleton<VehicleRemoteDataSource>(
    () => VehicleRemoteDataSourceFake(),
  );

  // With Spring Boot
  //   sl.registerLazySingleton<VehicleRemoteDataSource>(
  //   () => VehicleRemoteDataSourceImpl(sl<Dio>()),
  // );

  // Repo
  sl.registerLazySingleton<VehicleRepository>(
    () => VehicleRepositoryImpl(sl<VehicleRemoteDataSource>()),
  );

  // Bloc
  sl.registerFactory<VehicleBloc>(() => VehicleBloc(sl<VehicleRepository>()));
  //sl.registerFactory<VehicleBloc>(() => VehicleBloc(sl<GetVehiclesUseCase>()));
  // sl.registerFactory<VehicleBloc>(() => VehicleBloc(sl<VehicleRepository>()));
}
