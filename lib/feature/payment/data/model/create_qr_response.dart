class CreateQrResponse {
  final String qr;
  final String md5;

  const CreateQrResponse({required this.qr, required this.md5});

  factory CreateQrResponse.fromJson(Map<String, dynamic> json) {
    // Spring returns the Bakong `KHQRResponse<KHQRData>` shape:
    // { "khqrStatus": {...}, "data": { "qr": "...", "md5": "...", ... } }
    final data = json['data'];

    final nested = data is Map<String, dynamic> ? data : {};

    final qr = nested['qr'] ?? json['qr'] ?? '';
    final md5 = nested['md5'] ?? json['md5'] ?? '';

    return CreateQrResponse(qr: qr as String, md5: md5 as String);
  }
}