import 'package:vehicle_rental_system/feature/auth/domain/entity/auth_response.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/login_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repo;

  LoginUseCase(this.repo);

  Future<AuthResponse> call(LoginRequest request) {
    return repo.login(request);
  }
}
