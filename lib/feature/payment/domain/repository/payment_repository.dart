import '../../data/model/create_qr_response.dart';
import '../../data/model/check_payment_response.dart';

abstract class PaymentRepository {
  Future<CreateQrResponse> createQr({required double amount});

  Future<CheckPaymentResponse> checkPayment({required String md5});
}
