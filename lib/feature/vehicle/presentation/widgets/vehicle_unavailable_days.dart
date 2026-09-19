import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/booked_date.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/bloc/vehicle_bloc.dart';

/// Shows the days a vehicle is already reserved (unavailable for rent).
///
/// Loads the data from the Spring Boot `GET /api/vehicles/{id}/booked-dates`
/// endpoint and renders either an "Available" card or the list of reserved
/// date ranges. Failures are treated as "no data" so the widget never blocks.
class VehicleUnavailableDays extends StatefulWidget {
  const VehicleUnavailableDays({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  State<VehicleUnavailableDays> createState() => _VehicleUnavailableDaysState();
}

class _VehicleUnavailableDaysState extends State<VehicleUnavailableDays> {
  late Future<List<BookedDate>> _bookedDatesFuture;

  // ===========================================================================
  // INIT
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    _bookedDatesFuture = _loadBookedDates();
  }

  Future<List<BookedDate>> _loadBookedDates() async {
    // Reuse the same repository instance that backs VehicleBloc.
    final result = await context
        .read<VehicleBloc>()
        .repository
        .getVehicleBookedDates(widget.vehicle.id);

    return result.fold(
      (failure) => const <BookedDate>[],
      (dates) => dates,
    );
  }

  // ===========================================================================
  // FORMATTERS
  // ===========================================================================

  String _formatBookedDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<List<BookedDate>>(
      future: _bookedDatesFuture,
      builder: (context, snapshot) {
        // Reserve vertical space while loading so the layout does not jump.
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: 96.h,
            child: Center(
              child: SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final dates = snapshot.hasError
            ? const <BookedDate>[]
            : (snapshot.data ?? const <BookedDate>[]);

        if (dates.isEmpty) {
          return _buildAvailableCard(theme);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================================================================
            // HEADER
            // ================================================================
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Unavailable Days',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    dates.length == 1
                        ? '1 day reserved'
                        : '${dates.length} days reserved',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onError,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 6.h),

            Text(
              'This vehicle is already rented on the dates below, so it '
              'cannot be booked during those periods.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            SizedBox(height: 12.h),

            // ================================================================
            // DATE RANGE LIST
            // ================================================================
            ...dates.map(
              (range) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _buildUnavailableDayCard(theme, range),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAvailableCard(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final green = const Color(0xFF2E7D32);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: green.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.event_available_rounded, color: green, size: 24.r),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: green,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  'No reserved dates. You can rent this vehicle anytime.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnavailableDayCard(ThemeData theme, BookedDate range) {
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(
          color: colorScheme.error.withValues(alpha: 0.40),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.event_busy_rounded, color: colorScheme.error, size: 22.r),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatBookedDate(range.startDate)}  –  '
                  '${_formatBookedDate(range.endDate)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  'Reserved — not available for rental',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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