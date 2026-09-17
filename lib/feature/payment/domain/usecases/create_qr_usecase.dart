import '../../data/models/create_qr_response.dart';
import '../repositories/payment_repository.dart';

class CreateQrUseCase {
  final PaymentRepository repository;

  CreateQrUseCase(this.repository);

  Future<CreateQrResponse> call({required double amount}) {
    return repository.createQr(amount: amount);
  }
}
