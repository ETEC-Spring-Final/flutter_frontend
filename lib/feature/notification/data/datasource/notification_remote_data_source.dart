import 'package:vehicle_rental_system/feature/notification/data/model/notification_model.dart';

/// Remote contract for the Spring Boot `/api/notifications` endpoints.
abstract class NotificationRemoteDataSource {
  /// `GET /notifications/me/inbox` — current user's notifications.
  Future<List<NotificationModel>> getNotifications();

  /// `PATCH /notifications/{id}/read` — mark a single notification as read.
  Future<NotificationModel> markAsRead(int id);

  /// `PATCH /notifications/me/read-all` — mark everything as read.
  Future<void> markAllAsRead();
}