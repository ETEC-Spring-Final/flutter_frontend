import 'package:vehicle_rental_system/feature/auth/data/models/auth_response_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/models/login_request_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/models/register_request_model.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/auth_response.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/login_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/register_request.dart';

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

  static AuthResponse modelToEntity(AuthResponseModel model) {
    return AuthResponse(token: model.token);
  }
}
