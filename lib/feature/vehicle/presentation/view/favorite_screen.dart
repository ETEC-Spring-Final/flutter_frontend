import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/feature/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/vehicle_detail_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/vehicle_card_explore.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Future<void> refreshData() async {
    context.read<FavoriteBloc>().add(const LoadFavoritesEvent());
  }

  List<Vehicle> _favoriteVehicles(Set<int> ids) {
    return vehicles.where((v) => ids.contains(v.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      //appBar: AppAppBar(title: "Favorites")
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
              "Favorites",
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

          SliverPadding(
            padding: EdgeInsetsGeometry.all(
              AppDimensions.chipHorizontalPadding,
            ),
            sliver: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                final ids = state is FavoriteLoaded
                    ? state.favoriteIds
                    : const <int>{};

                final favoriteVehicles = _favoriteVehicles(ids);

                if (favoriteVehicles.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 64.r,
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.5),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "No favorites yet",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Tap the heart on any car to save it here.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList.builder(
                  itemCount: favoriteVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = favoriteVehicles[index];
                    return VehicleCardExplore(
                      vehicle: vehicle,
                      onTap: () {
                        log('Selected: ${vehicle.brand} ${vehicle.model}');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VehicleDetailScreen(vehicle: vehicle),
                          ),
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
