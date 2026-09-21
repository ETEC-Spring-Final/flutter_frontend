class CheckPaymentResponse {
  final int responseCode;
  final String responseMessage;
  final int? errorCode;
  final Object? data;

  const CheckPaymentResponse({
    this.responseCode = -1,
    this.responseMessage = '',
    this.errorCode,
    this.data,
  });

  bool get isSuccess => responseCode == 0;

  factory CheckPaymentResponse.fromJson(Map<String, dynamic> json) {
    return CheckPaymentResponse(
      responseCode: (json['responseCode'] as num?)?.toInt() ?? -1,
      responseMessage: json['responseMessage']?.toString() ?? '',
      errorCode: (json['errorCode'] as num?)?.toInt(),
      data: json['data'],
    );
  }
}