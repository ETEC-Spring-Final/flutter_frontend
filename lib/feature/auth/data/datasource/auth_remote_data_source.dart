import 'package:vehicle_rental_system/feature/auth/data/models/auth_response_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/models/login_request_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/models/register_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register(RegisterRequestModel request);

  Future<AuthResponseModel> login(LoginRequestModel request);
}
