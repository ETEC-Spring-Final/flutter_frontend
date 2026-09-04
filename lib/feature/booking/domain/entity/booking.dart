import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';

/// A rental booking for a [Vehicle].
///
/// This is the domain entity used by the booking feature. It is API-ready:
/// the data layer maps it to/from the Spring Boot `/bookings` endpoint.
class Booking {
  final int id;
  final String bookingNumber;

  final Vehicle vehicle;

  final DateTime startDate;
  final DateTime endDate;

  final int totalDays;
  final double pricePerDay;
  final double totalPrice;

  final String pickupLocation;
  final String returnLocation;

  final String status;

  const Booking({
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

  Booking copyWith({
    int? id,
    String? bookingNumber,
    Vehicle? vehicle,
    DateTime? startDate,
    DateTime? endDate,
    int? totalDays,
    double? pricePerDay,
    double? totalPrice,
    String? pickupLocation,
    String? returnLocation,
    String? status,
  }) {
    return Booking(
      id: id ?? this.id,
      bookingNumber: bookingNumber ?? this.bookingNumber,
      vehicle: vehicle ?? this.vehicle,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalDays: totalDays ?? this.totalDays,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      totalPrice: totalPrice ?? this.totalPrice,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      returnLocation: returnLocation ?? this.returnLocation,
      status: status ?? this.status,
    );
  }
}
