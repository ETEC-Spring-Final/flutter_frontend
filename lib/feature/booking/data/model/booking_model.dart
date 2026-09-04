import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_model.dart';

/// Data-layer model for a booking returned by the `/bookings` API.
class BookingModel {
  final int id;
  final String bookingNumber;

  final VehicleModel vehicle;

  final DateTime startDate;
  final DateTime endDate;

  final int totalDays;
  final double pricePerDay;
  final double totalPrice;

  final String pickupLocation;
  final String returnLocation;

  final String status;

  const BookingModel({
    required this.id,
    required this.bookingNumber,
    required this.vehicle,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.pricePerDay,
    required this.totalPrice,
    this.pickupLocation = '',
    this.returnLocation = '',
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as int,
      bookingNumber: json['booking_number'] as String? ?? '',
      vehicle: VehicleModel.fromJson(
        (json['vehicle'] ?? json['vehicle_id'] ?? {}) as Map<String, dynamic>,
      ),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      totalDays: json['total_days'] as int? ?? 1,
      pricePerDay: (json['price_per_day'] as num?)?.toDouble() ?? 0,
      totalPrice: (json['total_price'] as num).toDouble(),
      pickupLocation: json['pickup_location'] as String? ?? '',
      returnLocation: json['return_location'] as String? ?? '',
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_number': bookingNumber,
      'vehicle': vehicle.toJson(),
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'total_days': totalDays,
      'price_per_day': pricePerDay,
      'total_price': totalPrice,
      'pickup_location': pickupLocation,
      'return_location': returnLocation,
      'status': status,
    };
  }
}
