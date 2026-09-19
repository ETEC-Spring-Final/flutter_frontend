import 'package:vehicle_rental_system/feature/booking/data/model/additional_service_model.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/additional_service.dart';

/// Converts between the [AdditionalService] domain entity and
/// [AdditionalServiceModel] data model.
class AdditionalServiceMapper {
  const AdditionalServiceMapper._();

  static AdditionalService toEntity(AdditionalServiceModel model) {
    return model.toEntity();
  }
}