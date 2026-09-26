import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/feature/home/presentation/bloc/home_bloc.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/repository/vehicle_repository.dart';

final sl = GetIt.instance;

void homeInjection() {
  // The vehicle repository is registered by vehicleInjection(), which must run
  // first. Only the bloc is new here.
  sl.registerFactory<HomeBloc>(() => HomeBloc(sl<VehicleRepository>()));
}
