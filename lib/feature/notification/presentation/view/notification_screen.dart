import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_back_button.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  _NotificationFilter _filter = _NotificationFilter.all;

  final List<_Notification> _notifications = [
    _Notification(
      id: 1,
      type: _NotificationType.booking,
      title: 'Booking Confirmed',
      message:
          'Your booking for the Toyota Camry is confirmed. '
          'Pickup starts in 2 days.',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    _Notification(
      id: 2,
      type: _NotificationType.payment,
      title: 'Payment Successful',
      message: 'Your deposit of \$45.00 for the Honda CR-V has been received.',
      time: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    _Notification(
      id: 3,
      type: _NotificationType.promotion,
      title: 'Weekend Special Offer',
      message:
          'Enjoy 20% off on all SUV rentals this weekend. '
          'Book before Sunday!',
      time: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    _Notification(
      id: 4,
      type: _NotificationType.system,
      title: 'App Update Available',
      message:
          'A new version of the app is available. '
          'Update for the latest improvements.',
      time: DateTime.now().subtract(const Duration(days: 1)),
    ),
    _Notification(
      id: 5,
      type: _NotificationType.booking,
      title: 'Booking Reminder',
      message: 'Your booking for the Mazda CX-5 starts tomorrow at 9:00 AM.',
      time: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    ),
    _Notification(
      id: 6,
      type: _NotificationType.promotion,
      title: 'Refer a Friend',
      message:
          'Refer a friend and both of you get \$10 off '
          'your next rental.',
      time: DateTime.now().subtract(const Duration(days: 2)),
    ),
    _Notification(
      id: 7,
      type: _NotificationType.system,
      title: 'Security Tips',
      message:
          'Always verify vehicle condition before driving off. '
          'Stay safe on the road.',
      time: DateTime.now().subtract(const Duration(days: 3)),
    ),
    _Notification(
      id: 8,
      type: _NotificationType.booking,
      title: 'Booking Completed',
      message:
          'Thank you for renting with us. '
          'Please rate your experience with the Toyota RAV4.',
      time: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  List<_Notification> get _filteredNotifications {
    if (_filter == _NotificationFilter.all) {
      return _notifications;
    }

    return _notifications
        .where((item) => _typeMatches(item.type, _filter))
        .toList();
  }

  bool _typeMatches(_NotificationType type, _NotificationFilter filter) {
    switch (filter) {
      case _NotificationFilter.all:
        return true;
      case _NotificationFilter.booking:
        return type == _NotificationType.booking ||
            type == _NotificationType.payment;
      case _NotificationFilter.promotion:
        return type == _NotificationType.promotion;
      case _NotificationFilter.system:
        return type == _NotificationType.system;
    }
  }

  int get _unreadCount => _notifications.where((item) => !item.isRead).length;

  void _markAllRead() {
    setState(() {
      for (final item in _notifications) {
        item.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _markRead(_Notification notification) {
    if (notification.isRead) return;

    setState(() => notification.isRead = true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filtered = _filteredNotifications;
    final hasUnread = _unreadCount > 0;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
                        final filter = _NotificationFilter.values[index];
                        final isSelected = _filter == filter;

                        return _FilterChip(
                          label: filter.label,
                          count: _countFor(filter),
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
                          '$_unreadCount unread',
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

          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
        ],
      ),
    );
  }

  int _countFor(_NotificationFilter filter) {
    return _notifications
        .where((item) => _typeMatches(item.type, filter))
        .length;
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

enum _NotificationType { booking, payment, promotion, system }

class _Notification {
  _Notification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
  });

  final int id;
  final _NotificationType type;
  final String title;
  final String message;
  final DateTime time;
  bool isRead = false;
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

class _NotificationCard extends StatelessWidget {
  final _Notification notification;
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
                      _relativeTime(notification.time),
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

  Color _accentFor(_NotificationType type, ColorScheme colorScheme) {
    switch (type) {
      case _NotificationType.booking:
        return colorScheme.primary;
      case _NotificationType.payment:
        return AppColors.success;
      case _NotificationType.promotion:
        return AppColors.warning;
      case _NotificationType.system:
        return colorScheme.secondary;
    }
  }

  IconData _iconFor(_NotificationType type) {
    switch (type) {
      case _NotificationType.booking:
        return Icons.calendar_month_rounded;
      case _NotificationType.payment:
        return Icons.payments_rounded;
      case _NotificationType.promotion:
        return Icons.local_offer_rounded;
      case _NotificationType.system:
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
