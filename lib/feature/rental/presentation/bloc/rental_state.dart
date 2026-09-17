import 'package:equatable/equatable.dart';
import 'package:vehicle_rental_system/feature/rental/domain/entity/rental.dart';

abstract class RentalState extends Equatable {
  const RentalState();

  @override
  List<Object?> get props => [];
}

class RentalInitial extends RentalState {}

class RentalLoading extends RentalState {}

class RentalLoaded extends RentalState {
  final List<Rental> rentals;

  const RentalLoaded(this.rentals);

  @override
  List<Object?> get props => [rentals];
}

class RentalError extends RentalState {
  final String message;

  const RentalError(this.message);

  @override
  List<Object?> get props => [message];
}