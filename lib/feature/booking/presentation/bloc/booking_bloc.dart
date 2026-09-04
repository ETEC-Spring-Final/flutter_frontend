import 'package:bloc/bloc.dart';

import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/booking.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/new_booking_request.dart';
import 'package:vehicle_rental_system/feature/booking/domain/repository/booking_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

/// Manages the list of bookings for the current user.
///
/// Loads bookings from the repository and exposes loading/error/loaded states.
/// The repository resolves to the remote `/bookings` API with a mock fallback,
/// so this BLoC does not need to change when the backend goes live.
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _repository;

  BookingBloc(this._repository) : super(const BookingInitial()) {
    on<LoadBookingsEvent>(_onLoad);
    on<CreateBookingEvent>(_onCreate);

    add(const LoadBookingsEvent());
  }

  Future<void> _onLoad(
    LoadBookingsEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());

    final result = await _repository.getBookings();

    result.fold(
      (failure) => emit(BookingError(failure)),
      (bookings) => emit(BookingLoaded(bookings)),
    );
  }

  Future<void> _onCreate(
    CreateBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    final result = await _repository.createBooking(event.request);

    result.fold(
      (failure) => emit(BookingError(failure)),
      (booking) => emit(BookingCreated(booking)),
    );
  }
}
