import 'package:vehicle_rental_system/feature/auth/data/model/auth_response_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/model/login_request_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/model/register_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register(RegisterRequestModel request);

  Future<AuthResponseModel> login(LoginRequestModel request);
}
