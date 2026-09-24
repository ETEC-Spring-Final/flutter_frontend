import 'package:vehicle_rental_system/feature/auth/domain/entity/auth_response.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/forgot_password_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/login_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/register_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/reset_password_request.dart';

abstract class AuthRepository {
  Future<AuthResponse> register(RegisterRequest request);
  Future<AuthResponse> login(LoginRequest request);

  /// Sends a password reset link to the given email.
  /// Returns the confirmation message from the backend.
  Future<String> forgotPassword(ForgotPasswordRequest request);

  /// Resets the password with a token from the emailed link.
  Future<void> resetPassword(ResetPasswordRequest request);
}