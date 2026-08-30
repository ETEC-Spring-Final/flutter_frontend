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

  const PopularCarsSection({
    super.key,
    required this.vehicles,
    this.onSeeAll,
    this.onVehicleTap,
    this.onFavoriteTap,
    this.onRentTap,
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
          height: 300.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: vehicles.length,

            separatorBuilder: (_, _) {
              return SizedBox(width: 14.w);
            },

            itemBuilder: (context, index) {
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
