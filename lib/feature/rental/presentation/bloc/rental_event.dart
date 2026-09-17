import 'package:equatable/equatable.dart';

abstract class RentalEvent extends Equatable {
  const RentalEvent();

  @override
  List<Object?> get props => [];
}

class GetUserRentalsEvent extends RentalEvent {
  const GetUserRentalsEvent();

  @override
  List<Object?> get props => [];
}