/// Payload used to create a new reservation/booking.
///
/// Matches the Spring Boot `ReservationRequestDTO` shape accepted by
/// `POST /api/reservations`.
class NewBookingRequest {
  final int vehicleId;

  final int pickUpLocationId;
  final int returnLocationId;

  final DateTime pickUpDateTime;
  final DateTime returnDateTime;

  final double? depositAmount;
  final double? discountAmount;
  final double? additionalCharges;
  final String? notes;

  /// The ids of the selected per-day rental add-ons
  /// (`GET /api/additional-services`).
  final List<int>? serviceIds;

  const NewBookingRequest({
    required this.vehicleId,
    required this.pickUpLocationId,
    required this.returnLocationId,
    required this.pickUpDateTime,
    required this.returnDateTime,
    this.depositAmount,
    this.discountAmount,
    this.additionalCharges,
    this.notes,
    this.serviceIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'pickUpLocationId': pickUpLocationId,
      'returnLocationId': returnLocationId,
      'pickUpDateTime': _format(pickUpDateTime),
      'returnDateTime': _format(returnDateTime),
      if (serviceIds != null && serviceIds!.isNotEmpty)
        'serviceIds': serviceIds,
      if (depositAmount != null) 'depositAmount': depositAmount,
      if (discountAmount != null) 'discountAmount': discountAmount,
      if (additionalCharges != null) 'additionalCharges': additionalCharges,
      if (notes != null) 'notes': notes,
    };
  }

  /// Spring's `LocalDateTime` expects an ISO-8601 string without a timezone
  /// suffix (e.g. `2026-09-18T09:00:00`).
  static String _format(DateTime value) {
    final local = value.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');

    return '${local.year}-${two(local.month)}-${two(local.day)}'
        'T${two(local.hour)}:${two(local.minute)}:${two(local.second)}';
  }
}
