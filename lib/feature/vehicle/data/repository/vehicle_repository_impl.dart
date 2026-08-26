import 'package:fpdart/src/either.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/datasource/vehicle_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/mapper/vehicle_mapper.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/repository/vehicle_repository.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remote;

  VehicleRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Vehicle>>> getVehicles() async {
    try {
      final models = await remote.getVehicles();

      final vehicles = models.map(VehicleMapper.toEntity).toList();

      return Right(vehicles);
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Vehicle>> getVehicleById(int id) async {
    try {
      final model = await remote.getVehicleById(id);
      final vehicle = VehicleMapper.toEntity(model);

      return right(vehicle);
    } catch (e) {
      return left(ServiceFailure(e.toString()));
    }
  }
}
