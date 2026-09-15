import 'vehicle_image_model.dart';

class VehicleModel {
  final int id;
  final String brand;
  final String model;
  final int yearOfManufacture;
  final String licensePlate;
  final String color;
  final String type;
  final String transmission;
  final String fuelType;
  final int seats;
  final int doors;
  final int luggages;
  final double pricePerDay;
  final int mileAge;
  final String description;
  final String status;
  final List<VehicleImageModel> images;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const VehicleModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.yearOfManufacture,
    required this.licensePlate,
    required this.color,
    required this.type,
    required this.transmission,
    required this.fuelType,
    required this.seats,
    required this.doors,
    required this.luggages,
    required this.pricePerDay,
    required this.mileAge,
    required this.description,
    required this.status,
    required this.images,
    this.createdAt,
    this.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] ?? 0,
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      yearOfManufacture: json['yearOfManufacture'] ?? 0,
      licensePlate: json['licensePlate'] ?? '',
      color: json['color'] ?? '',
      type: json['type'] ?? '',
      transmission: json['transmission'] ?? '',
      fuelType: json['fuelType'] ?? '',
      seats: json['seats'] ?? 0,
      doors: json['doors'] ?? 0,
      luggages: json['luggages'] ?? 0,
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble() ?? 0.0,
      mileAge: json['mileAge'] ?? 0,
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map(
                (image) =>
                    VehicleImageModel.fromJson(image as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'yearOfManufacture': yearOfManufacture,
      'licensePlate': licensePlate,
      'color': color,
      'type': type,
      'transmission': transmission,
      'fuelType': fuelType,
      'seats': seats,
      'doors': doors,
      'luggages': luggages,
      'pricePerDay': pricePerDay,
      'mileAge': mileAge,
      'description': description,
      'status': status,
      'images': images.map((image) => image.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
