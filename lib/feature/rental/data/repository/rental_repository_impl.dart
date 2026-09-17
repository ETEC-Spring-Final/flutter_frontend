import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/rental/data/datasource/rental_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/rental/data/mapper/rental_mapper.dart';
import 'package:vehicle_rental_system/feature/rental/domain/entity/rental.dart';
import 'package:vehicle_rental_system/feature/rental/domain/repository/rental_repository.dart';

class RentalRepositoryImpl implements RentalRepository {
  final RentalRemoteDataSource remote;

  RentalRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Rental>>> getMyRentals() async {
    try {
      final models = await remote.getMyRentals();

      return Right(models.map(RentalMapper.toEntity).toList());
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }
}