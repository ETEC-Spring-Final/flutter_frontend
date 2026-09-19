/// A service catalogue entry offered by the rental service.
///
/// Backed by the Spring Boot `GET /api/services` endpoint
/// (`{id, name, description, price, isActive}`). The booking flow sends the
/// selected **ids** as `serviceIds` when creating a reservation.
class AdditionalService {
  final int id;
  final String name;
  final String description;
  final double price;
  final bool isActive;

  const AdditionalService({
    required this.id,
    required this.name,
    this.description = '',
    this.price = 0,
    this.isActive = true,
  });

  factory AdditionalService.fromJson(Map<String, dynamic> json) {
    return AdditionalService(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AdditionalService && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}