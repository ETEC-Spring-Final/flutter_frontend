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
      handler.next(options); // Continue the request unmodified.
      return;
    }

    // Fetch the persisted token (may be null if the user isn't logged in
    // or the token was cleared, e.g. after logout).
    final token = await _secureStorage.getToken();

    // Only attach the header if we actually have a usable token.
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    // Forgetting this would cause the request to hang indefinitely.
    // Always call handler.next() to let the request proceed down the chain.
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Future: handle 401 and token refresh here.
    // Future implementation should:
    //   - Detect err.response?.statusCode == 401
    //   - Attempt to refresh the token via a dedicated /auth/refresh call
    //   - Retry the original request (err.requestOptions) with the new token
    //   - If refresh fails, clear stored credentials and force re-login
    //   - Guard against concurrent refresh attempts / infinite retry loops
    handler.next(err); // Pass the error along unchanged for now.
  }
}
