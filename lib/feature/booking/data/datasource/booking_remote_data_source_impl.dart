import 'package:vehicle_rental_system/core/network/api_client.dart';
import 'package:vehicle_rental_system/core/network/api_endpoints.dart';
import 'package:vehicle_rental_system/feature/booking/data/datasource/booking_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/booking/data/model/additional_service_model.dart';
import 'package:vehicle_rental_system/feature/booking/data/model/booking_model.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/datasource/vehicle_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_model.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/rental_location.dart';

/// Remote [BookingRemoteDataSource] backed by the Spring Boot
/// `/api/reservations` API.
///
/// Reservations only reference the vehicle and locations by id, so this data
/// source enriches each reservation with the resolved vehicle and location
/// names before returning it.
class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient apiClient;
  final VehicleRemoteDataSource vehicleDataSource;

  BookingRemoteDataSourceImpl(this.apiClient, this.vehicleDataSource);

  @override
  Future<List<BookingModel>> getBookings() async {
    final response = await apiClient.get<dynamic>(ApiEndpoints.myReservations);

    final data = _extractList(response.data);

    final locationNames = await _fetchLocationNames();

    final bookings = <BookingModel>[];
    for (final item in data) {
      if (item is! Map) continue;
      bookings.add(
        await _resolve(
          Map<String, dynamic>.from(item),
          locationNames: locationNames,
        ),
      );
    }

    return bookings;
  }

  @override
  Future<BookingModel> createBooking(Map<String, dynamic> payload) async {
    final response = await apiClient.post<dynamic>(
      ApiEndpoints.reservations,
      data: payload,
    );

    final json = _extractMap(response.data);

    final locationNames = await _fetchLocationNames();

    return _resolve(json, locationNames: locationNames);
  }

  @override
  Future<BookingModel> cancelBooking(int id) async {
    final response = await apiClient.patch<dynamic>(
      ApiEndpoints.cancelReservation(id),
    );

    final json = _extractMap(response.data);

    final locationNames = await _fetchLocationNames();

    return _resolve(json, locationNames: locationNames);
  }

  @override
  Future<List<RentalLocation>> getLocations() async {
    final response = await apiClient.get<dynamic>(ApiEndpoints.locations);

    final data = _extractList(response.data);

    return data
        .whereType<Map>()
        .map((json) => RentalLocation.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<List<AdditionalServiceModel>> getAdditionalServices() async {
    final response = await apiClient.get<dynamic>(ApiEndpoints.services);

    final data = _extractList(response.data);

    return data
        .whereType<Map>()
        .map(
          (json) =>
              AdditionalServiceModel.fromJson(Map<String, dynamic>.from(json)),
        )
        .where((model) => model.isActive)
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Enriches a raw reservation JSON with its vehicle and location names.
  Future<BookingModel> _resolve(
    Map<String, dynamic> json, {
    required Map<int, String> locationNames,
  }) async {
    final vehicleId = (json['vehicleId'] as num?)?.toInt() ?? 0;

    VehicleModel? vehicle;
    if (vehicleId > 0) {
      try {
        vehicle = await vehicleDataSource.getVehicleById(vehicleId);
      } catch (_) {
        vehicle = null;
      }
    }

    return BookingModel.fromReservation(
      json,
      locationNames: locationNames,
      vehicle: vehicle,
    );
  }

  /// Fetches `GET /locations` and indexes it by id. Failures are non-fatal.
  Future<Map<int, String>> _fetchLocationNames() async {
    try {
      final locations = await getLocations();
      return {for (final location in locations) location.id: location.name};
    } catch (_) {
      return const {};
    }
  }

  List _extractList(dynamic body) {
    if (body is Map && body['data'] is List) {
      return body['data'] as List;
    }
    if (body is List) return body;
    return const [];
  }

  Map<String, dynamic> _extractMap(dynamic body) {
    if (body is Map && body['data'] is Map) {
      return Map<String, dynamic>.from(body['data'] as Map);
    }
    if (body is Map) return Map<String, dynamic>.from(body);
    return const {};
  }
}
