part of 'booking_bloc.dart';

/// Base state for the [BookingBloc].
sealed class BookingState {
  const BookingState();
}

/// Initial state before any loading happens.
final class BookingInitial extends BookingState {
  const BookingInitial();
}

/// While bookings are being fetched.
final class BookingLoading extends BookingState {
  const BookingLoading();
}

/// Bookings loaded successfully.
final class BookingLoaded extends BookingState {
  final List<Booking> bookings;

  const BookingLoaded(this.bookings);
}

/// A booking was created successfully.
final class BookingCreated extends BookingState {
  final Booking booking;

  const BookingCreated(this.booking);
}

/// A request failed.
final class BookingError extends BookingState {
  final Failure failure;

  const BookingError(this.failure);
}
