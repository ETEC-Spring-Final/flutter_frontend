import 'package:vehicle_rental_system/core/network/api_client.dart';
import 'package:vehicle_rental_system/core/network/api_endpoints.dart';
import 'package:vehicle_rental_system/feature/booking/data/datasource/booking_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/booking/data/model/booking_model.dart';

/// Remote [BookingRemoteDataSource] backed by the Spring Boot `/bookings` API.
class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient apiClient;

  BookingRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<BookingModel>> getBookings() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.bookings,
    );

    final data = response.data?['data'] as List? ?? const [];

    return data
        .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BookingModel> createBooking(Map<String, dynamic> payload) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.bookings,
      data: payload,
    );

    final data = (response.data?['data'] ?? response.data) as Map<String, dynamic>;

    return BookingModel.fromJson(data);
  }

  @override
  Future<BookingModel> cancelBooking(int id) async {
    final response = await apiClient.put<Map<String, dynamic>>(
      '${ApiEndpoints.bookingById(id)}/cancel',
    );

    final data = (response.data?['data'] ?? response.data) as Map<String, dynamic>;

    return BookingModel.fromJson(data);
  }
}
