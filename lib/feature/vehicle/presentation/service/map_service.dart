import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class MapService {
  static Future<void> openGoogleMaps(double latitude, double longitude) async {
    final googleMapsUri = Uri.parse('google.navigation:q=$latitude,$longitude');

    final webUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    try {
      // Try Google Maps app first
      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
        return;
      }

      // Fallback to browser / Google Maps
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      log('Could not open Google Maps: $e');
    }
  }

  static Future<String> getLocationName(
    double latitude,
    double longitude,
  ) async {
    try {
      final dio = Dio();

      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'format': 'json',
          'accept-language': 'en',
        },
        options: Options(headers: {'User-Agent': 'vehicle_rental_system'}),
      );

      if (response.statusCode != 200) {
        return 'Location unavailable';
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

      if (city != null) {
        return city.toString();
      }

      final country = address['country'];

      if (country != null) {
        return country.toString();
      }

      return 'Unknown location';
    } on DioException catch (e) {
      log('Reverse geocoding error: ${e.message}');
      return 'Location unavailable';
    } catch (e) {
      log('Location error: $e');
      return 'Location unavailable';
    }
  }

  //Khmer name location
  /*
  static Future<String> getLocationName(
    double latitude,
    double longitude,
  ) async {
    try {
      final dio = Dio();

      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {'lat': latitude, 'lon': longitude, 'format': 'json'},
        options: Options(headers: {'User-Agent': 'vehicle_rental_system'}),
      );

      if (response.statusCode != 200) {
        return 'Location unavailable';
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
      log('Reverse geocoding error: ${e.message}');

      return 'Location unavailable';
    } catch (e) {
      log('Location error: $e');

      return 'Location unavailable';
    }
  }

 */
}
