import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_booking_bottom_bar.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Vehicle vehicle;
  final int rentalDays;
  final DateTime pickupDate;
  final DateTime returnDate;
  final String pickupLocation;
  final String returnLocation;
  final Map<String, bool> selectedServices;
  final String paymentMethod;
  final double totalPrice;

  const BookingConfirmationScreen({
    super.key,
    required this.vehicle,
    required this.rentalDays,
    required this.pickupDate,
    required this.returnDate,
    required this.pickupLocation,
    required this.returnLocation,
    required this.selectedServices,
    required this.paymentMethod,
    required this.totalPrice,
  });

  // ---------------------------------------------------------------------------
  // FORMATTERS
  // ---------------------------------------------------------------------------

  List<String> get _selectedServiceNames {
    return selectedServices.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  // ---------------------------------------------------------------------------
  // ACTIONS
  // ---------------------------------------------------------------------------

  void _finish(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _viewBookings(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/booking',
      (route) => route.isFirst,
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final services = _selectedServiceNames;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _SuccessHeader(onDone: () => _finish(context)),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.chipHorizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ConfirmationCard(
                  title: 'Booking Confirmed',
                  message:
                      'Your reservation has been placed successfully. '
                      'A confirmation has been sent to your registered contact.',
                  icon: Icons.verified_rounded,
                  iconColor: colors.primary,
                ),
                SizedBox(height: 14.h),
                _VehicleSummaryCard(vehicle: vehicle),
                SizedBox(height: 14.h),
                _TripDetailsCard(
                  rentalDays: rentalDays,
                  pickupDate: pickupDate,
                  returnDate: returnDate,
                  pickupLocation: pickupLocation,
                  returnLocation: returnLocation,
                ),
                SizedBox(height: 14.h),
                _PaymentSummaryCard(
                  paymentMethod: paymentMethod,
                  totalPrice: totalPrice,
                ),
                if (services.isNotEmpty) ...[
                  SizedBox(height: 14.h),
                  _ServicesCard(services: services),
                ],
                SizedBox(height: 20.h),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBookingBottomBar(
        label: 'View My Bookings',
        icon: Icons.receipt_long_rounded,
        onPressed: () => _viewBookings(context),
      ),
    );
  }
}

// =============================================================================
// SUCCESS HEADER
// =============================================================================

class _SuccessHeader extends StatelessWidget {
  const _SuccessHeader({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              size: 56.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Thank You!',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Your booking is complete',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CONFIRMATION CARD
// =============================================================================

class _ConfirmationCard extends StatelessWidget {
  const _ConfirmationCard({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22.sp, color: iconColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SECTION CARD WRAPPER
// =============================================================================

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: colors.outline),
      ),
      child: child,
    );
  }
}

// =============================================================================
// SECTION TITLE
// =============================================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
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
    );
  }
}

// =============================================================================
// VEHICLE SUMMARY CARD
// =============================================================================

class _VehicleSummaryCard extends StatelessWidget {
  const _VehicleSummaryCard({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return _SectionCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: SizedBox(
              width: 76.w,
              height: 62.h,
              child: Image.network(
                vehicle.images.isNotEmpty ? vehicle.images.first : '',
                fit: BoxFit.cover,
                errorBuilder: (_, _, e) => Container(
                  color: colors.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.directions_car_rounded,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicle.brand} ${vehicle.model}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.local_taxi_rounded,
                      size: 14.sp,
                      color: colors.onSurfaceVariant,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${vehicle.type} • ${vehicle.year}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  vehicle.licensePlate,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TRIP DETAILS CARD
// =============================================================================

class _TripDetailsCard extends StatelessWidget {
  const _TripDetailsCard({
    required this.rentalDays,
    required this.pickupDate,
    required this.returnDate,
    required this.pickupLocation,
    required this.returnLocation,
  });

  final int rentalDays;
  final DateTime pickupDate;
  final DateTime returnDate;
  final String pickupLocation;
  final String returnLocation;

  String _format(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.route_rounded,
            title: 'Trip Details',
          ),
          SizedBox(height: 16.h),
          _InfoRow(
            icon: Icons.event_available_rounded,
            label: 'Rental Duration',
            value: '$rentalDays ${rentalDays == 1 ? 'day' : 'days'}',
          ),
          SizedBox(height: 14.h),
          _InfoRow(
            icon: Icons.logout_rounded,
            label: 'Pick-up',
            value: '${_format(pickupDate)} • $pickupLocation',
          ),
          SizedBox(height: 14.h),
          _InfoRow(
            icon: Icons.login_rounded,
            label: 'Return',
            value: '${_format(returnDate)} • $returnLocation',
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PAYMENT SUMMARY CARD
// =============================================================================

class _PaymentSummaryCard extends StatelessWidget {
  const _PaymentSummaryCard({
    required this.paymentMethod,
    required this.totalPrice,
  });

  final String paymentMethod;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.payments_rounded,
            title: 'Payment',
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                paymentMethod,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Paid',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SERVICES CARD
// =============================================================================

class _ServicesCard extends StatelessWidget {
  const _ServicesCard({required this.services});

  final List<String> services;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.miscellaneous_services_rounded,
            title: 'Additional Services',
          ),
          SizedBox(height: 14.h),
          ...services.map(
            (service) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 16.sp,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      service,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        Icon(icon, size: 18.sp, color: colors.primary),
        SizedBox(width: 10.w),
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
