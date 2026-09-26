import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/vehicle_card.dart';

class PopularCarsSection extends StatelessWidget {
  final List<Vehicle> vehicles;

  final VoidCallback? onSeeAll;
  final ValueChanged<Vehicle>? onVehicleTap;
  final ValueChanged<Vehicle>? onFavoriteTap;
  final ValueChanged<Vehicle>? onRentTap;

  // Owned by the caller so it can page the row in from the outside.
  final ScrollController? controller;

  // Shows a trailing spinner while the next page is being fetched.
  final bool isLoadingMore;

  const PopularCarsSection({
    super.key,
    required this.vehicles,
    this.onSeeAll,
    this.onVehicleTap,
    this.onFavoriteTap,
    this.onRentTap,
    this.controller,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show the section when there are no vehicles.
    if (vehicles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // ================================================================
        // HORIZONTAL VEHICLE LIST
        // ================================================================
        SizedBox(
          height: 270.h,
          child: ListView.separated(
            controller: controller,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),

            // The trailing slot is the "loading the next page" spinner.
            itemCount: vehicles.length + (isLoadingMore ? 1 : 0),

            separatorBuilder: (_, _) {
              return SizedBox(width: 14.w);
            },

            itemBuilder: (context, index) {
              if (index >= vehicles.length) {
                return SizedBox(
                  width: 60.w,
                  child: Center(
                    child: SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                );
              }

              final vehicle = vehicles[index];

              return SizedBox(
                width: 280.w,
                child: VehicleCard(
                  vehicle: vehicle,

                  onTap: () {
                    onVehicleTap?.call(vehicle);
                  },

                  onFavoriteTap: () {
                    onFavoriteTap?.call(vehicle);
                  },

                  onRentTap: () {
                    onRentTap?.call(vehicle);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
