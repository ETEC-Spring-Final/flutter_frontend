import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/repository/vehicle_repository.dart';

class GetVehicleById {
  final VehicleRepository repository;

  const GetVehicleById(this.repository);

  Future<Either<Failure, Vehicle>> call(int id) {
    return repository.getVehicleById(id);
  }
}
