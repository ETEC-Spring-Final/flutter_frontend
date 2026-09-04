/// Payload used to create a new booking.
///
/// Matches the shape expected by the Spring Boot `/bookings` POST endpoint.
class NewBookingRequest {
  final int vehicleId;
  final DateTime startDate;
  final DateTime endDate;
  final String pickupLocation;
  final String returnLocation;
  final String? paymentMethod;

  const NewBookingRequest({
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    required this.pickupLocation,
    required this.returnLocation,
    this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'pickup_location': pickupLocation,
      'return_location': returnLocation,
      if (paymentMethod != null) 'payment_method': paymentMethod,
    };
  }
}
