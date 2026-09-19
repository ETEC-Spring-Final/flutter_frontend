/// A physical pick-up / return point offered by the rental service.
///
/// Backed by the Spring Boot `GET /api/locations` endpoint. The backend
/// expects location **ids** when creating a reservation, so the booking flow
/// carries both the id and the display name.
class RentalLocation {
  final int id;
  final String name;
  final String address;
  final String city;
  final String phone;

  const RentalLocation({
    required this.id,
    required this.name,
    this.address = '',
    this.city = '',
    this.phone = '',
  });

  factory RentalLocation.fromJson(Map<String, dynamic> json) {
    return RentalLocation(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  String get displayName {
    if (city.isEmpty || name.toLowerCase().contains(city.toLowerCase())) {
      return name;
    }
    return '$name, $city';
  }

  @override
  bool operator ==(Object other) {
    return other is RentalLocation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
