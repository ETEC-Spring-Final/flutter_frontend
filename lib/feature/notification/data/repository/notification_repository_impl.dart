import 'package:fpdart/fpdart.dart';

import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/notification/data/datasource/notification_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/notification/data/mapper/notification_mapper.dart';
import 'package:vehicle_rental_system/feature/notification/domain/entity/app_notification.dart';
import 'package:vehicle_rental_system/feature/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remote;

  NotificationRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() async {
    try {
      final models = await remote.getNotifications();

      final notifications = models.map(NotificationMapper.toEntity).toList();

      return Right(notifications);
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppNotification>> markAsRead(int id) async {
    try {
      final model = await remote.markAsRead(id);

      return Right(NotificationMapper.toEntity(model));
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await remote.markAllAsRead();

      return const Right(null);
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }
}