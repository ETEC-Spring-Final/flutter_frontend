import 'package:fpdart/fpdart.dart';

import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/notification/domain/entity/app_notification.dart';

/// Contract for the notification feature.
///
/// Backed by the Spring Boot `/api/notifications` endpoints.
abstract class NotificationRepository {
  /// Loads the current user's notifications, newest first.
  Future<Either<Failure, List<AppNotification>>> getNotifications();

  /// Marks a single notification as read (owner or staff only).
  Future<Either<Failure, AppNotification>> markAsRead(int id);

  /// Marks every notification belonging to the current user as read.
  Future<Either<Failure, void>> markAllAsRead();
}