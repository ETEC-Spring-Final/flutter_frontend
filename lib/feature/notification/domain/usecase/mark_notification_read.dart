import 'package:fpdart/fpdart.dart';

import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/notification/domain/entity/app_notification.dart';
import 'package:vehicle_rental_system/feature/notification/domain/repository/notification_repository.dart';

class MarkNotificationRead {
  final NotificationRepository repository;

  const MarkNotificationRead(this.repository);

  Future<Either<Failure, AppNotification>> call(int id) {
    return repository.markAsRead(id);
  }
}