import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/rental/domain/entity/rental.dart';
import 'package:vehicle_rental_system/feature/rental/domain/repository/rental_repository.dart';

class GetUserRentals {
  final RentalRepository repository;

  const GetUserRentals(this.repository);

  Future<Either<Failure, List<Rental>>> call() {
    return repository.getMyRentals();
  }
}