import 'package:vehicle_rental_system/feature/auth/domain/entity/auth_response.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/login_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/register_request.dart';

abstract class AuthRepository {
  Future<AuthResponse> register(RegisterRequest request);
  Future<AuthResponse> login(LoginRequest request);
}
