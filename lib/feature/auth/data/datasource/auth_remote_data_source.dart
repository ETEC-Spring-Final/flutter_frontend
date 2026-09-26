import 'package:vehicle_rental_system/feature/auth/data/model/auth_response_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/model/forgot_password_request_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/model/login_request_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/model/register_request_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/model/reset_password_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register(RegisterRequestModel request);

  Future<AuthResponseModel> login(LoginRequestModel request);

  /// Sends a password reset link to the given email.
  /// The backend returns a confirmation message string.
  Future<String> forgotPassword(ForgotPasswordRequestModel request);

  /// Resets the password with a token from the emailed link.
  Future<void> resetPassword(ResetPasswordRequestModel request);
}
