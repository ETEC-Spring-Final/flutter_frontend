import 'package:vehicle_rental_system/feature/auth/domain/entity/auth_response.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/register_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repo;

  RegisterUseCase(this.repo);

  Future<AuthResponse> call(RegisterRequest request) {
    return repo.register(request);
  }
}
