part of 'notification_bloc.dart';

/// Base state for the [NotificationBloc].
sealed class NotificationState {
  const NotificationState();
}

/// Initial state before any loading happens.
final class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

/// While the inbox is being fetched.
final class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

/// Inbox loaded successfully.
final class NotificationLoaded extends NotificationState {
  final List<AppNotification> notifications;

  const NotificationLoaded(this.notifications);
}

/// A request failed.
final class NotificationError extends NotificationState {
  final Failure failure;

  const NotificationError(this.failure);
}