import 'vehicle_image_model.dart';

class VehicleModel {
  final int id;
  final int brandId;
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
    this.brandId = 0,
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

  /// Minimal placeholder used when a referenced vehicle cannot be resolved
  /// (e.g. a reservation points at a deleted/unreachable vehicle).
  factory VehicleModel.placeholder(int id) {
    return VehicleModel(
      id: id,
      brandId: 0,
      brand: 'Vehicle',
      model: '',
      yearOfManufacture: 0,
      licensePlate: '',
      color: '',
      type: '',
      transmission: '',
      fuelType: '',
      seats: 0,
      doors: 0,
      luggages: 0,
      pricePerDay: 0,
      mileAge: 0,
      description: '',
      status: '',
      images: const [],
    );
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {    return VehicleModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      brandId: (json['brandId'] as num?)?.toInt() ?? 0,
      brand: json['brandName'] ?? json['brand'] ?? '',
      model: json['model'] ?? '',
      yearOfManufacture: (json['yearOfManufacture'] as num?)?.toInt() ?? 0,
      licensePlate: json['licensePlate'] ?? '',
      color: json['color'] ?? '',
      type: json['type']?.toString() ?? '',
      transmission: json['transmission']?.toString() ?? '',
      fuelType: json['fuelType']?.toString() ?? '',
      seats: (json['seats'] as num?)?.toInt() ?? 0,
      doors: (json['doors'] as num?)?.toInt() ?? 0,
      luggages: (json['luggages'] as num?)?.toInt() ?? 0,
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble() ?? 0.0,
      mileAge: (json['mileAge'] as num?)?.toInt() ?? 0,
      description: json['description'] ?? '',
      status: json['status']?.toString() ?? '',
      images: _parseImages(json['images']),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  static List<VehicleImageModel> _parseImages(dynamic raw) {
    if (raw == null) return [];

    if (raw is String) {
      return [
        VehicleImageModel(
          id: 0,
          fileUrl: raw,
          isPrimary: true,
          displayOrder: 0,
        ),
      ];
    }

    if (raw is List) {
      return raw.map((image) {
        if (image is String) {
          return VehicleImageModel(
            id: 0,
            fileUrl: image,
            isPrimary: false,
            displayOrder: 0,
          );
        }

        final map = image is Map<String, dynamic> ? image : <String, dynamic>{};
        final attachment = map['attachment'];

        if (attachment is Map<String, dynamic>) {
          return VehicleImageModel(
            id: map['id'] ?? 0,
            vehicleId: (map['vehicleId'] as num?)?.toInt() ?? 0,
            attachmentId: attachment['id'] ?? 0,
            fileUrl: attachment['fileUrl'] ?? '',
            isPrimary: attachment['isPrimary'] ?? false,
            displayOrder: attachment['displayOrder'] ?? 0,
          );
        }

        return VehicleImageModel.fromJson(map);
      }).toList();
    }

    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brandId': brandId,
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

  // ==========================================
  // Create request body (no id / server-managed fields)
  // ==========================================

  Map<String, dynamic> toCreateRequest() {
    return {
      'brandId': brandId,
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
    };
  }

  // ==========================================
  // Update request body (id included)
  // ==========================================

  Map<String, dynamic> toUpdateRequest() {
    return {'id': id, ...toCreateRequest()};
  }
}
