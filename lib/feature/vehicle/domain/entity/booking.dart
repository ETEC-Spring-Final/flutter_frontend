import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';

class Booking {
  final int id;
  final String bookingNumber;

  final Vehicle vehicle;

  final DateTime startDate;
  final DateTime endDate;

  final int totalDays;
  final double pricePerDay;
  final double totalPrice;

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
      status: status ?? this.status,
    );
  }
}

final List<Booking> bookings = [
  // ============================================================
  // BOOKING 1 - BMW 5 SERIES
  // ============================================================
  Booking(
    id: 1,
    bookingNumber: 'BK-000001',
    vehicle: vehicles[0],
    startDate: DateTime(2026, 8, 28),
    endDate: DateTime(2026, 8, 30),
    totalDays: 2,
    pricePerDay: 85,
    totalPrice: 170,
    status: 'confirmed',
  ),

  // ============================================================
  // BOOKING 2 - PORSCHE 911
  // ============================================================
  Booking(
    id: 2,
    bookingNumber: 'BK-000002',
    vehicle: vehicles[1],
    startDate: DateTime(2026, 9, 1),
    endDate: DateTime(2026, 9, 3),
    totalDays: 2,
    pricePerDay: 150,
    totalPrice: 300,
    status: 'pending',
  ),

  // ============================================================
  // BOOKING 3 - TOYOTA LAND CRUISER
  // ============================================================
  Booking(
    id: 3,
    bookingNumber: 'BK-000003',
    vehicle: vehicles[2],
    startDate: DateTime(2026, 8, 15),
    endDate: DateTime(2026, 8, 18),
    totalDays: 3,
    pricePerDay: 120,
    totalPrice: 360,
    status: 'completed',
  ),

  // ============================================================
  // BOOKING 4 - TESLA MODEL 3
  // ============================================================
  Booking(
    id: 4,
    bookingNumber: 'BK-000004',
    vehicle: vehicles[3],
    startDate: DateTime(2026, 9, 5),
    endDate: DateTime(2026, 9, 8),
    totalDays: 3,
    pricePerDay: 95,
    totalPrice: 285,
    status: 'confirmed',
  ),

  // ============================================================
  // BOOKING 5 - BMW 5 SERIES
  // ============================================================
  Booking(
    id: 5,
    bookingNumber: 'BK-000005',
    vehicle: vehicles[0],
    startDate: DateTime(2026, 8, 10),
    endDate: DateTime(2026, 8, 12),
    totalDays: 2,
    pricePerDay: 85,
    totalPrice: 170,
    status: 'completed',
  ),

  // ============================================================
  // BOOKING 6 - TOYOTA LAND CRUISER
  // ============================================================
  Booking(
    id: 6,
    bookingNumber: 'BK-000006',
    vehicle: vehicles[2],
    startDate: DateTime(2026, 9, 10),
    endDate: DateTime(2026, 9, 14),
    totalDays: 4,
    pricePerDay: 120,
    totalPrice: 480,
    status: 'pending',
  ),

  // ============================================================
  // BOOKING 7 - PORSCHE 911
  // ============================================================
  Booking(
    id: 7,
    bookingNumber: 'BK-000007',
    vehicle: vehicles[1],
    startDate: DateTime(2026, 8, 20),
    endDate: DateTime(2026, 8, 22),
    totalDays: 2,
    pricePerDay: 150,
    totalPrice: 300,
    status: 'completed',
  ),

  // ============================================================
  // BOOKING 8 - TESLA MODEL 3
  // ============================================================
  Booking(
    id: 8,
    bookingNumber: 'BK-000008',
    vehicle: vehicles[3],
    startDate: DateTime(2026, 9, 15),
    endDate: DateTime(2026, 9, 18),
    totalDays: 3,
    pricePerDay: 95,
    totalPrice: 285,
    status: 'confirmed',
  ),

  // ============================================================
  // BOOKING 9 - BMW 5 SERIES
  // ============================================================
  Booking(
    id: 9,
    bookingNumber: 'BK-000009',
    vehicle: vehicles[0],
    startDate: DateTime(2026, 9, 20),
    endDate: DateTime(2026, 9, 23),
    totalDays: 3,
    pricePerDay: 85,
    totalPrice: 255,
    status: 'pending',
  ),

  // ============================================================
  // BOOKING 10 - PORSCHE 911
  // ============================================================
  Booking(
    id: 10,
    bookingNumber: 'BK-000010',
    vehicle: vehicles[1],
    startDate: DateTime(2026, 7, 20),
    endDate: DateTime(2026, 7, 22),
    totalDays: 2,
    pricePerDay: 150,
    totalPrice: 300,
    status: 'cancelled',
  ),
];
