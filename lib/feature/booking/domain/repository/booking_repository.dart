import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/additional_service.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/booking.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/new_booking_request.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/rental_location.dart';

/// Contract for the booking feature.
///
/// Backed by the Spring Boot `/api/reservations` endpoints.
abstract class BookingRepository {
  /// Loads all bookings for the current user.
  Future<Either<Failure, List<Booking>>> getBookings();

  /// Creates a new booking from [request].
  Future<Either<Failure, Booking>> createBooking(NewBookingRequest request);

  /// Cancels a booking by id.
  Future<Either<Failure, Booking>> cancelBooking(int id);

  /// Loads the pick-up / return locations offered by the backend.
  Future<Either<Failure, List<RentalLocation>>> getLocations();

  /// Loads the per-day rental add-ons offered by the backend.
  Future<Either<Failure, List<AdditionalService>>> getAdditionalServices();
}
