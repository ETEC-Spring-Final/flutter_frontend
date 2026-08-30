import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_back_button.dart';
import 'package:vehicle_rental_system/core/widgets/app_booking_bottom_bar.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/payment_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';

class AdditionalServicesScreen extends StatefulWidget {
  final Vehicle vehicle;

  final DateTime pickupDate;
  final DateTime returnDate;

  final TimeOfDay pickupTime;
  final TimeOfDay returnTime;

  final String pickupLocation;
  final String returnLocation;

  const AdditionalServicesScreen({
    super.key,
    required this.vehicle,
    required this.pickupDate,
    required this.returnDate,
    required this.pickupTime,
    required this.returnTime,
    required this.pickupLocation,
    required this.returnLocation,
  });

  @override
  State<AdditionalServicesScreen> createState() =>
      _AdditionalServicesScreenState();
}

class _AdditionalServicesScreenState extends State<AdditionalServicesScreen> {
  // ---------------------------------------------------------------------------
  // SERVICES
  // ---------------------------------------------------------------------------

  final Map<String, bool> selectedServices = {
    'Additional Driver': false,
    'GPS Navigation': false,
    'Child Seat': false,
    'Full Insurance': false,
  };

  final Map<String, double> servicePrices = {
    'Additional Driver': 10,
    'GPS Navigation': 5,
    'Child Seat': 8,
    'Full Insurance': 15,
  };

  // ---------------------------------------------------------------------------
  // PRICE CALCULATIONS
  // ---------------------------------------------------------------------------

  int get rentalDays {
    final days = widget.returnDate.difference(widget.pickupDate).inDays;

    return days <= 0 ? 1 : days;
  }

  double get rentalPrice {
    return widget.vehicle.pricePerDay * rentalDays;
  }

  double get servicesPrice {
    double total = 0;

    selectedServices.forEach((name, selected) {
      if (selected) {
        total += servicePrices[name]! * rentalDays;
      }
    });

    return total;
  }

  double get totalPrice {
    return rentalPrice + servicesPrice;
  }

  // ---------------------------------------------------------------------------
  // NAVIGATION
  // ---------------------------------------------------------------------------

  void _continueToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          vehicle: widget.vehicle,
          rentalDays: rentalDays,
          rentalPrice: rentalPrice,
          servicesPrice: servicesPrice,
          totalPrice: totalPrice,
          selectedServices: selectedServices,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      // -----------------------------------------------------------------------
      // APP BAR
      // -----------------------------------------------------------------------
      appBar: AppBar(
        title: const Text('Additional Services'),
        leading: Padding(padding: EdgeInsets.all(12.w), child: AppBackButton()),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios_new_rounded),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),

      // -----------------------------------------------------------------------
      // BODY
      // -----------------------------------------------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.chipHorizontalPadding,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),

              Text(
                'Enhance your rental experience',
                style: theme.textTheme.bodyMedium,
              ),

              SizedBox(height: 4.h),

              Text(
                'Choose optional add-ons.',
                style: theme.textTheme.bodySmall,
              ),

              SizedBox(height: 18.h),

              // -----------------------------------------------------------------
              // SERVICES
              // -----------------------------------------------------------------
              ...selectedServices.keys.map(
                (service) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _ServiceTile(
                    title: service,
                    price: servicePrices[service]!,
                    selected: selectedServices[service]!,
                    onChanged: (value) {
                      setState(() {
                        selectedServices[service] = value;
                      });
                    },
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // -----------------------------------------------------------------
              // ORDER SUMMARY
              // -----------------------------------------------------------------
              _OrderSummary(
                rentalPrice: rentalPrice,
                servicesPrice: servicesPrice,
                totalPrice: totalPrice,
                rentalDays: rentalDays,
              ),

              // Space at the bottom so content does not touch
              // the fixed bottom button.
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),

      // -----------------------------------------------------------------------
      // FIXED BOTTOM BUTTON
      // -----------------------------------------------------------------------
      bottomNavigationBar: AppBookingBottomBar(
        label: "Confirm Booking",
        icon: Icons.check_rounded,
        onPressed: _continueToPayment,
        enabled: true,
      ),
      // bottomNavigationBar: SafeArea(
      //   child: Padding(
      //     padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 12.h),
      //     child: SizedBox(
      //       width: double.infinity,
      //       height: 54.h,
      //       child: ElevatedButton(
      //         onPressed: _continueToPayment,

      //         style: ElevatedButton.styleFrom(
      //           elevation: 0,
      //           backgroundColor: theme.colorScheme.primary,
      //           foregroundColor: Colors.white,

      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(16.r),
      //           ),
      //         ),

      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             const Text(
      //               'Confirm Booking',
      //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      //             ),

      //             SizedBox(width: 8.w),

      //             const Icon(Icons.check_rounded, size: 18),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

// =============================================================================
// SERVICE TILE
// =============================================================================

class _ServiceTile extends StatelessWidget {
  final String title;
  final double price;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const _ServiceTile({
    required this.title,
    required this.price,
    required this.selected,
    required this.onChanged,
  });

  // ---------------------------------------------------------------------------
  // ICON
  // ---------------------------------------------------------------------------

  IconData get icon {
    switch (title) {
      case 'Additional Driver':
        return Icons.person_add_alt_1_outlined;

      case 'GPS Navigation':
        return Icons.gps_fixed_rounded;

      case 'Child Seat':
        return Icons.child_friendly_outlined;

      case 'Full Insurance':
        return Icons.shield_outlined;

      default:
        return Icons.add_circle_outline;
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () => onChanged(!selected),
        borderRadius: BorderRadius.circular(14.r),

        child: Container(
          padding: EdgeInsets.all(14.w),

          decoration: BoxDecoration(
            color: colors.surface,

            borderRadius: BorderRadius.circular(14.r),

            border: Border.all(
              color: selected ? colors.primary : colors.outlineVariant,

              width: selected ? 1.5 : 1,
            ),
          ),

          child: Row(
            children: [
              // ---------------------------------------------------------------
              // ICON
              // ---------------------------------------------------------------
              Container(
                width: 42.w,
                height: 42.w,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primaryContainer,
                ),

                child: Icon(icon, color: colors.primary),
              ),

              SizedBox(width: 12.w),

              // ---------------------------------------------------------------
              // SERVICE INFO
              // ---------------------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    Text(
                      '+\$${price.toStringAsFixed(0)}/day',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              // ---------------------------------------------------------------
              // CHECKBOX
              // ---------------------------------------------------------------
              Checkbox(
                value: selected,

                onChanged: (value) {
                  onChanged(value ?? false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// ORDER SUMMARY
// =============================================================================

class _OrderSummary extends StatelessWidget {
  final double rentalPrice;
  final double servicesPrice;
  final double totalPrice;
  final int rentalDays;

  const _OrderSummary({
    required this.rentalPrice,
    required this.servicesPrice,
    required this.totalPrice,
    required this.rentalDays,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,

      color: colors.surfaceContainerLow,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),

        side: BorderSide(color: colors.outlineVariant),
      ),

      child: Padding(
        padding: EdgeInsets.all(16.w),

        child: Column(
          children: [
            // -----------------------------------------------------------------
            // VEHICLE PRICE
            // -----------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vehicle ($rentalDays days)',
                  style: theme.textTheme.bodyMedium,
                ),

                Text(
                  '\$${rentalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // -----------------------------------------------------------------
            // SERVICES PRICE
            // -----------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Additional Services', style: theme.textTheme.bodyMedium),

                Text(
                  '\$${servicesPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            const Divider(height: 24),

            // -----------------------------------------------------------------
            // TOTAL
            // -----------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
