import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/rental/domain/entity/rental.dart';

abstract class RentalRepository {
  Future<Either<Failure, List<Rental>>> getMyRentals();
}