import 'package:vehicle_rental_system/feature/booking/data/model/additional_service_model.dart';
import 'package:vehicle_rental_system/feature/booking/data/model/booking_model.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/rental_location.dart';

abstract class BookingRemoteDataSource {
  Future<List<BookingModel>> getBookings();

  Future<BookingModel> createBooking(Map<String, dynamic> payload);

  Future<BookingModel> cancelBooking(int id);

  /// Loads the pick-up / return locations offered by the backend.
  Future<List<RentalLocation>> getLocations();

  /// Loads the per-day rental add-ons offered by the backend.
  Future<List<AdditionalServiceModel>> getAdditionalServices();
}
