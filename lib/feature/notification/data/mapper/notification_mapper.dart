import 'package:vehicle_rental_system/feature/notification/data/model/notification_model.dart';
import 'package:vehicle_rental_system/feature/notification/domain/entity/app_notification.dart';

/// Converts between the [AppNotification] domain entity and the
/// [NotificationModel] data model.
class NotificationMapper {
  const NotificationMapper._();

  // Data Model -> Domain Entity
  static AppNotification toEntity(NotificationModel model) {
    return AppNotification(
      id: model.id,
      userId: model.userId,
      userEmail: model.userEmail,
      type: AppNotificationType.fromApi(model.type),
      title: model.title,
      message: model.message,
      isRead: model.isRead,
      createdAt: model.createdAt,
    );
  }

  // Domain Entity -> Data Model
  static NotificationModel toModel(AppNotification entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      userEmail: entity.userEmail,
      type: entity.type.name,
      title: entity.title,
      message: entity.message,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }
}