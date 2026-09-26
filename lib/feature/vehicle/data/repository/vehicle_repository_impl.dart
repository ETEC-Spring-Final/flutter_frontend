import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/datasource/vehicle_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/mapper/brand_mapper.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/mapper/vehicle_image_mapper.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/mapper/vehicle_mapper.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/booked_date.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/brand.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/paged_result.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle_image.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/repository/vehicle_repository.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remote;

  // The API hands back the full list, so the snapshot is kept in memory and
  // paged locally. TODO: delete both caches, the delay and the forceRefresh
  // flag once /vehicles and /brands return a Spring Data Page.
  List<Vehicle>? _vehicleSnapshot;
  List<Brand>? _brandSnapshot;

  // Simulated round trip so the paging behaves like a real request: the
  // loading states are visible and the append is not instantaneous.
  static const Duration _pageDelay = Duration(milliseconds: 450);

  VehicleRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, PagedResult<Vehicle>>> getVehiclePage({
    required int page,
    int size = 8,
    String? brand,
    bool forceRefresh = false,
  }) async {
    try {
      if (forceRefresh) _vehicleSnapshot = null;

      var snapshot = _vehicleSnapshot;

      if (snapshot == null) {
        final result = await getVehicles();

        if (result.isLeft()) {
          return Left(result.getLeft().toNullable()!);
        }

        snapshot = _vehicleSnapshot = result.getRight().toNullable()!;
      }

      await Future<void>.delayed(_pageDelay);

      return Right(
        PagedResult.fromAll(
          snapshot,
          page: page,
          size: size,
          filter: brand == null || brand.isEmpty
              ? null
              : (vehicle) =>
                    vehicle.brand.toLowerCase() == brand.toLowerCase(),
        ),
      );
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PagedResult<Brand>>> getBrandPage({
    required int page,
    int size = 8,
    bool forceRefresh = false,
  }) async {
    try {
      if (forceRefresh) _brandSnapshot = null;

      var snapshot = _brandSnapshot;

      if (snapshot == null) {
        final result = await getBrands();

        if (result.isLeft()) {
          return Left(result.getLeft().toNullable()!);
        }

        snapshot = _brandSnapshot = result.getRight().toNullable()!;
      }

      await Future<void>.delayed(_pageDelay);

      return Right(PagedResult.fromAll(snapshot, page: page, size: size));
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Brand>>> getBrands() async {
    try {
      final models = await remote.getBrands();

      return Right(models.map(BrandMapper.toEntity).toList());
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }

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

  @override
  Future<Either<Failure, List<BookedDate>>> getVehicleBookedDates(int id) async {
    try {
      final dates = await remote.getVehicleBookedDates(id);

      return right(dates);
    } catch (e) {
      return left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Vehicle>> createVehicle(Vehicle vehicle) async {
    try {
      final model = await remote.createVehicle(VehicleMapper.toModel(vehicle));

      return right(VehicleMapper.toEntity(model));
    } catch (e) {
      return left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Vehicle>> updateVehicle(Vehicle vehicle) async {
    try {
      final model = await remote.updateVehicle(VehicleMapper.toModel(vehicle));

      return right(VehicleMapper.toEntity(model));
    } catch (e) {
      return left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteVehicle(int id) async {
    try {
      await remote.deleteVehicle(id);

      return right(unit);
    } catch (e) {
      return left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VehicleImage>>> uploadVehicleImages(
    int vehicleId,
    List<File> images,
  ) async {
    try {
      final models = await remote.uploadVehicleImages(vehicleId, images);

      return right(models.map(VehicleImageMapper.toEntity).toList());
    } catch (e) {
      return left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteVehicleImage(int vehicleImageId) async {
    try {
      await remote.deleteVehicleImage(vehicleImageId);

      return right(unit);
    } catch (e) {
      return left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateVehicleImage(
    int vehicleImageId, {
    required int vehicleId,
    required int attachmentId,
    required bool isPrimary,
    required int displayOrder,
  }) async {
    try {
      await remote.updateVehicleImage(
        vehicleImageId,
        vehicleId: vehicleId,
        attachmentId: attachmentId,
        isPrimary: isPrimary,
        displayOrder: displayOrder,
      );

      return right(unit);
    } catch (e) {
      return left(ServiceFailure(e.toString()));
    }
  }
}
