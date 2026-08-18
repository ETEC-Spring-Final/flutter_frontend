import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/feature/home/presentation/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/home/presentation/widgets/vehicle_card.dart';

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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const SizedBox(height: 12),

        // ==========================================================
        // HORIZONTAL LIST
        // ==========================================================
        SizedBox(
          height: 375,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,

            physics: const BouncingScrollPhysics(),

            itemCount: vehicles.length,

            padding: EdgeInsets.zero,

            itemBuilder: (context, index) {
              final vehicle = vehicles[index];

              return SizedBox(
                width: 330,

                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == vehicles.length - 1
                        ? 0
                        : AppDimensions.space16,
                  ),

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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
