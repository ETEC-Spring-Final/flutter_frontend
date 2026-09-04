import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/booking.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/new_booking_request.dart';
import 'package:vehicle_rental_system/feature/booking/domain/repository/booking_repository.dart';

class CreateBooking {
  final BookingRepository repository;

  const CreateBooking(this.repository);

  Future<Either<Failure, Booking>> call(NewBookingRequest request) {
    return repository.createBooking(request);
  }
}
