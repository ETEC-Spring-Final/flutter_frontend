import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/repository/vehicle_repository.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository repository;

  VehicleBloc(this.repository) : super(VehicleInitial()) {
    on<GetVehicles>(_onGetVehicles);
    on<GetVehicleById>(_onGetVehicleById);
  }

  Future<void> _onGetVehicles(
    GetVehicles event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoading());

    final result = await repository.getVehicles();

    result.fold(
      (failure) => emit(VehicleError(failure.message)),
      (vehicles) => emit(VehicleLoaded(vehicles)),
    );
  }

  Future<void> _onGetVehicleById(
    GetVehicleById event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoading());

    final result = await repository.getVehicleById(event.id);

    result.fold(
      (failure) => emit(VehicleError(failure.message)),
      (vehicle) => emit(VehicleLoaded([vehicle])),
    );
  }
}
