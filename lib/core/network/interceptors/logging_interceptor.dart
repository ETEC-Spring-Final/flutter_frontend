import 'dart:developer';

import 'package:dio/dio.dart';

/// Logs Dio requests, responses, and errors.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('REQUEST: ${options.method} ${options.uri}');

    log('Headers: ${options.headers}');

    log('Body: ${options.data}');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');

    log('Response data: ${response.data}');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('ERROR: ${err.response?.statusCode} ${err.requestOptions.uri}');

    log('Error response: ${err.response?.data}');

    handler.next(err);
  }
}
