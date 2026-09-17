class PaymentQrInfo {
  final String currency;
  final double amount;
  final String merchantName;
  final String merchantCity;
  final String merchantId;
  final String acquiringBank;
  final String upiAccountInformation;
  final int expirationTimestamp;
  final String billNumber;
  final String storeLabel;
  final String terminalLabel;
  final String mobileNumber;
  final String purposeOfTransaction;
  final String merchantAlternateLanguagePreference;
  final String merchantNameAlternateLanguage;
  final String merchantCityAlternateLanguage;

  const PaymentQrInfo({
    required this.currency,
    required this.amount,
    required this.merchantName,
    required this.merchantCity,
    required this.merchantId,
    required this.acquiringBank,
    required this.upiAccountInformation,
    required this.expirationTimestamp,
    required this.billNumber,
    required this.storeLabel,
    required this.terminalLabel,
    required this.mobileNumber,
    required this.purposeOfTransaction,
    required this.merchantAlternateLanguagePreference,
    required this.merchantNameAlternateLanguage,
    required this.merchantCityAlternateLanguage,
  });

  factory PaymentQrInfo.fromJson(Map<String, dynamic> json) {
    return PaymentQrInfo(
      currency: json['currency'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      merchantName: json['merchantName'] ?? '',
      merchantCity: json['merchantCity'] ?? '',
      merchantId: json['merchantId'] ?? '',
      acquiringBank: json['acquiringBank'] ?? '',
      upiAccountInformation: json['upiAccountInformation'] ?? '',
      expirationTimestamp: json['expirationTimestamp'] ?? 0,
      billNumber: json['billNumber'] ?? '',
      storeLabel: json['storeLabel'] ?? '',
      terminalLabel: json['terminalLabel'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      purposeOfTransaction: json['purposeOfTransaction'] ?? '',
      merchantAlternateLanguagePreference:
          json['merchantAlternateLanguagePreference'] ?? '',
      merchantNameAlternateLanguage:
          json['merchantNameAlternateLanguage'] ?? '',
      merchantCityAlternateLanguage:
          json['merchantCityAlternateLanguage'] ?? '',
    );
  }
}
