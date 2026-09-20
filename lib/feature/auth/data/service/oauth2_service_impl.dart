import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:vehicle_rental_system/core/constants/api_constants.dart';
import 'package:vehicle_rental_system/feature/auth/domain/service/oauth2_service.dart';

class OAuth2ServiceImpl implements OAuth2Service {
  static const String callbackScheme = 'vehicle-rental';
  static const String callbackPath = '/oauth2/redirect';

  @override
  Future<String?> authenticate({required String provider}) async {
    final authorizationUrl = '$_serverOrigin/oauth2/authorization/$provider';

    final String result;
    try {
      result = await FlutterWebAuth2.authenticate(
        url: authorizationUrl,
        callbackUrlScheme: callbackScheme,
      );
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') return null;
      throw Exception('Unable to open the sign-in screen: ${e.message}');
    }

    final callback = Uri.parse(result);
    if (callback.scheme != callbackScheme) return null;

    final error = callback.queryParameters['oauthError'];
    if (error != null && error.isNotEmpty) {
      throw Exception(_friendlyOAuthError(error));
    }

    if (callback.path != callbackPath) return null;

    final token = callback.queryParameters['token'];
    if (token != null && token.isNotEmpty) return token;

    return null;
  }

  String get _serverOrigin {
    final uri = Uri.parse(ApiConstants.baseUrl);
    return '${uri.scheme}://${uri.authority}';
  }

  String _friendlyOAuthError(String error) {
    if (error.contains('redirect_uri_mismatch')) {
      return 'The OAuth redirect URI is not registered with the provider. Check OAUTH2_REDIRECT_URI and the provider console.';
    }
    if (error.contains('invalid_client')) {
      return 'The OAuth client credentials are invalid. Check the backend .env file.';
    }
    return 'OAuth login failed: $error';
  }
}