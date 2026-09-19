import 'package:vehicle_rental_system/feature/booking/domain/entity/additional_service.dart';

/// Data-layer model for a service catalogue entry returned by the Spring Boot
/// `/api/services` endpoint (`{id, name, description, price, isActive}`).
class AdditionalServiceModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final bool isActive;

  const AdditionalServiceModel({
    required this.id,
    required this.name,
    this.description = '',
    this.price = 0,
    this.isActive = true,
  });

  factory AdditionalServiceModel.fromJson(Map<String, dynamic> json) {
    return AdditionalServiceModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  AdditionalService toEntity() {
    return AdditionalService(
      id: id,
      name: name,
      description: description,
      price: price,
      isActive: isActive,
    );
  }
}