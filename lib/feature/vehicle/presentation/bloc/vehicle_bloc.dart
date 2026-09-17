import 'dart:io';

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
    on<CreateVehicleEvent>(_onCreateVehicle);
    on<UpdateVehicleEvent>(_onUpdateVehicle);
    on<DeleteVehicleEvent>(_onDeleteVehicle);
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

  Future<void> _onCreateVehicle(
    CreateVehicleEvent event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoading());

    final result = await repository.createVehicle(event.vehicle);

    if (result.isLeft()) {
      emit(VehicleError(result.getLeft().toNullable()!.message));
      return;
    }

    final created = result.getRight().toNullable()!;
    final images = event.images;

    if (images != null && images.isNotEmpty) {
      final upload = await repository.uploadVehicleImages(created.id, images);

      if (upload.isLeft()) {
        emit(VehicleError(upload.getLeft().toNullable()!.message));
        return;
      }
    }

    emit(const VehicleSuccess('Vehicle created successfully.'));
  }

  Future<void> _onUpdateVehicle(
    UpdateVehicleEvent event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoading());

    final result = await repository.updateVehicle(event.vehicle);

    if (result.isLeft()) {
      emit(VehicleError(result.getLeft().toNullable()!.message));
      return;
    }

    final updated = result.getRight().toNullable()!;
    final images = event.images;

    if (images != null && images.isNotEmpty) {
      final upload = await repository.uploadVehicleImages(updated.id, images);

      if (upload.isLeft()) {
        emit(VehicleError(upload.getLeft().toNullable()!.message));
        return;
      }
    }

    emit(const VehicleSuccess('Vehicle updated successfully.'));
  }

  Future<void> _onDeleteVehicle(
    DeleteVehicleEvent event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoading());

    final result = await repository.deleteVehicle(event.id);

    result.fold(
      (failure) => emit(VehicleError(failure.message)),
      (_) => emit(
        const VehicleSuccess('Vehicle deleted successfully.'),
      ),
    );
  }
}
