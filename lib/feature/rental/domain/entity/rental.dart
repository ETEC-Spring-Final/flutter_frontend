/// Domain entity for a rental returned by the Spring Boot `/rentals` API.
class Rental {
  final int id;
  final int? reservationId;
  final int vehicleId;
  final int? userId;
  final int? pickUpLocationId;
  final int? returnLocationId;
  final DateTime? pickUpDateTime;
  final DateTime? expectedReturnDateTime;
  final DateTime? actualReturnDateTime;
  final String status;
  final double basePrice;
  final double discountAmount;
  final double additionalCharges;
  final double lateFee;
  final double totalPrice;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Rental({
    required this.id,
    this.reservationId,
    required this.vehicleId,
    this.userId,
    this.pickUpLocationId,
    this.returnLocationId,
    this.pickUpDateTime,
    this.expectedReturnDateTime,
    this.actualReturnDateTime,
    required this.status,
    required this.basePrice,
    required this.discountAmount,
    required this.additionalCharges,
    required this.lateFee,
    required this.totalPrice,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });
}