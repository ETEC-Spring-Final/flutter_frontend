import 'package:vehicle_rental_system/feature/booking/data/model/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<BookingModel>> getBookings();

  Future<BookingModel> createBooking(Map<String, dynamic> payload);

  Future<BookingModel> cancelBooking(int id);
}
