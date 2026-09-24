import 'package:vehicle_rental_system/feature/auth/domain/entity/forgot_password_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/repository/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repo;

  ForgotPasswordUseCase(this.repo);

  Future<String> call(ForgotPasswordRequest request) {
    return repo.forgotPassword(request);
  }
}