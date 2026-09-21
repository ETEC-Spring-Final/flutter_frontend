import 'package:equatable/equatable.dart';

import '../../data/model/create_qr_response.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class QrCreated extends PaymentState {
  final CreateQrResponse response;

  const QrCreated(this.response);

  @override
  List<Object?> get props => [response];
}

class PaymentChecking extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure(this.message);

  @override
  List<Object?> get props => [message];
}
