import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/feature/payment/data/datasource/payment_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/payment/data/repository/payment_repository_impl.dart';
import 'package:vehicle_rental_system/feature/payment/domain/repository/payment_repository.dart';
import 'package:vehicle_rental_system/feature/payment/domain/usecase/check_payment_usecase.dart';
import 'package:vehicle_rental_system/feature/payment/domain/usecase/create_qr_usecase.dart';

final sl = GetIt.instance;

void paymentInjection() {
  // ============================================================
  // Data
  // ============================================================

  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(sl<PaymentRemoteDataSource>()),
  );

  // ============================================================
  // Use Cases
  // ============================================================

  sl.registerFactory<CreateQrUseCase>(
    () => CreateQrUseCase(sl<PaymentRepository>()),
  );

  sl.registerFactory<CheckPaymentUseCase>(
    () => CheckPaymentUseCase(sl<PaymentRepository>()),
  );
}