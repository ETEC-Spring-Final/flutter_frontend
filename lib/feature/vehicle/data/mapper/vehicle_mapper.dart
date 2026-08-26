import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_model.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';

/*

final VehicleModel model = VehicleModel.fromJson(response.data);

final Vehicle vehicle = VehicleMapper.toEntity(model);

final VehicleModel model = VehicleMapper.toModel(vehicle);

final json = model.toJson();


*/

class VehicleMapper {
  const VehicleMapper._();

  // Convert Data Model -> Domain Entity
  static Vehicle toEntity(VehicleModel model) {
    return Vehicle(
      id: model.id,
      images: List.unmodifiable(model.images),
      brand: model.brand,
      model: model.model,
      year: model.year,
      licensePlate: model.licensePlate,
      color: model.color,
      type: model.type,
      pricePerDay: model.pricePerDay,
      description: model.description,
      rating: model.rating,
      feature: List.unmodifiable(model.feature),
      latitude: model.latitude,
      longitude: model.longitude,
      transmission: model.transmission,
      fuelType: model.fuelType,
      seats: model.seats,
      doors: model.doors,
      luggage: model.luggage,
      kilometer: model.kilometer,
      isFavorite: model.isFavorite,
      status: model.status,
    );
  }

  // Convert Domain Entity -> Data Model
  static VehicleModel toModel(Vehicle entity) {
    return VehicleModel(
      id: entity.id,
      images: List.from(entity.images),
      brand: entity.brand,
      model: entity.model,
      year: entity.year,
      licensePlate: entity.licensePlate,
      color: entity.color,
      type: entity.type,
      pricePerDay: entity.pricePerDay,
      description: entity.description,
      rating: entity.rating,
      feature: List.from(entity.feature),
      latitude: entity.latitude,
      longitude: entity.longitude,
      transmission: entity.transmission,
      fuelType: entity.fuelType,
      seats: entity.seats,
      doors: entity.doors,
      luggage: entity.luggage,
      kilometer: entity.kilometer,
      isFavorite: entity.isFavorite,
      status: entity.status,
      createAt: null,
      updateAt: null,
    );
  }
}
