import 'package:bloc/bloc.dart';

import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/notification/domain/entity/app_notification.dart';
import 'package:vehicle_rental_system/feature/notification/domain/repository/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

/// Manages the current user's notifications.
///
/// Loads the inbox from the repository and exposes loading/error/loaded
/// states. "Mark as read" actions update the list optimistically so the
/// unread counter and badges stay in sync without a full reload.
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  /// Last successfully loaded snapshot, reused to keep content on screen when
  /// a pull-to-refresh fails transiently.
  List<AppNotification> _notifications = const [];

  NotificationBloc(this._repository) : super(const NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoad);
    on<MarkNotificationReadEvent>(_onMarkRead);
    on<MarkAllNotificationsReadEvent>(_onMarkAllRead);

    add(const LoadNotificationsEvent());
  }

  Future<void> _onLoad(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    // Only show the full-screen loader on the first load; background
    // refreshes keep the existing list on screen.
    if (state is! NotificationLoaded) {
      emit(const NotificationLoading());
    }

    final result = await _repository.getNotifications();

    result.fold(
      (failure) {
        // Keep the last known snapshot during a refresh failure so the list
        // does not vanish; only surface the error when we have no data yet.
        if (_notifications.isNotEmpty) {
          emit(NotificationLoaded(_notifications));
        } else {
          emit(NotificationError(failure));
        }
      },
      (notifications) {
        _notifications = notifications;
        emit(NotificationLoaded(notifications));
      },
    );
  }

  Future<void> _onMarkRead(
    MarkNotificationReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final current = state;
    if (current is! NotificationLoaded) return;

    final index = current.notifications.indexWhere((n) => n.id == event.id);
    if (index == -1) return;

    final target = current.notifications[index];
    if (target.isRead) return;

    final updated = List<AppNotification>.from(current.notifications);
    updated[index] = target.copyWith(isRead: true);

    _notifications = updated;
    emit(NotificationLoaded(updated));

    final result = await _repository.markAsRead(event.id);
    result.fold((_) {}, (_) {});
  }

  Future<void> _onMarkAllRead(
    MarkAllNotificationsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final current = state;
    if (current is! NotificationLoaded) return;

    final updated = current.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();

    _notifications = updated;
    emit(NotificationLoaded(updated));

    final result = await _repository.markAllAsRead();
    result.fold((_) {}, (_) {});
  }
}