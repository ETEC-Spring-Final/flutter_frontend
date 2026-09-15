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
