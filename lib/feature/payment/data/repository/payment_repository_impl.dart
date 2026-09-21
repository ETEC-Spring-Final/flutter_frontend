import '../../domain/repository/payment_repository.dart';
import '../datasource/payment_remote_data_source.dart';
import '../model/create_qr_response.dart';
import '../model/check_payment_response.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<CreateQrResponse> createQr({required double amount}) {
    return remoteDataSource.createQr(amount: amount);
  }

  @override
  Future<CheckPaymentResponse> checkPayment({required String md5}) {
    return remoteDataSource.checkPayment(md5: md5);
  }
}
