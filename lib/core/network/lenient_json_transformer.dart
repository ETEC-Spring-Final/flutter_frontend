import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Same as Dio's default transformer, except a body that is not valid JSON is
/// returned as a raw string instead of throwing a [FormatException].
///
/// Some Spring endpoints reply with `Content-Type: application/json` while the
/// body is plain text (a controller returning a bare `String`, e.g.
/// "Password reset email sent" from POST /auth/forgot-password). Dio decodes by
/// content type, so the plain text used to blow up with
/// "FormatException: Unexpected character (at offset 0)" and surface as
/// "Unable to connect to the server".
class LenientJsonTransformer extends BackgroundTransformer {
  @override
  Future<dynamic> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async {
    if (options.responseType != ResponseType.json) {
      return super.transformResponse(options, responseBody);
    }

    final builder = BytesBuilder(copy: false);

    await for (final chunk in responseBody.stream) {
      builder.add(chunk);
    }

    final body = utf8.decode(builder.takeBytes(), allowMalformed: true).trim();

    if (body.isEmpty) {
      return body;
    }

    try {
      return jsonDecode(body);
    } on FormatException {
      return body;
    }
  }
}
