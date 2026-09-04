import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Thin wrapper around [FlutterSecureStorage] for auth-related secrets.
///
/// Only the auth token is stored today; extend this with more keys as needed.
class SecureStorageService {
  final FlutterSecureStorage storage;

  SecureStorageService(this.storage);

  final String key = 'jwt_token';

  Future<void> saveToken(String token) async {
    await storage.write(key: key, value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: key);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: key);
  }
  // static const String _authTokenKey = 'auth_token';

  // final FlutterSecureStorage _storage;

  // SecureStorageService(this._storage);

  // Future<String?> getToken() => _storage.read(key: _authTokenKey);

  // Future<void> saveToken(String token) =>
  //     _storage.write(key: _authTokenKey, value: token);

  // Future<void> deleteToken() => _storage.delete(key: _authTokenKey);
}
