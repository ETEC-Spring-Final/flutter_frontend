import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/booking.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/vehicle_detail_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/booking_card.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedCategory = 0;
  static const List<String> bookingCategories = [
    "Upcoming",
    "Active",
    "Complete",
    "Cancelled",
  ];

  Future<void> refreshData() async {
    /*
  context.read<VehicleBloc>().add(
    const GetVehiclesEvent(
      refresh: true,
    ),
  );
  */
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      //appBar: AppAppBar(title: "Bookings"),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,

            // Hide when scrolling down
            floating: true,

            // Show immediately when scrolling up
            snap: true,

            // Don't stay pinned
            pinned: false,

            elevation: 0,

            scrolledUnderElevation: 0,

            backgroundColor: Theme.of(context).scaffoldBackgroundColor,

            surfaceTintColor: Colors.transparent,

            titleSpacing: 16,
            centerTitle: false,
            title: Text(
              "All booking",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          CupertinoSliverRefreshControl(
            onRefresh: refreshData,

            refreshTriggerPullDistance: 90,
            refreshIndicatorExtent: 56,
            builder:
                (
                  context,
                  refreshState,
                  pulledExtent,
                  refreshTriggerPullDistance,
                  refreshIndicatorExtent,
                ) {
                  final colorScheme = Theme.of(context).colorScheme;

                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,

                      color: colorScheme.primary,

                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.10,
                      ),
                    ),
                  );
                },
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 30.h,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: bookingCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 32),
                itemBuilder: (context, index) {
                  final isSelected = selectedCategory == index;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = index;
                          log(bookingCategories[index]);
                        });
                      },
                      child: IntrinsicWidth(
                        child: SizedBox(
                          height: 30.h,
                          child: Column(
                            mainAxisSize: .min,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                style: theme.textTheme.titleSmall!.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,

                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurface,
                                ),
                                child: Text(bookingCategories[index]),
                              ),

                              const Spacer(),

                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                opacity: isSelected ? 1.0 : 0,
                                child: Container(
                                  height: 2.5,
                                  width: double.infinity,

                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsetsGeometry.all(
              AppDimensions.chipHorizontalPadding,
            ),
            sliver: SliverList.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return BookingCard(
                  booking: booking,
                  onViewDetails: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleDetailScreen(
                          vehicle: bookings[index].vehicle,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
