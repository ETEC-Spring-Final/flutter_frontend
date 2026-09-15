import 'dart:developer';

import 'package:dio/dio.dart';

/// Logs Dio requests, responses, and errors.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Log the HTTP method and full URL (including query params) being called.
    log('REQUEST: ${options.method} ${options.uri}');

    // Log request headers — note this includes any Authorization token
    // attached by other interceptors (e.g. AuthInterceptor).
    log('Headers: ${options.headers}');

    // Log the request body/payload, if any (e.g. JSON for POST/PUT).
    log('Body: ${options.data}');

    // Continue the request unmodified.
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log the status code and the URL that was called, to correlate
    // this response with its originating request.
    log('RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');

    // Log the raw response body returned by the server.
    log('Response data: ${response.data}');

    // Continue passing the response down the chain.
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log the failing status code (may be null for connection/timeout
    // errors that never got a response) and the URL that failed.
    log('ERROR: ${err.response?.statusCode} ${err.requestOptions.uri}');

    // Log the error response body, if the server returned one
    // (e.g. a JSON error message), for easier debugging.
    log('Error response: ${err.response?.data}');

    // Pass the error along unchanged so it still propagates to callers.
    handler.next(err);
  }
}
