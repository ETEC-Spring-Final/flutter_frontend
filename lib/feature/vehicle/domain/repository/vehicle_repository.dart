import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';

abstract class VehicleRepository {
  Future<Either<Failure, List<Vehicle>>> getVehicles();
  Future<Either<Failure, Vehicle>> getVehicleById(int id);
  Future<Either<Failure, Vehicle>> createVehicle(Vehicle vehicle);
  Future<Either<Failure, Vehicle>> updateVehicle(Vehicle vehicle);
  Future<Either<Failure, Unit>> deleteVehicle(int id);
  Future<Either<Failure, Unit>> uploadVehicleImages(
    int vehicleId,
    List<File> images,
  );
}
