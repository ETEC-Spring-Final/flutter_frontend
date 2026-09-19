part of 'vehicle_bloc.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;
  final List<Brand> brands;

  const VehicleLoaded(this.vehicles, [this.brands = const []]);

  @override
  List<Object?> get props => [vehicles, brands];
}

class VehicleError extends VehicleState {
  final String message;

  const VehicleError(this.message);

  @override
  List<Object?> get props => [message];
}

class VehicleSuccess extends VehicleState {
  final String message;

  const VehicleSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
