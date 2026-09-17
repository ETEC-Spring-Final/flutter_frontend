import '../../data/models/create_qr_response.dart';
import '../../data/models/check_payment_response.dart';

abstract class PaymentRepository {
  Future<CreateQrResponse> createQr({required double amount});

  Future<CheckPaymentResponse> checkPayment({required String md5});
}
