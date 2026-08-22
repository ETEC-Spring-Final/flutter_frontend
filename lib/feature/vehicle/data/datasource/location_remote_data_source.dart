import 'package:dio/dio.dart';

abstract class LocationRemoteDataSource {
  Future<String> getLocationName({
    required double latitude,
    required double longitude,
  });
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final Dio dio;

  LocationRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> getLocationName({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'format': 'json',
          'zoom': 18,
          'addressdetails': 1,
        },
        options: Options(headers: {'User-Agent': 'vehicle_rental_system'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get location');
      }

      final data = response.data;

      final address = data['address'];

      if (address == null) {
        return 'Unknown location';
      }

      final city =
          address['city'] ??
          address['town'] ??
          address['village'] ??
          address['municipality'] ??
          address['county'];

      final country = address['country'];

      if (city != null && country != null) {
        return '$city, $country';
      }

      if (city != null) {
        return city.toString();
      }

      if (country != null) {
        return country.toString();
      }

      return 'Unknown location';
    } on DioException catch (e) {
      throw Exception('Location API error: ${e.message}');
    }
  }
}
