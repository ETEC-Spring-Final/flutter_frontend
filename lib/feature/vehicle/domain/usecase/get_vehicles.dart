import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/repository/vehicle_repository.dart';

class GetVehicles {
  final VehicleRepository repository;

  const GetVehicles(this.repository);

  Future<Either<Failure, List<Vehicle>>> call() {
    return repository.getVehicles();
  }
}
