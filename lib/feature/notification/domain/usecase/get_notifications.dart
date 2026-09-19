import 'package:fpdart/fpdart.dart';

import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/notification/domain/entity/app_notification.dart';
import 'package:vehicle_rental_system/feature/notification/domain/repository/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  const GetNotifications(this.repository);

  Future<Either<Failure, List<AppNotification>>> call() {
    return repository.getNotifications();
  }
}