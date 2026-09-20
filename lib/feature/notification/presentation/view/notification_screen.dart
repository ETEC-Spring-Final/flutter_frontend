import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_back_button.dart';
import 'package:vehicle_rental_system/feature/notification/domain/entity/app_notification.dart';
import 'package:vehicle_rental_system/feature/notification/presentation/bloc/notification_bloc.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  _NotificationFilter _filter = _NotificationFilter.all;

  List<AppNotification> _filtered(
    List<AppNotification> notifications,
  ) {
    if (_filter == _NotificationFilter.all) {
      return notifications;
    }

    return notifications
        .where((item) => _typeMatches(item.type, _filter))
        .toList();
  }

  bool _typeMatches(
    AppNotificationType type,
    _NotificationFilter filter,
  ) {
    switch (filter) {
      case _NotificationFilter.all:
        return true;
      case _NotificationFilter.booking:
        return type == AppNotificationType.booking ||
            type == AppNotificationType.payment;
      case _NotificationFilter.promotion:
        return type == AppNotificationType.promotion;
      case _NotificationFilter.system:
        return type == AppNotificationType.system;
    }
  }

  int _unreadCount(List<AppNotification> notifications) {
    return notifications.where((item) => !item.isRead).length;
  }

  int _countFor(
    _NotificationFilter filter,
    List<AppNotification> notifications,
  ) {
    return notifications
        .where((item) => _typeMatches(item.type, filter))
        .length;
  }

  /// Reloads the inbox and returns a future that completes when the reload
  /// has finished (used by [RefreshIndicator] and the refresh button).
  Future<void> _onRefresh() {
    final bloc = context.read<NotificationBloc>();
    final completer = Completer<void>();

    late StreamSubscription<NotificationState> subscription;
    subscription = bloc.stream.listen((state) {
      if (state is NotificationLoaded || state is NotificationError) {
        if (!completer.isCompleted) completer.complete();
      }
    });

    bloc.add(const LoadNotificationsEvent());

    return completer.future.whenComplete(subscription.cancel);
  }

  void _markAllRead() {
    context.read<NotificationBloc>().add(const MarkAllNotificationsReadEvent());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _markRead(AppNotification notification) {
    if (notification.isRead) return;

    context
        .read<NotificationBloc>()
        .add(MarkNotificationReadEvent(notification.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        final isLoading = state is NotificationLoading;
        final error = state is NotificationError ? state.failure.message : null;

        final notifications = state is NotificationLoaded
            ? state.notifications
            : const <AppNotification>[];

        final filtered = _filtered(notifications);
        final hasUnread = _unreadCount(notifications) > 0;

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            edgeOffset: 80.h,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: theme.scaffoldBackgroundColor,
                surfaceTintColor: Colors.transparent,
                leadingWidth: 60.w,
                leading: const AppBackButton(),
                titleSpacing: 0,
                centerTitle: false,
                title: Text(
                  'Notifications',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () => _onRefresh(),
                    tooltip: 'Refresh',
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: 20.r,
                      color: colorScheme.primary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: hasUnread ? _markAllRead : null,
                    icon: Icon(
                      Icons.done_all_rounded,
                      size: 20.r,
                      color: hasUnread
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    label: Text(
                      'Mark all read',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: hasUnread
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.3),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
              ),

              if (notifications.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.chipHorizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),

                        SizedBox(
                          height: 36.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _NotificationFilter.values.length,
                            separatorBuilder: (_, _) {
                              return SizedBox(width: AppDimensions.space8);
                            },
                            itemBuilder: (context, index) {
                              final filter =
                                  _NotificationFilter.values[index];
                              final isSelected = _filter == filter;

                              return _FilterChip(
                                label: filter.label,
                                count: _countFor(filter, notifications),
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() => _filter = filter);
                                },
                              );
                            },
                          ),
                        ),

                        if (hasUnread) ...[
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Container(
                                width: 8.r,
                                height: 8.r,
                                decoration: BoxDecoration(
                                  color: colorScheme.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '${_unreadCount(notifications)} unread',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],

                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ),

                if (filtered.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyNotifications(filter: _filter),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.chipHorizontalPadding,
                    ),
                    sliver: SliverList.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) {
                        return SizedBox(height: AppDimensions.space10);
                      },
                      itemBuilder: (context, index) {
                        final notification = filtered[index];

                        return _NotificationCard(
                          notification: notification,
                          onTap: () => _markRead(notification),
                        );
                      },
                    ),
                  ),
              ] else if (isLoading)
                const SliverToBoxAdapter(
                  child: _NotificationSkeleton(),
                )
              else if (error != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _NotificationError(
                    message: error,
                    onRetry: () {
                      context
                          .read<NotificationBloc>()
                          .add(const LoadNotificationsEvent());
                    },
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: 32.h)),
            ],
          ),
        ),
      );
    },
    );
  }
}

