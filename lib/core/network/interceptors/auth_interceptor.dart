import 'package:dio/dio.dart';
import 'package:vehicle_rental_system/core/storage/secure_storage_service.dart';

/// Attaches the stored bearer token to protected API requests.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Don't attach JWT to authentication endpoints.
    if (options.path.startsWith('/auth/')) {
      handler.next(options);
      return;
    }

    final token = await _secureStorage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Future: handle 401 and token refresh here.
    handler.next(err);
  }
}
