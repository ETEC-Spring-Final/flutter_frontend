import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/booking.dart';
import 'package:vehicle_rental_system/feature/booking/domain/repository/booking_repository.dart';

class GetBookings {
  final BookingRepository repository;

  const GetBookings(this.repository);

  Future<Either<Failure, List<Booking>>> call() {
    return repository.getBookings();
  }
}
