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
  // Bookings
  // ==========================================

  static const String bookings = '/bookings';

  static String bookingById(int id) {
    return '/bookings/$id';
  }
}
