class VehicleModel {
  final int id;
  final List<String> images;
  final String brand;
  final String model;
  final int year;
  final String licensePlate;
  final String color;

  final String type;
  final double pricePerDay;
  final String description;
  final double rating;

  final List<String> feature;

  final double latitude;
  final double longitude;

  final String transmission;
  final String fuelType;
  final int seats;
  final int doors;
  final int luggage;
  final double kilometer;

  final bool isFavorite;
  final String status;

  final DateTime? createAt;
  final DateTime? updateAt;

  const VehicleModel({
    required this.id,
    required this.images,
    required this.brand,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.color,
    required this.type,
    required this.pricePerDay,
    required this.description,
    required this.rating,
    required this.feature,
    required this.latitude,
    required this.longitude,
    required this.transmission,
    required this.fuelType,
    required this.seats,
    required this.doors,
    required this.luggage,
    required this.kilometer,
    required this.isFavorite,
    required this.status,
    required this.createAt,
    required this.updateAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as int,

      images: List<String>.from(json['images'] ?? []),

      brand: json['brand'] as String,
      model: json['model'] as String,

      year: json['year'] as int,
      licensePlate: json['license_plate'] as String,
      color: json['color'] as String,

      type: json['type'] as String,

      pricePerDay: (json['price_per_day'] as num).toDouble(),

      description: json['description'] as String,

      rating: (json['rating'] as num).toDouble(),

      feature: List<String>.from(json['feature'] ?? []),

      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),

      transmission: json['transmission'] as String,
      fuelType: json['fuel_type'] as String,

      seats: json['seats'] as int,
      doors: json['doors'] as int,
      luggage: json['luggage'] as int,

      kilometer: (json['kilometer'] as num).toDouble(),

      isFavorite: json['is_favorite'] ?? false,

      status: json['status'] as String,
      createAt: json['createAt'],
      updateAt: json['updateAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'images': images,
      'brand': brand,
      'model': model,
      'year': year,
      'license_plate': licensePlate,
      'color': color,
      'type': type,
      'price_per_day': pricePerDay,
      'description': description,
      'rating': rating,
      'feature': feature,
      'latitude': latitude,
      'longitude': longitude,
      'transmission': transmission,
      'fuel_type': fuelType,
      'seats': seats,
      'doors': doors,
      'luggage': luggage,
      'kilometer': kilometer,
      'is_favorite': isFavorite,
      'status': status,
      'createAt': createAt,
      'updateAt': updateAt,
    };
  }
}
