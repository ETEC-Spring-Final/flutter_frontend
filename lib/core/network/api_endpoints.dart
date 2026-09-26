class ApiEndpoints {
  ApiEndpoints._();

  // ==========================================
  // Auth
  // ==========================================

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  /// Sends a password reset link via email. Body: `{ "email": "string" }`.
  static const String forgotPassword = '/auth/forgot-password';

  /// Resets the password with the emailed token. Body: `{ "token", "newPassword" }`.
  static const String resetPassword = '/auth/reset-password';

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
  // User Profile (current user self-service)
  // ==========================================

  /// Current user's profile. `GET` fetches, `PUT` updates.
  static const String myProfile = '/user-profiles/me';

  /// Current user's login history.
  static const String myLoginHistory = '/user-profiles/me/login-history';

  // ==========================================
  // Uploads (Cloudinary)
  // ==========================================

  /// Multipart upload; returns `{ "url", "publicId", "uploadedAt" }`.
  static const String upload = '/uploads';

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
  // Services catalogue (per-day add-ons for the booking form)
  // ==========================================

  static const String services = '/services';

  // ==========================================
  // QR Code / Bakong (generate after booking)
  // ==========================================

  /// Payload: `{ "qr": "string", "md5": "string" }`
  static const String qrImage = '/v1/bakong/qr-image';

  /// Payload: the EMVCo QR data (`QrGenerateRequest`)
  static const String generateQr = '/v1/bakong/generate-qr';

  /// Payload: `{ "md5": "string" }`
  static const String checkTransaction = '/v1/bakong/check-transaction';

  // ==========================================
  // Notifications
  // ==========================================

  /// Current user's notifications, newest first.
  static const String notificationsInbox = '/notifications/me/inbox';

  /// Unread count for the notification badge.
  static const String notificationsUnreadCount = '/notifications/me/unread-count';

  /// Mark every notification of the current user as read.
  static const String notificationsReadAll = '/notifications/me/read-all';

  static String notificationRead(int id) {
    return '/notifications/$id/read';
  }

  static String notificationById(int id) {
    return '/notifications/$id';
  }
}
