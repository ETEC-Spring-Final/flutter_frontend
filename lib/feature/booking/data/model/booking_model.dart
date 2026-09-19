import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_model.dart';

/// Data-layer model for a reservation returned by the Spring Boot
/// `/api/reservations` endpoint.
///
/// The reservation response only carries ids (vehicle, locations), so the
/// remote data source enriches it with the resolved [vehicle] and the
/// human-readable location names before handing it to the mapper.
class BookingModel {
  final int id;

  final int vehicleId;
  final int pickUpLocationId;
  final int returnLocationId;

  final DateTime startDate;
  final DateTime endDate;

  final double totalPrice;
  final double depositAmount;
  final double additionalCharges;

  final String status;
  final String? notes;

  final VehicleModel? vehicle;
  final String pickupLocation;
  final String returnLocation;

  const BookingModel({
    required this.id,
    required this.vehicleId,
    required this.pickUpLocationId,
    required this.returnLocationId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    this.depositAmount = 0,
    this.additionalCharges = 0,
    this.notes,
    this.vehicle,
    this.pickupLocation = '',
    this.returnLocation = '',
  });

  /// Builds a model from a `ReservationResponseDTO`.
  ///
  /// [locationNames] maps a location id to its display name and [vehicle] is
  /// the resolved vehicle (may be null when the lookup fails).
  factory BookingModel.fromReservation(
    Map<String, dynamic> json, {
    Map<int, String> locationNames = const {},
    VehicleModel? vehicle,
  }) {
    final pickUpLocationId = (json['pickUpLocationId'] as num?)?.toInt() ?? 0;
    final returnLocationId = (json['returnLocationId'] as num?)?.toInt() ?? 0;

    return BookingModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      vehicleId: (json['vehicleId'] as num?)?.toInt() ?? 0,
      pickUpLocationId: pickUpLocationId,
      returnLocationId: returnLocationId,
      startDate:
          DateTime.tryParse(json['pickUpDateTime']?.toString() ?? '') ??
          DateTime.now(),
      endDate:
          DateTime.tryParse(json['returnDateTime']?.toString() ?? '') ??
          DateTime.now(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
      depositAmount: (json['depositAmount'] as num?)?.toDouble() ?? 0,
      additionalCharges: (json['additionalCharges'] as num?)?.toDouble() ?? 0,
      status: (json['status']?.toString() ?? 'pending').toLowerCase(),
      notes: json['notes'] as String?,
      vehicle: vehicle,
      pickupLocation: locationNames[pickUpLocationId] ?? '',
      returnLocation: locationNames[returnLocationId] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'pickUpLocationId': pickUpLocationId,
      'returnLocationId': returnLocationId,
      'pickUpDateTime': startDate.toIso8601String(),
      'returnDateTime': endDate.toIso8601String(),
      'totalPrice': totalPrice,
      'depositAmount': depositAmount,
      'additionalCharges': additionalCharges,
      'status': status,
      if (notes != null) 'notes': notes,
      if (vehicle != null) 'vehicle': vehicle!.toJson(),
      'pickupLocation': pickupLocation,
      'returnLocation': returnLocation,
    };
  }
}
