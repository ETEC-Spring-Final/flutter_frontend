import 'package:vehicle_rental_system/feature/vehicle/data/model/brand_model.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/brand.dart';

class BrandMapper {
  const BrandMapper._();

  static Brand toEntity(BrandModel model) =>
      Brand(id: model.id, name: model.name);

  static BrandModel toModel(Brand entity) =>
      BrandModel(id: entity.id, name: entity.name);
}