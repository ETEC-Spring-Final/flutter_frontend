import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_badge.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/booking.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onViewDetails;

  const BookingCard({super.key, required this.booking, this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final vehicle = booking.vehicle;

    final vehicleName = '${vehicle.brand} ${vehicle.model}';

    final imageUrl = vehicle.images.isNotEmpty ? vehicle.images.first : '';

    final startDate = DateFormat('MMM dd, yyyy').format(booking.startDate);

    final endDate = DateFormat('MMM dd, yyyy').format(booking.endDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onViewDetails,
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
              //border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ============================================================
                // IMAGE
                // ============================================================
                AspectRatio(
                  aspectRatio: 1.87,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // ------------------------------------------------------
                      // VEHICLE IMAGE
                      // ------------------------------------------------------
                      imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }

                                    return Container(
                                      color:
                                          colorScheme.surfaceContainerHighest,
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colorScheme.primary,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return _imagePlaceholder(colorScheme);
                              },
                            )
                          : _imagePlaceholder(colorScheme),

                      // ------------------------------------------------------
                      // VEHICLE TYPE
                      // ------------------------------------------------------
                      // Positioned(
                      //   top: 14,
                      //   left: 14,
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 13,
                      //       vertical: 7,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: colorScheme.surface.withValues(alpha: 0.92),
                      //       borderRadius: BorderRadius.circular(30),
                      //     ),
                      //     child: Text(
                      //       vehicle.type,
                      //       style: theme.textTheme.labelLarge?.copyWith(
                      //         color: colorScheme.onSurface,
                      //         fontWeight: FontWeight.w700,
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // ------------------------------------------------------
                      // STATUS
                      // ------------------------------------------------------
                      // Positioned(
                      //   top: 14,
                      //   right: 14,
                      //   child: _StatusBadge(status: booking.status),
                      // ),
                      Positioned(
                        top: 8,
                        left: 8,
                        right: 8,
                        child: Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            AppBadge(label: vehicle.type),
                            _StatusBadge(status: booking.status),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ============================================================
                // CONTENT
                // ============================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ======================================================
                      // BOOKING NUMBER
                      // ======================================================
                      Text(
                        booking.bookingNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // ======================================================
                      // VEHICLE NAME + PRICE
                      // ======================================================
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              vehicleName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '\$${vehicle.pricePerDay.toStringAsFixed(0)}',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: ' / day',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Text(
                          //   '\$${booking.totalPrice.toStringAsFixed(0)}',
                          //   style: theme.textTheme.titleLarge?.copyWith(
                          //     color: AppColors.primary,
                          //     fontWeight: FontWeight.w800,
                          //   ),
                          // ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ======================================================
                      // RENTAL DATE
                      // ======================================================
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: colorScheme.onSurfaceVariant,
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              '$startDate — $endDate',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 9),

                      // ======================================================
                      // DURATION + TRANSMISSION
                      // ======================================================
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            size: 18,
                            color: colorScheme.onSurfaceVariant,
                          ),

                          const SizedBox(width: 7),

                          Text(
                            '${booking.totalDays} '
                            '${booking.totalDays == 1 ? 'day' : 'days'}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),

                          const _Dot(),

                          Icon(
                            Icons.settings_outlined,
                            size: 17,
                            color: colorScheme.onSurfaceVariant,
                          ),

                          const SizedBox(width: 5),

                          Flexible(
                            child: Text(
                              vehicle.transmission,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ======================================================
                      // DIVIDER
                      // ======================================================
                      Divider(
                        height: 1,
                        radius: BorderRadius.circular(50),
                        color: colorScheme.outlineVariant.withOpacity(0.10),
                      ),

                      const SizedBox(height: 14),

                      // ======================================================
                      // TOTAL + DETAILS
                      // ======================================================
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 2),

                                Text(
                                  '\$${booking.totalPrice.toStringAsFixed(0)}',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: AppColors.primary,
                                    //color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          OutlinedButton(
                            onPressed: onViewDetails,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(
                                color: AppColors.primary,
                                width: 1.3,
                              ),
                              minimumSize: const Size(130, 46),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: Text(
                              'View Details',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // IMAGE PLACEHOLDER
  // ================================================================

  Widget _imagePlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.directions_car_outlined,
        size: 50,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

// ====================================================================
// DOT
// ====================================================================

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '•',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 16,
        ),
      ),
    );
  }
}

// ====================================================================
// STATUS BADGE
// ====================================================================

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final normalizedStatus = status.toLowerCase();

    late final Color backgroundColor;
    late final Color borderColor;
    late final Color textColor;
    late final Color dotColor;

    switch (normalizedStatus) {
      // ==============================================================
      // CONFIRMED
      // ==============================================================

      case 'confirmed':
        backgroundColor = isDark
            ? AppColors.darkInfoBackground
            : AppColors.infoBackground;

        borderColor = isDark ? AppColors.darkInfo : AppColors.primary200;

        textColor = isDark ? AppColors.darkInfo : AppColors.infoDark;

        dotColor = textColor;
        break;

      // ==============================================================
      // PENDING
      // ==============================================================

      case 'pending':
        backgroundColor = isDark
            ? AppColors.darkWarningBackground
            : AppColors.warningBackground;

        borderColor = isDark ? AppColors.darkWarning : AppColors.warningLight;

        textColor = isDark ? AppColors.darkWarning : AppColors.warningDark;

        dotColor = textColor;
        break;

      // ==============================================================
      // COMPLETED
      // ==============================================================

      case 'completed':
        backgroundColor = isDark
            ? AppColors.darkSuccessBackground
            : AppColors.successBackground;

        borderColor = isDark ? AppColors.darkSuccess : AppColors.tertiary200;

        textColor = isDark ? AppColors.darkSuccess : AppColors.successDark;

        dotColor = textColor;
        break;

      // ==============================================================
      // CANCELLED
      // ==============================================================

      case 'cancelled':
      case 'canceled':
        backgroundColor = isDark
            ? AppColors.darkErrorBackground
            : AppColors.errorBackground;

        borderColor = isDark ? AppColors.darkError : AppColors.errorLight;

        textColor = isDark ? AppColors.darkError : AppColors.errorDark;

        dotColor = textColor;
        break;

      // ==============================================================
      // UNKNOWN
      // ==============================================================

      default:
        final colorScheme = Theme.of(context).colorScheme;

        backgroundColor = colorScheme.surfaceContainerHighest;
        borderColor = colorScheme.outlineVariant;
        textColor = colorScheme.onSurfaceVariant;
        dotColor = colorScheme.onSurfaceVariant;
    }
    final theme = Theme.of(context);
    return Container(
      height: 28.h,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        //border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),

          const SizedBox(width: 7),

          Text(
            status,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
            // style: TextStyle(
            //   fontSize: 13,
            //   fontWeight: FontWeight.w700,
            //   color: textColor,
            // ),
          ),
        ],
      ),
    );
  }
}
