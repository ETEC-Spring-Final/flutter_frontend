part of 'notification_bloc.dart';

/// Base event for the [NotificationBloc].
sealed class NotificationEvent {
  const NotificationEvent();
}

/// Load the current user's notifications.
final class LoadNotificationsEvent extends NotificationEvent {
  const LoadNotificationsEvent();
}

/// Mark a single notification as read.
final class MarkNotificationReadEvent extends NotificationEvent {
  final int id;

  const MarkNotificationReadEvent(this.id);
}

/// Mark every notification as read.
final class MarkAllNotificationsReadEvent extends NotificationEvent {
  const MarkAllNotificationsReadEvent();
}