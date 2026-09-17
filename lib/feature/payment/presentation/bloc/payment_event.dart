import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class CreateQrEvent extends PaymentEvent {
  final double amount;

  const CreateQrEvent({required this.amount});

  @override
  List<Object?> get props => [amount];
}

class CheckPaymentEvent extends PaymentEvent {
  final String md5;

  const CheckPaymentEvent({required this.md5});

  @override
  List<Object?> get props => [md5];
}
