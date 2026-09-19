/// A date window during which a vehicle is already reserved and therefore
/// unavailable for new rentals.
///
/// Backed by the Spring Boot `GET /api/vehicles/{id}/booked-dates` endpoint
/// (`BookedDateDTO`), which is derived from active (non-cancelled, ongoing)
/// reservations on the vehicle.
class BookedDate {
  final DateTime startDate;
  final DateTime endDate;

  const BookedDate({required this.startDate, required this.endDate});

  factory BookedDate.fromJson(Map<String, dynamic> json) {
    return BookedDate(
      startDate: DateTime.parse(json['startDate'] as String).toLocal(),
      endDate: DateTime.parse(json['endDate'] as String).toLocal(),
    );
  }
}