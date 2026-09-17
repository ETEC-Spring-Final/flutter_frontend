/// Data-layer model matching the Spring Boot `RentalResponseDTO`
/// (camelCase JSON fields).
class RentalModel {
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

  const RentalModel({
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

  factory RentalModel.fromJson(Map<String, dynamic> json) {
    return RentalModel(
      id: json['id'] ?? 0,
      reservationId: (json['reservationId'] as num?)?.toInt(),
      vehicleId: (json['vehicleId'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt(),
      pickUpLocationId: (json['pickUpLocationId'] as num?)?.toInt(),
      returnLocationId: (json['returnLocationId'] as num?)?.toInt(),
      pickUpDateTime: _toDate(json['pickUpDateTime']),
      expectedReturnDateTime: _toDate(json['expectedReturnDateTime']),
      actualReturnDateTime: _toDate(json['actualReturnDateTime']),
      status: json['status']?.toString() ?? '',
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      additionalCharges: (json['additionalCharges'] as num?)?.toDouble() ?? 0,
      lateFee: (json['lateFee'] as num?)?.toDouble() ?? 0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
      notes: json['notes'],
      createdAt: _toDate(json['createdAt']),
      updatedAt: _toDate(json['updatedAt']),
    );
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }
}