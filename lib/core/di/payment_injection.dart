import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/feature/payment/data/datasources/payment_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/payment/data/repositories/payment_repository_impl.dart';
import 'package:vehicle_rental_system/feature/payment/domain/repositories/payment_repository.dart';
import 'package:vehicle_rental_system/feature/payment/domain/usecases/check_payment_usecase.dart';
import 'package:vehicle_rental_system/feature/payment/domain/usecases/create_qr_usecase.dart';

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