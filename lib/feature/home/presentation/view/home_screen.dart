import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/app/theme/app_size.dart';
import 'package:vehicle_rental_system/core/widgets/app_text_field.dart';

import 'package:vehicle_rental_system/feature/home/presentation/widgets/animated_greeting.dart';
import 'package:vehicle_rental_system/feature/home/presentation/widgets/home_banner_slider.dart';
import 'package:vehicle_rental_system/feature/home/presentation/widgets/popular_cars_section.dart';

import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle_category.dart';

import 'package:vehicle_rental_system/feature/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/rental_details_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/vehicle_detial/vehicle_detail_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/vehicle_card_explore.dart';

class HomeScreen extends StatefulWidget {
  final void Function(bool)? onExploreTap;
  final VoidCallback? onBookingTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onProfileTap;

  const HomeScreen({
    super.key,
    this.onExploreTap,
    this.onBookingTap,
    this.onFavoriteTap,
    this.onProfileTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ============================================================
  // CATEGORY
  // ============================================================

  // Index 0 = All
  // Index 1..n = categories
  int selectedCategoryIndex = 0;

  String get _selectedBrand {
    final index = selectedCategoryIndex - 1;

    if (index < 0 || index >= categories.length) {
      return '';
    }

    return categories[index].name;
  }

  // ============================================================
  // FILTER VEHICLES
  // ============================================================

  List<Vehicle> _filteredVehicles(List<Vehicle> vehicles) {
    final brand = _selectedBrand;

    // "All"
    if (brand.isEmpty) {
      return vehicles;
    }

    // Filter by brand
    return vehicles
        .where((vehicle) => vehicle.brand.toLowerCase() == brand.toLowerCase())
        .toList();
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    // Load vehicles from Spring Boot API
    context.read<VehicleBloc>().add(const GetVehicles());
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshData() async {
    context.read<VehicleBloc>().add(const GetVehicles());
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ========================================================
          // APP BAR
          // ========================================================
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

            title: const AnimatedGreeting(),

            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: widget.onProfileTap,
                  child: CircleAvatar(
                    radius: 18.r,
                    backgroundImage: const NetworkImage(
                      'https://i.pinimg.com/236x/0f/21/77/0f21770c1e42550d64e8c210266141d2.jpg',
                    ),
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ],
          ),

          // ========================================================
          // PULL TO REFRESH
          // ========================================================
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

          // ========================================================
          // HOME CONTENT
          // ========================================================
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.chipHorizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // SEARCH
                    // ==================================================
                    InkWell(
                      onTap: () {
                        widget.onExploreTap?.call(true);
                      },
                      child: AppTextField(
                        enabled: false,
                        hint: 'Search cars or brands..',
                        prefixIcon: Icons.search,
                        keyboardType: TextInputType.text,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // ==================================================
                    // BANNER
                    // ==================================================
                    HomeBannerSlider(
                      onExploreTap: () {
                        widget.onExploreTap?.call(false);
                      },
                    ),

                    SizedBox(height: 8.h),

                    // ==================================================
                    // BRAND CATEGORY
                    // ==================================================
                    SizedBox(
                      height: 55.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),

                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.space12,
                        ),

                        itemCount: categories.length + 1,

                        separatorBuilder: (_, _) {
                          return SizedBox(width: AppDimensions.space16);
                        },

                        itemBuilder: (context, index) {
                          // ==========================================
                          // ALL
                          // ==========================================

                          if (index == 0) {
                            return _CategoryItem(
                              title: 'All',
                              image: '',
                              isSelected: selectedCategoryIndex == 0,
                              onTap: () {
                                setState(() {
                                  selectedCategoryIndex = 0;
                                });

                                log('Filter: All');
                              },
                            );
                          }

                          // ==========================================
                          // BRAND
                          // ==========================================

                          final category = categories[index - 1];

                          return _CategoryItem(
                            title: category.name,
                            image: category.image,
                            isSelected: selectedCategoryIndex == index,
                            onTap: () {
                              setState(() {
                                selectedCategoryIndex = index;
                              });

                              log('Filter: ${category.name}');
                            },
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // ==================================================
                    // POPULAR CARS TITLE
                    // ==================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Popular Cars',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            letterSpacing: -0.4,
                            height: 1.2,
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            widget.onExploreTap?.call(false);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 36.w,
                            height: 36.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18.r,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    // ==================================================
                    // POPULAR CARS
                    // ==================================================
                    BlocBuilder<VehicleBloc, VehicleState>(
                      builder: (context, state) {
                        // ============================================
                        // LOADING
                        // ============================================

                        if (state is VehicleLoading) {
                          return const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        // ============================================
                        // ERROR
                        // ============================================

                        if (state is VehicleError) {
                          return _ErrorWidget(
                            message: state.message,
                            onRetry: () {
                              context.read<VehicleBloc>().add(
                                const GetVehicles(),
                              );
                            },
                          );
                        }

                        // ============================================
                        // LOADED
                        // ============================================

                        if (state is VehicleLoaded) {
                          final filteredVehicles = _filteredVehicles(
                            state.vehicles,
                          );

                          if (filteredVehicles.isEmpty) {
                            return _EmptyVehiclesWidget(brand: _selectedBrand);
                          }

                          return PopularCarsSection(
                            vehicles: filteredVehicles,

                            onSeeAll: () {
                              widget.onExploreTap?.call(false);
                            },

                            // ========================================
                            // VEHICLE TAP
                            // ========================================
                            onVehicleTap: (vehicle) {
                              log(
                                'Vehicle: '
                                '${vehicle.brand} '
                                '${vehicle.model}',
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return VehicleDetailScreen(
                                      vehicle: vehicle,
                                    );
                                  },
                                ),
                              );
                            },

                            // ========================================
                            // FAVORITE
                            // ========================================
                            onFavoriteTap: (vehicle) {
                              log(
                                'Favorite: '
                                '${vehicle.brand} '
                                '${vehicle.model}',
                              );

                              widget.onFavoriteTap?.call();
                            },

                            // ========================================
                            // RENT
                            // ========================================
                            onRentTap: (vehicle) {
                              log(
                                'Rent: '
                                '${vehicle.brand} '
                                '${vehicle.model}',
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return RentalDetailsScreen(
                                      vehicle: vehicle,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }

                        // ============================================
                        // INITIAL
                        // ============================================

                        return const SizedBox.shrink();
                      },
                    ),

                    SizedBox(height: 8.h),

                    // ==================================================
                    // RECOMMENDED TITLE
                    // ==================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recommended Cars for you',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            letterSpacing: -0.4,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),
                  ],
                ),
              ]),
            ),
          ),

          // ==========================================================
          // RECOMMENDED VEHICLES
          // ==========================================================
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.chipHorizontalPadding,
            ),
            sliver: SliverToBoxAdapter(
              child: BlocBuilder<VehicleBloc, VehicleState>(
                builder: (context, state) {
                  // ================================================
                  // LOADING
                  // ================================================

                  if (state is VehicleLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  // ================================================
                  // ERROR
                  // ================================================

                  if (state is VehicleError) {
                    return _ErrorWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<VehicleBloc>().add(const GetVehicles());
                      },
                    );
                  }

                  // ================================================
                  // LOADED
                  // ================================================

                  if (state is VehicleLoaded) {
                    final filteredVehicles = _filteredVehicles(state.vehicles);

                    if (filteredVehicles.isEmpty) {
                      return _EmptyVehiclesWidget(brand: _selectedBrand);
                    }

                    return Column(
                      children: filteredVehicles.map((vehicle) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: VehicleCardExplore(
                            vehicle: vehicle,

                            // ======================================
                            // VEHICLE TAP
                            // ======================================
                            onTap: () {
                              log(
                                'Recommended: '
                                '${vehicle.brand} '
                                '${vehicle.model}',
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return VehicleDetailScreen(
                                      vehicle: vehicle,
                                    );
                                  },
                                ),
                              );
                            },

                            // ======================================
                            // FAVORITE
                            // ======================================
                            onFavoriteTap: () {
                              log(
                                'Recommended favorite: '
                                '${vehicle.brand} '
                                '${vehicle.model}',
                              );

                              widget.onFavoriteTap?.call();
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),

          // ==========================================================
          // BOTTOM SPACE
          // ==========================================================
          SliverToBoxAdapter(child: SizedBox(height: 40.h)),
        ],
      ),
    );
  }
}

// ====================================================================
// CATEGORY ITEM
// ====================================================================

class _CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.title,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(AppDimensions.radius16),

        child: AspectRatio(
          aspectRatio: AppDimensions.aspectRatioSquare,

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),

            curve: Curves.easeOut,

            width: AppSize.w(context, 20),

            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.0)
                  : colorScheme.surface,

