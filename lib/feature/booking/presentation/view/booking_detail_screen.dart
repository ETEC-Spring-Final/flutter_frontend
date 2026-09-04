import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_back_button.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/booking.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';

class BookingDetailScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(theme, colors),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.chipHorizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 20.h),
                _StatusCard(booking: booking),
                SizedBox(height: 14.h),
                _BookingSummaryCard(booking: booking),
                SizedBox(height: 14.h),
                _TripDetailsCard(booking: booking),
                SizedBox(height: 14.h),
                _PriceBreakdownCard(booking: booking),
                SizedBox(height: 20.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------------------------

  Widget _buildAppBar(
    ThemeData theme,
    ColorScheme colors,
  ) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colors.surface,
      expandedHeight: 260.h,
      leadingWidth: 60.w,
      leading: Padding(
        padding: EdgeInsets.all(12.w),
        child: const AppBackButton(),
      ),
      title: Text(
        'Booking Details',
        style: theme.textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: _HeaderImage(vehicle: booking.vehicle),
      ),
    );
  }
}

// =============================================================================
// HEADER IMAGE
// =============================================================================

class _HeaderImage extends StatelessWidget {
  const _HeaderImage({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final imageUrl = vehicle.images.isNotEmpty ? vehicle.images.first : '';

    return Stack(
      fit: StackFit.expand,
      children: [
        imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, e) => _Placeholder(theme),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _Placeholder(theme, loading: true);
                },
              )
            : _Placeholder(theme),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.45, 1.0],
              colors: [
                Colors.black.withValues(alpha: 0.4),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.8),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20.w,
          right: 20.w,
          bottom: 20.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${vehicle.brand} ${vehicle.model}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                vehicle.type,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.theme, {this.loading = false});

  final ThemeData theme;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: loading
          ? const CircularProgressIndicator(strokeWidth: 2)
          : Icon(
              Icons.directions_car_rounded,
              size: 48.sp,
              color: theme.colorScheme.onSurfaceVariant,
            ),
    );
  }
}

// =============================================================================
// STATUS CARD
// =============================================================================

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final (label, bg, fg) = _statusColors(booking.status, theme.brightness);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
                    ),
                    SizedBox(width: 7.w),
                    Text(
                      label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            'Booking number',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            booking.bookingNumber,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// BOOKING SUMMARY
// =============================================================================

class _BookingSummaryCard extends StatelessWidget {
  const _BookingSummaryCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Summary',
      icon: Icons.receipt_long_rounded,
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: 'Pick-up Date',
            value: DateFormat('EEE, MMM dd, yyyy').format(booking.startDate),
          ),
          SizedBox(height: 14.h),
          _InfoRow(
            icon: Icons.event_available_rounded,
            label: 'Return Date',
            value: DateFormat('EEE, MMM dd, yyyy').format(booking.endDate),
          ),
          SizedBox(height: 14.h),
          _InfoRow(
            icon: Icons.access_time_rounded,
            label: 'Duration',
            value: '${booking.totalDays} '
                '${booking.totalDays == 1 ? 'day' : 'days'}',
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TRIP DETAILS (LOCATIONS)
// =============================================================================

class _TripDetailsCard extends StatelessWidget {
  const _TripDetailsCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Locations',
      icon: Icons.route_rounded,
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.logout_rounded,
            label: 'Pick-up Location',
            value: booking.pickupLocation,
          ),
          SizedBox(height: 14.h),
          _InfoRow(
            icon: Icons.login_rounded,
            label: 'Return Location',
            value: booking.returnLocation,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PRICE BREAKDOWN
// =============================================================================

class _PriceBreakdownCard extends StatelessWidget {
  const _PriceBreakdownCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return _SectionCard(
      title: 'Payment',
      icon: Icons.payments_rounded,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vehicle (${booking.totalDays} days)',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                '\$${booking.pricePerDay.toStringAsFixed(2)} / day',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Paid',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '\$${booking.totalPrice.toStringAsFixed(2)}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SECTION CARD
// =============================================================================

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 17.sp, color: colors.primary),
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

// =============================================================================
// INFO ROW
// =============================================================================

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(7.w),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 17.sp, color: colors.primary),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// STATUS COLORS
// =============================================================================

(String, Color, Color) _statusColors(String status, Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  switch (status.toLowerCase()) {
    case 'confirmed':
      return isDark
          ? ('Confirmed', AppColors.darkInfoBackground, AppColors.darkInfo)
          : ('Confirmed', AppColors.infoBackground, AppColors.infoDark);
    case 'pending':
      return isDark
          ? ('Pending', AppColors.darkWarningBackground, AppColors.darkWarning)
          : ('Pending', AppColors.warningBackground, AppColors.warningDark);
    case 'completed':
      return isDark
          ? ('Completed', AppColors.darkSuccessBackground, AppColors.darkSuccess)
          : ('Completed', AppColors.successBackground, AppColors.successDark);
    case 'cancelled':
    case 'canceled':
      return isDark
          ? ('Cancelled', AppColors.darkErrorBackground, AppColors.darkError)
          : ('Cancelled', AppColors.errorBackground, AppColors.errorDark);
    default:
      return ('${status[0].toUpperCase()}${status.substring(1)}',
          Colors.transparent, Colors.grey);
  }
}
