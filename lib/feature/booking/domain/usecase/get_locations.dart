import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/booking/domain/repository/booking_repository.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/rental_location.dart';

/// Loads the pick-up / return locations offered by the backend.
class GetLocations {
  final BookingRepository repository;

  GetLocations(this.repository);

  Future<Either<Failure, List<RentalLocation>>> call() {
    return repository.getLocations();
  }
}
