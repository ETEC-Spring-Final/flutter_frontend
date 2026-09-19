import 'package:dio/dio.dart';
import 'package:vehicle_rental_system/core/constants/api_constants.dart';

class DioClient {
  DioClient._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    return dio;
  }
}

/*

import 'package:dio/dio.dart';
import 'package:vehicle_rental_system/core/constants/api_constants.dart';

// Factory for creating a pre-configured [Dio] HTTP client instance.
// Centralizes base URL, timeouts, and default headers so every part of
// the app that needs to make network calls uses the same consistent
// configuration. Interceptors (e.g. AuthInterceptor, LoggingInterceptor)
// are typically attached to the returned instance after creation.
class DioClient {
  static Dio create() {
    return Dio(
      BaseOptions(
        // Root URL prepended to all relative request paths
        // (e.g. '/auth/login' becomes '$baseUrl/auth/login').
        baseUrl: ApiConstants.baseUrl,

        // Max time allowed to establish the initial connection.
        connectTimeout: const Duration(seconds: 10),

        // Max time allowed to receive the full response after connecting.
        receiveTimeout: const Duration(seconds: 10),

        // Max time allowed to send the full request body.
        sendTimeout: const Duration(seconds: 10),

        // Default headers applied to every request unless overridden.
        headers: {
          'Content-Type': 'application/json', // We're sending JSON payloads.
          'Accept': 'application/json', // We expect JSON responses back.
        },
      ),
    );
  }
}

*/
