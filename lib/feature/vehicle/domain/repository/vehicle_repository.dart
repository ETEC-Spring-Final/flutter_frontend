import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/booked_date.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/brand.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/paged_result.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle_image.dart';

abstract class VehicleRepository {
  Future<Either<Failure, List<Vehicle>>> getVehicles();
  Future<Either<Failure, List<Brand>>> getBrands();

  /// One page of vehicles, optionally narrowed to a single [brand].
  ///
  /// The Spring Boot endpoints do not page yet, so this is served from a
  /// snapshot of the full list that is downloaded once and then sliced.
  /// [forceRefresh] throws that snapshot away and downloads it again, which is
  /// what a pull to refresh needs. When the backend starts paging, both this
  /// method and the snapshot go away.
  Future<Either<Failure, PagedResult<Vehicle>>> getVehiclePage({
    required int page,
    int size,
    String? brand,
    bool forceRefresh,
  });

  /// One page of brands. See [getVehiclePage] for how the paging is served.
  Future<Either<Failure, PagedResult<Brand>>> getBrandPage({
    required int page,
    int size,
    bool forceRefresh,
  });

  Future<Either<Failure, Vehicle>> getVehicleById(int id);
  Future<Either<Failure, List<BookedDate>>> getVehicleBookedDates(int id);
  Future<Either<Failure, Vehicle>> createVehicle(Vehicle vehicle);
  Future<Either<Failure, Vehicle>> updateVehicle(Vehicle vehicle);
  Future<Either<Failure, Unit>> deleteVehicle(int id);
  Future<Either<Failure, List<VehicleImage>>> uploadVehicleImages(
    int vehicleId,
    List<File> images,
  );
  Future<Either<Failure, Unit>> deleteVehicleImage(int vehicleImageId);
  Future<Either<Failure, Unit>> updateVehicleImage(
    int vehicleImageId, {
    required int vehicleId,
    required int attachmentId,
    required bool isPrimary,
    required int displayOrder,
  });
}
