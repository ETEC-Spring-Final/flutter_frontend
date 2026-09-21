import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/check_payment_usecase.dart';
import '../../domain/usecase/create_qr_usecase.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreateQrUseCase createQrUseCase;
  final CheckPaymentUseCase checkPaymentUseCase;

  PaymentBloc({
    required this.createQrUseCase,
    required this.checkPaymentUseCase,
  }) : super(PaymentInitial()) {
    on<CreateQrEvent>(_onCreateQr);
    on<CheckPaymentEvent>(_onCheckPayment);
  }

  Future<void> _onCreateQr(
    CreateQrEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      final response = await createQrUseCase(amount: event.amount);

      emit(QrCreated(response));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> _onCheckPayment(
    CheckPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentChecking());

    try {
      final response = await checkPaymentUseCase(md5: event.md5);

      if (response.isSuccess) {
        emit(PaymentSuccess());
      } else {
        emit(
          PaymentFailure(
            response.responseMessage.isEmpty
                ? 'Payment could not be verified'
                : response.responseMessage,
          ),
        );
      }
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}
