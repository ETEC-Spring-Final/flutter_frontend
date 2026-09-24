import 'package:vehicle_rental_system/feature/auth/data/model/auth_response_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/model/forgot_password_request_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/model/login_request_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/model/register_request_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/model/reset_password_request_model.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/auth_response.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/forgot_password_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/login_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/register_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/reset_password_request.dart';

class AuthMapper {
  static LoginRequestModel loginToModel(LoginRequest entity) {
    return LoginRequestModel(email: entity.email, password: entity.password);
  }

  static RegisterRequestModel registerToModel(RegisterRequest entity) {
    return RegisterRequestModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      password: entity.password,
      //confirmPassword: entity.confirmPassword,
      phone: entity.phone,
      gender: entity.gender,
    );
  }

  static ForgotPasswordRequestModel forgotToModel(
    ForgotPasswordRequest entity,
  ) {
    return ForgotPasswordRequestModel(email: entity.email);
  }

  static ResetPasswordRequestModel resetToModel(ResetPasswordRequest entity) {
    return ResetPasswordRequestModel(
      token: entity.token,
      newPassword: entity.newPassword,
    );
  }

  static AuthResponse modelToEntity(AuthResponseModel model) {
    return AuthResponse(token: model.token);
  }
}
