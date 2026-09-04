import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_empty.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/booking.dart';
import 'package:vehicle_rental_system/feature/booking/presentation/bloc/booking_bloc.dart';
import 'package:vehicle_rental_system/feature/booking/presentation/view/booking_detail_screen.dart';
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
    context.read<BookingBloc>().add(const LoadBookingsEvent(refresh: true));
  }

  /// Maps a UI category tab onto the booking statuses it should show.
  /// Returns `null` to represent "show all of the primary statuses".
  List<Booking> _filter(List<Booking> all) {
    switch (selectedCategory) {
      case 0: // Upcoming
        return all.where((b) => b.status == 'pending').toList();
      case 1: // Active
        return all.where((b) => b.status == 'confirmed').toList();
      case 2: // Complete
        return all.where((b) => b.status == 'completed').toList();
      case 3: // Cancelled
        return all.where((b) => b.status == 'cancelled').toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
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
            builder: (
              context,
              refreshState,
              pulledExtent,
              refreshTriggerPullDistance,
              refreshIndicatorExtent,
            ) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colorScheme.primary,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.10),
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
                separatorBuilder: (_, i) => const SizedBox(width: 32),
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
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
            sliver: BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                return switch (state) {
                  BookingLoading() => const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  BookingError() => SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 48.sp,
                              color: colorScheme.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.failure.message,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: refreshData,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  _ => _buildList(
                      theme,
                      _filter(
                        state is BookingLoaded ? state.bookings : const [],
                      ),
                    ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(ThemeData theme, List<Booking> items) {
    if (items.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: AppEmpty(
          icon: Icons.event_busy_rounded,
          message: 'No bookings in this category',
        ),
      );
    }

    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final booking = items[index];
        return BookingCard(
          booking: booking,
          onViewDetails: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingDetailScreen(booking: booking),
              ),
            );
          },
        );
      },
    );
  }
}
