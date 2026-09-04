part of 'booking_bloc.dart';

/// Base event for the [BookingBloc].
sealed class BookingEvent {
  const BookingEvent();
}

/// Load all bookings.
final class LoadBookingsEvent extends BookingEvent {
  final bool refresh;

  const LoadBookingsEvent({this.refresh = false});
}

/// Create a new booking.
final class CreateBookingEvent extends BookingEvent {
  final NewBookingRequest request;

  const CreateBookingEvent(this.request);
}
