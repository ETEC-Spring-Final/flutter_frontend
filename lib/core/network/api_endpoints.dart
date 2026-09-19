class ApiEndpoints {
  ApiEndpoints._();

  // ==========================================
  // Auth
  // ==========================================

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // ==========================================
  // Vehicles
  // ==========================================

  static const String vehicles = '/vehicles';

  static String vehicleById(int id) {
    return '/vehicles/$id';
  }

  // ==========================================
  // Customers
  // ==========================================

  static const String customers = '/customers';

  static String customerById(int id) {
    return '/customers/$id';
  }

  // ==========================================
  // Reservations (the backend "booking" resource)
  // ==========================================

  static const String reservations = '/reservations';

  /// Current user's reservations.
  static const String myReservations = '/reservations/my-reservations';

  static String reservationById(int id) {
    return '/reservations/$id';
  }

  static String cancelReservation(int id) {
    return '/reservations/$id/cancel';
  }

  // ==========================================
  // Locations (pick-up / return points)
  // ==========================================

  static const String locations = '/locations';

  // ==========================================
  // QR Code / Bakong (generate after booking)
  // ==========================================

  /// Payload: `{ "qr": "string", "md5": "string" }`
  static const String qrImage = '/v1/bakong/qr-image';

  /// Payload: the EMVCo QR data (`QrGenerateRequest`)
  static const String generateQr = '/v1/bakong/generate-qr';

  /// Payload: `{ "md5": "string" }`
  static const String checkTransaction = '/v1/bakong/check-transaction';
}
