import 'package:dio/dio.dart';
import 'package:vehicle_rental_system/core/constants/api_constants.dart';

import '../models/create_qr_response.dart';
import '../models/check_payment_response.dart';

abstract class PaymentRemoteDataSource {
  Future<CreateQrResponse> createQr({required double amount});

  Future<CheckPaymentResponse> checkPayment({required String md5});
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;

  PaymentRemoteDataSourceImpl(this.dio);

  @override
  Future<CreateQrResponse> createQr({required double amount}) async {
    // The Spring `BakongRequest` DTO. Only `amount` is required for payment;
    // the backend fills sensible defaults for the remaining KHQR fields.
    final response = await dio.post(
      ApiConstants.generateQr,
      data: {
        'currency': 'KHR',
        'amount': amount,
        'expirationTimestamp': 15,
      },
    );

    return CreateQrResponse.fromJson(response.data);
  }

  @override
  Future<CheckPaymentResponse> checkPayment({required String md5}) async {
    final response = await dio.post(
      ApiConstants.checkTransaction,
      data: {'md5': md5},
    );

    return CheckPaymentResponse.fromJson(response.data);
  }
}