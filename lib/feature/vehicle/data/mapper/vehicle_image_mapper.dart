import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_image_model.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle_image.dart';

class VehicleImageMapper {
  const VehicleImageMapper._();

  static VehicleImage toEntity(VehicleImageModel model) => VehicleImage(
        id: model.id,
        vehicleId: model.vehicleId,
        attachmentId: model.attachmentId,
        fileUrl: model.fileUrl,
        isPrimary: model.isPrimary,
        displayOrder: model.displayOrder,
      );

  static VehicleImageModel toModel(VehicleImage entity) => VehicleImageModel(
        id: entity.id,
        vehicleId: entity.vehicleId,
        attachmentId: entity.attachmentId,
        fileUrl: entity.fileUrl,
        isPrimary: entity.isPrimary,
        displayOrder: entity.displayOrder,
      );
}