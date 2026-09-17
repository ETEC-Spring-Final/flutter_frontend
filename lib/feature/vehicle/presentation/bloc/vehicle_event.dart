part of 'vehicle_bloc.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

class GetVehicles extends VehicleEvent {
  const GetVehicles();
}

class GetVehicleById extends VehicleEvent {
  final int id;

  const GetVehicleById(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateVehicleEvent extends VehicleEvent {
  final Vehicle vehicle;
  final List<File>? images;

  const CreateVehicleEvent(this.vehicle, [this.images]);

  @override
  List<Object?> get props => [vehicle, images];
}

class UpdateVehicleEvent extends VehicleEvent {
  final Vehicle vehicle;
  final List<File>? images;

  const UpdateVehicleEvent(this.vehicle, [this.images]);

  @override
  List<Object?> get props => [vehicle, images];
}

class DeleteVehicleEvent extends VehicleEvent {
  final int id;

  const DeleteVehicleEvent(this.id);

  @override
  List<Object?> get props => [id];
}