              borderRadius: BorderRadius.circular(AppDimensions.radius16),

              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.15),

                width: isSelected ? 1.5 : 1,
              ),

              boxShadow: [
                if (!isSelected)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radius16),

              child: image.isEmpty
                  // ==================================================
                  // ALL
                  // ==================================================
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.grid_view_rounded,

                            size: 22.r,

                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),

                          SizedBox(height: 4.h),

                          Text(
                            title,

                            textAlign: TextAlign.center,

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurface,

                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    )
                  // ==================================================
                  // CATEGORY IMAGE
                  // ==================================================
                  : Image.network(
                      image,

                      fit: BoxFit.cover,

                      filterQuality: FilterQuality.high,

                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported_outlined,
                          color: colorScheme.onSurfaceVariant,
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// EMPTY VEHICLES
// ====================================================================

class _EmptyVehiclesWidget extends StatelessWidget {
  final String brand;

  const _EmptyVehiclesWidget({required this.brand});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),

      child: Column(
        children: [
          Icon(
            Icons.no_crash_outlined,
            size: 48.r,
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),

          SizedBox(height: 12.h),

          Text(
            brand.isEmpty
                ? 'No vehicles available'
                : 'No $brand cars available',

            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),

            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// ERROR
// ====================================================================

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),

      child: Column(
        children: [
          Icon(Icons.error_outline, size: 44.r, color: theme.colorScheme.error),

          SizedBox(height: 8.h),

          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),

          SizedBox(height: 12.h),

          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
