import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/feature/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/vehicle_detail_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/vehicle_card_explore.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // ------------------------------------------------------------
  // REFRESH FAVORITES
  // ------------------------------------------------------------

  Future<void> refreshData() async {
    context.read<FavoriteBloc>().add(const LoadFavoritesEvent());

    // Also reload vehicles in case the vehicle list changed.
    context.read<VehicleBloc>().add(const GetVehicles());
  }

  // ------------------------------------------------------------
  // GET FAVORITE VEHICLES
  // ------------------------------------------------------------

  List<Vehicle> _favoriteVehicles(List<Vehicle> vehicles, Set<int> ids) {
    return vehicles.where((vehicle) => ids.contains(vehicle.id)).toList();
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ======================================================
          // APP BAR
          // ======================================================
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

            backgroundColor: theme.scaffoldBackgroundColor,

            surfaceTintColor: Colors.transparent,

            titleSpacing: 16,
            centerTitle: false,

            title: Text(
              'Favorites',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // ======================================================
          // PULL TO REFRESH
          // ======================================================
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

          // ======================================================
          // FAVORITE VEHICLES
          // ======================================================
          SliverPadding(
            padding: EdgeInsets.all(AppDimensions.chipHorizontalPadding),

            sliver: BlocBuilder<VehicleBloc, VehicleState>(
              builder: (context, vehicleState) {
                // =================================================
                // VEHICLE LOADING
                // =================================================

                if (vehicleState is VehicleLoading) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // =================================================
                // VEHICLE ERROR
                // =================================================

                if (vehicleState is VehicleError) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          vehicleState.message,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }

                // =================================================
                // VEHICLE NOT LOADED
                // =================================================

                if (vehicleState is! VehicleLoaded) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('No vehicles available')),
                  );
                }

                // =================================================
                // FAVORITE BLOC
                // =================================================

                return BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, favoriteState) {
                    // ---------------------------------------------
                    // GET FAVORITE IDS
                    // ---------------------------------------------

                    final favoriteIds = favoriteState is FavoriteLoaded
                        ? favoriteState.favoriteIds
                        : <int>{};

                    // ---------------------------------------------
                    // FILTER VEHICLES
                    // ---------------------------------------------

                    final favoriteVehicles = _favoriteVehicles(
                      vehicleState.vehicles,
                      favoriteIds,
                    );

                    // =================================================
                    // NO FAVORITES
                    // =================================================

                    if (favoriteVehicles.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // -------------------------------
                              // ICON
                              // -------------------------------
                              Icon(
                                Icons.favorite_border_rounded,
                                size: 64.r,
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.5,
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // -------------------------------
                              // TITLE
                              // -------------------------------
                              Text(
                                'No favorites yet',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              SizedBox(height: 4.h),

                              // -------------------------------
                              // DESCRIPTION
                              // -------------------------------
                              Text(
                                'Tap the heart on any car '
                                'to save it here.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // =================================================
                    // FAVORITE VEHICLES LIST
                    // =================================================

                    return SliverList.builder(
                      itemCount: favoriteVehicles.length,

                      itemBuilder: (context, index) {
                        final vehicle = favoriteVehicles[index];

                        return VehicleCardExplore(
                          vehicle: vehicle,

                          // -----------------------------------------
                          // VEHICLE CLICK
                          // -----------------------------------------
                          onTap: () {
                            log(
                              'Selected: '
                              '${vehicle.brand} '
                              '${vehicle.model}',
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VehicleDetailScreen(vehicle: vehicle),
                              ),
                            );
                          },

                          // -----------------------------------------
                          // FAVORITE CLICK
                          // -----------------------------------------
                          onFavoriteTap: () {
                            log(
                              'Favorite tapped: '
                              '${vehicle.brand} '
                              '${vehicle.model}',
                            );

                            context.read<FavoriteBloc>().add(
                              ToggleFavoriteEvent(
                                vehicle.id,
                              ),
                            );
                          },
                        );
                      },
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
