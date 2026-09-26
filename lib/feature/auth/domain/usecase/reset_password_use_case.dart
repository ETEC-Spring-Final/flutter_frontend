import 'package:vehicle_rental_system/feature/auth/domain/entity/reset_password_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/repository/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repo;

  ResetPasswordUseCase(this.repo);

  Future<void> call(ResetPasswordRequest request) {
    return repo.resetPassword(request);
  }
}