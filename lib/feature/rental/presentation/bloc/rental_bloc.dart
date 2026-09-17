import 'package:bloc/bloc.dart';
import 'package:vehicle_rental_system/feature/rental/domain/repository/rental_repository.dart';

import 'rental_event.dart';
import 'rental_state.dart';

/// Loads the logged-in user's rentals from the Spring Boot `/rentals/my-rentals`
/// endpoint.
class RentalBloc extends Bloc<RentalEvent, RentalState> {
  final RentalRepository _repository;

  RentalBloc(this._repository) : super(RentalInitial()) {
    on<GetUserRentalsEvent>(_onGetUserRentals);
  }

  Future<void> _onGetUserRentals(
    GetUserRentalsEvent event,
    Emitter<RentalState> emit,
  ) async {
    emit(RentalLoading());

    final result = await _repository.getMyRentals();

    result.fold(
      (failure) => emit(RentalError(failure.message)),
      (rentals) => emit(RentalLoaded(rentals)),
    );
  }
}