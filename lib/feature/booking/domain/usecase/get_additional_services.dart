import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/additional_service.dart';
import 'package:vehicle_rental_system/feature/booking/domain/repository/booking_repository.dart';

/// Loads the per-day rental add-ons offered by the backend.
class GetAdditionalServices {
  final BookingRepository repository;

  GetAdditionalServices(this.repository);

  Future<Either<Failure, List<AdditionalService>>> call() {
    return repository.getAdditionalServices();
  }
}