import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_image_model.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_model.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle_image.dart';

class VehicleMapper {
  const VehicleMapper._();

  // Data Model -> Domain Entity
  static Vehicle toEntity(VehicleModel model) {
    return Vehicle(
      id: model.id,
      brandId: model.brandId,
      brand: model.brand,
      model: model.model,
      yearOfManufacture: model.yearOfManufacture,
      licensePlate: model.licensePlate,
      color: model.color,
      type: model.type,
      transmission: model.transmission,
      fuelType: model.fuelType,
      seats: model.seats,
      doors: model.doors,
      luggages: model.luggages,
      pricePerDay: model.pricePerDay,
      mileAge: model.mileAge,
      description: model.description,
      status: model.status,

      images: model.images
          .map(
            (image) => VehicleImage(
              id: image.id,
              vehicleId: image.vehicleId,
              attachmentId: image.attachmentId,
              fileUrl: image.fileUrl,
              isPrimary: image.isPrimary,
              displayOrder: image.displayOrder,
            ),
          )
          .toList(),

      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  // Domain Entity -> Data Model
  static VehicleModel toModel(Vehicle entity) {
    return VehicleModel(
      id: entity.id,
      brandId: entity.brandId,
      brand: entity.brand,
      model: entity.model,
      yearOfManufacture: entity.yearOfManufacture,
      licensePlate: entity.licensePlate,
      color: entity.color,
      type: entity.type,
      transmission: entity.transmission,
      fuelType: entity.fuelType,
      seats: entity.seats,
      doors: entity.doors,
      luggages: entity.luggages,
      pricePerDay: entity.pricePerDay,
      mileAge: entity.mileAge,
      description: entity.description,
      status: entity.status,

      images: entity.images
          .map(
            (image) => VehicleImageModel(
              id: image.id,
              vehicleId: image.vehicleId,
              attachmentId: image.attachmentId,
              fileUrl: image.fileUrl,
              isPrimary: image.isPrimary,
              displayOrder: image.displayOrder,
            ),
          )
          .toList(),

      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
