import '../../data/model/check_payment_response.dart';
import '../repository/payment_repository.dart';

class CheckPaymentUseCase {
  final PaymentRepository repository;

  CheckPaymentUseCase(this.repository);

  Future<CheckPaymentResponse> call({required String md5}) {
    return repository.checkPayment(md5: md5);
  }
}