enum _NotificationFilter {
  all('All'),
  booking('Bookings'),
  promotion('Offers'),
  system('System');

  const _NotificationFilter(this.label);

  final String label;
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: isSelected ? colorScheme.primary : colorScheme.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.chipHorizontalPadding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
            border: Border.all(
              color: isSelected ? colorScheme.primary : colorScheme.outline,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.onPrimary.withValues(alpha: 0.2)
                        : colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusCircular,
                    ),
                  ),
                  child: Text(
                    '$count',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationSkeleton extends StatelessWidget {
  const _NotificationSkeleton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fill = colorScheme.surfaceContainerHighest;

    Widget bar(double width, double height) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    Widget card() {
      return Container(
        width: double.infinity,
        height: 100.h,
        padding: EdgeInsets.all(AppDimensions.cardPadding),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bar(160.w, 14),
                  SizedBox(height: 6.h),
                  bar(double.infinity, 12),
                  SizedBox(height: 4.h),
                  bar(200.w, 12),
                  SizedBox(height: 8.h),
                  bar(60.w, 10),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: fill,
      highlightColor: colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.chipHorizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Row(
              children: [
                _chip(fill, 64.w),
                SizedBox(width: AppDimensions.space8),
                _chip(fill, 88.w),
                SizedBox(width: AppDimensions.space8),
                _chip(fill, 76.w),
                SizedBox(width: AppDimensions.space8),
                _chip(fill, 96.w),
              ],
            ),
            SizedBox(height: 20.h),
            card(),
            SizedBox(height: AppDimensions.space10),
            card(),
            SizedBox(height: AppDimensions.space10),
            card(),
            SizedBox(height: AppDimensions.space10),
            card(),
          ],
        ),
      ),
    );
  }

  Widget _chip(Color fill, double width) {
    return Container(
      width: width,
      height: 36.h,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final accent = _accentFor(notification.type, colorScheme);

    return Material(
      color: notification.isRead
          ? colorScheme.surfaceContainerLow.withValues(alpha: 0.4)
          : accent.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            border: Border.all(
              color: notification.isRead
                  ? colorScheme.outline.withValues(alpha: 0.4)
                  : accent.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconFor(notification.type),
                  size: 22.r,
                  color: accent,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        if (!notification.isRead)
                          Container(
                            width: 8.r,
                            height: 8.r,
                            decoration: BoxDecoration(
                              color: colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notification.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      _relativeTime(notification.createdAt),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _accentFor(AppNotificationType type, ColorScheme colorScheme) {
    switch (type) {
      case AppNotificationType.booking:
        return colorScheme.primary;
      case AppNotificationType.payment:
        return AppColors.success;
      case AppNotificationType.promotion:
        return AppColors.warning;
      case AppNotificationType.system:
        return colorScheme.secondary;
    }
  }

  IconData _iconFor(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.booking:
        return Icons.calendar_month_rounded;
      case AppNotificationType.payment:
        return Icons.payments_rounded;
      case AppNotificationType.promotion:
        return Icons.local_offer_rounded;
      case AppNotificationType.system:
        return Icons.campaign_rounded;
    }
  }

  String _relativeTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    final month = time.month.toString().padLeft(2, '0');
    final day = time.day.toString().padLeft(2, '0');
    return '$day/$month';
  }
}

class _NotificationError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _NotificationError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.r,
              height: 88.r,
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 40.r,
                color: theme.colorScheme.error,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Could not load notifications',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  final _NotificationFilter filter;

  const _EmptyNotifications({required this.filter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.r,
              height: 88.r,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                filter == _NotificationFilter.all
                    ? Icons.notifications_none_rounded
                    : Icons.inbox_outlined,
                size: 40.r,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              filter == _NotificationFilter.all
                  ? 'No notifications yet'
                  : 'No ${filter.label.toLowerCase()} notifications',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'When there is something new, it will show up here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}