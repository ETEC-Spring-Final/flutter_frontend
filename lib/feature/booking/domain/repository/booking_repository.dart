import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/booking.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/new_booking_request.dart';

/// Contract for the booking feature.
///
/// The [BookingRepositoryImpl] keeps an offline mock catalog today and can be
/// swapped for a remote implementation against the Spring Boot `/bookings`
/// endpoints without touching the UI or the BLoC.
abstract class BookingRepository {
  /// Loads all bookings for the current user.
  Future<Either<Failure, List<Booking>>> getBookings();

  /// Creates a new booking from [request].
  Future<Either<Failure, Booking>> createBooking(NewBookingRequest request);

  /// Optionally cancels a booking by id.
  Future<Either<Failure, Booking>> cancelBooking(int id);
}
