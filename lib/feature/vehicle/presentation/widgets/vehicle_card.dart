import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/favorite_toggle.dart';
import 'package:vehicle_rental_system/core/widgets/app_badge.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onRentTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
    this.onFavoriteTap,
    this.onRentTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(AppDimensions.cardRadius),

      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,

          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          //   border: Border.all(
          //     color: colorScheme.outline.withValues(alpha: 0.10),
          //   ),
          // ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(4, 8),
                spreadRadius: 9,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================================================
              // IMAGE
              // ====================================================
              Hero(
                tag: vehicle,
                child: AspectRatio(
                  //aspectRatio: 1.87,
                  aspectRatio: AppDimensions.vehicleCardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // ------------------------------------------------
                      // CAR IMAGE
                      // ------------------------------------------------
                      Container(
                        width: double.infinity,
                        color: AppColors.secondary,
                        child: vehicle.images.isNotEmpty
                            ? Image.network(
                                vehicle.images.first,
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
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: colorScheme.surfaceContainerHighest,
                                    child: Icon(
                                      Icons.directions_car_outlined,
                                      size: 50,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: colorScheme.surfaceContainerHighest,
                                child: Icon(
                                  Icons.directions_car_outlined,
                                  size: 50,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                      ),

                      // ------------------------------------------------
                      // IMAGE GRADIENT
                      // ------------------------------------------------
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 80,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.5),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 8,
                        left: 8,
                        right: 8,
                        child: Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            // ------------------------------------------------
                            // TYPE
                            // ------------------------------------------------
                            AppBadge(label: vehicle.type),

                            // ------------------------------------------------
                            // FAVORITE
                            // ------------------------------------------------
                            FavoriteToggle(
                              onFavoriteTap: onFavoriteTap,
                              vehicle: vehicle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ====================================================
              // CONTENT
              // ====================================================
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =================================================
                    // BRAND
                    // =================================================

                    /*
                    Text(
                      vehicle.brand.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 3),

                      */

                    // =================================================
                    // MODEL
                    // =================================================
                    Row(
                      mainAxisAlignment: .spaceAround,
                      children: [
                        Text(
                          //vehicle.model,
                          '${vehicle.brand} ${vehicle.model}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        SizedBox(width: 10.w),

                        _SpecItem(
                          icon: Icons.settings_outlined,
                          text: vehicle.transmission,
                        ),

                        //const SizedBox(width: 8),
                        _SpecItem(
                          icon: Icons.local_gas_station_outlined,
                          text: vehicle.fuelType,
                        ),

                        //const SizedBox(width: 8),
                        _SpecItem(
                          icon: Icons.person_outline_rounded,
                          text: '${vehicle.seats}',
                        ),
                      ],
                    ),

                    //const SizedBox(height: 12),

                    // =================================================
                    // SPECS
                    // =================================================
                    // Row(
                    //   mainAxisAlignment: .spaceAround,
                    //   children: [
                    //     _SpecItem(
                    //       icon: Icons.settings_outlined,
                    //       text: vehicle.transmission,
                    //     ),

                    //     //const SizedBox(width: 8),
                    //     _SpecItem(
                    //       icon: Icons.local_gas_station_outlined,
                    //       text: vehicle.fuelType,
                    //     ),

                    //     //const SizedBox(width: 8),
                    //     _SpecItem(
                    //       icon: Icons.person_outline_rounded,
                    //       text: '${vehicle.seats}',
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 8),

                    // =================================================
                    // PRICE + RENT BUTTON
                    // =================================================
                    Row(
                      children: [
                        // ---------------------------------------------
                        // PRICE
                        // ---------------------------------------------
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Starting from',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),

                              const SizedBox(height: 2),

                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '\$${vehicle.pricePerDay.toStringAsFixed(0)}',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    TextSpan(
                                      text: ' / day',
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ---------------------------------------------
                        // RENT BUTTON
                        // ---------------------------------------------
                        SizedBox(
                          height: 45.h,
                          width: 120.w,
                          child: ElevatedButton(
                            onPressed: onRentTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radius8,
                                ),
                              ),
                            ),
                            child: const Text('Rent Now'),
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
    );
  }
}

// ==================================================================
// SPEC ITEM
// ==================================================================

class _SpecItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SpecItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),

          const SizedBox(width: 4),

          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
