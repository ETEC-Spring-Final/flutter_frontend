/// Display category of a backend notification.
///
/// Maps 1:1 to a `NotificationTypeEnum` value on the Spring Boot side. The
/// `system` category is the fallback for types the app does not know yet.
enum AppNotificationType {
  booking,
  payment,
  promotion,
  system;

  /// Parses a `NotificationTypeEnum` string sent by the backend.
  ///
  /// Booking/rental lifecycle events are grouped under [booking], payment
  /// lifecycle events under [payment], promotions under [promotion] and any
  /// unknown type falls back to [system].
  static AppNotificationType fromApi(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'BOOKING_CONFIRMED':
      case 'BOOKING_CANCELLED':
      case 'RENTAL_STARTING_SOON':
      case 'RENTAL_ENDING_SOON':
      case 'RETURN_REMINDER':
      case 'LATE_RETURN':
        return AppNotificationType.booking;
      case 'PAYMENT_SUCCESS':
      case 'PAYMENT_FAILED':
        return AppNotificationType.payment;
      case 'PROMOTION':
        return AppNotificationType.promotion;
      default:
        return AppNotificationType.system;
    }
  }
}

/// A single notification delivered to the current user.
class AppNotification {
  final int id;
  final int? userId;
  final String? userEmail;
  final AppNotificationType type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    this.userId,
    this.userEmail,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      userId: userId,
      userEmail: userEmail,
      type: type,
      title: title,
      message: message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}