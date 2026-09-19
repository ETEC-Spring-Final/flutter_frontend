import 'package:fpdart/fpdart.dart';

import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/notification/domain/repository/notification_repository.dart';

class MarkAllNotificationsRead {
  final NotificationRepository repository;

  const MarkAllNotificationsRead(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.markAllAsRead();
  }
}