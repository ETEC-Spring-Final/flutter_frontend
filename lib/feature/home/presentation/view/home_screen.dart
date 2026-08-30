import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/app/theme/app_size.dart';
import 'package:vehicle_rental_system/core/widgets/app_text_field.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle_category.dart';
import 'package:vehicle_rental_system/feature/home/presentation/widgets/animated_greeting.dart';
import 'package:vehicle_rental_system/feature/home/presentation/widgets/home_banner_slider.dart';
import 'package:vehicle_rental_system/feature/home/presentation/widgets/popular_cars_section.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/rental_details_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/vehicle_detail_screen.dart';
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
  // Index 0 represents "All", the rest map to `categories` (brands).
  int selectedCategoryIndex = 0;

  String get _selectedBrand {
    final index = selectedCategoryIndex - 1;
    if (index < 0 || index >= categories.length) return '';
    return categories[index].name;
  }

  List<Vehicle> get _filteredVehicles {
    final brand = _selectedBrand;
    if (brand.isEmpty) return vehicles;
    return vehicles.where((v) => v.brand == brand).toList();
  }

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
    // final viewAllStyle = theme.textTheme.labelMedium?.copyWith(
    //   color: AppColors.primary,
    // );
    final colorScheme = theme.colorScheme;
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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

            title: const AnimatedGreeting(),

            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),

                child: InkWell(
                  onTap: widget.onProfileTap,
                  child: CircleAvatar(
                    radius: 18.r,

                    backgroundImage: const NetworkImage(
                      "https://i.pinimg.com/236x/0f/21/77/0f21770c1e42550d64e8c210266141d2.jpg",
                    ),

                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ],
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
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: AppDimensions.chipHorizontalPadding,
            ),

            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    // Text("Hello, Visal 👋", style: theme.textTheme.titleLarge),
                    // Text(
                    //   "Ready for your next journey?",
                    //   style: theme.textTheme.bodyMedium,
                    // ),
                    //AnimatedGreeting(),
                    //SizedBox(height: 4.h),

                    // Search field
                    InkWell(
                      onTap: () => widget.onExploreTap?.call(true),
                      child: AppTextField(
                        enabled: false,

                        hint: "Search cars or brands..",
                        prefixIcon: Icons.search,
                        keyboardType: TextInputType.text,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Banner
                    HomeBannerSlider(
                      onExploreTap: () => widget.onExploreTap?.call(false),
                    ),

                    //const SizedBox(height: AppDimensions.space12),
                    /*
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          "Choose By brand",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: .bold,
                          ),
                        ),
                        InkWell(
                          onTap: () => widget.onExploreTap?.call(false),
                          child: Text("View All", style: viewAllStyle),
                        ),
                      ],
                    ),

                    */
                    SizedBox(height: 8.h),

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
                          // Index 0 = "All", indices 1..n map to categories.
                          if (index == 0) {
                            return _CategoryItem(
                              title: 'All',
                              image: '',
                              isSelected: selectedCategoryIndex == 0,
                              onTap: () {
                                setState(() => selectedCategoryIndex = 0);
                                log('Filter: All');
                              },
                            );
                          }

                          final category = categories[index - 1];

                          return _CategoryItem(
                            title: category.name,
                            image: category.image,
                            isSelected: selectedCategoryIndex == index,
                            onTap: () {
                              setState(() {
                                selectedCategoryIndex = index;
                                log(category.name);
                              });
                            },
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          "Popular Cars",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: .bold,
                            fontSize: 18.sp,
                            //fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            height: 1.2,
                          ),
                        ),

                        InkWell(
                          onTap: () => widget.onExploreTap?.call(false),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 36.w,
                            height: 36.h,
                            decoration: BoxDecoration(
                              //color: colorScheme.surface,
                              color: Colors.white.withValues(alpha: 0.92),
                              shape: BoxShape.circle,
                              // border: Border.all(
                              //   color: AppColors.primary,
                              //   width: 1.5.w,
                              // ),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18.r,
                              color: AppColors.primary,
                              fontWeight: .bold,
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () => widget.onExploreTap?.call(false),
                        //   child: Text("View All", style: viewAllStyle),
                        // ),
                      ],
                    ),

                    PopularCarsSection(
                      vehicles: _filteredVehicles,

                      onSeeAll: () => widget.onExploreTap,

                      onVehicleTap: (vehicle) {
                        log('Vehicle: ${vehicle.brand} ${vehicle.model}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VehicleDetailScreen(vehicle: vehicle),
                          ),
                        );
                      },

                      onFavoriteTap: (vehicle) {
                        log('Favorite: ${vehicle.brand}');
                      },

                      onRentTap: (vehicle) {
                        log('Rent: ${vehicle.brand} ${vehicle.model}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RentalDetailsScreen(vehicle: vehicle),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 8.h),

                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          "Recommended Cars for you",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: .bold,
                            fontSize: 18.sp,
                            //fontWeight: FontWeight.w800,
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

          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.chipHorizontalPadding,
            ),

            sliver: SliverList(
              delegate: SliverChildListDelegate(
                _filteredVehicles.isEmpty
                    ? [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: Column(
                            children: [
                              Icon(
                                Icons.no_crash_outlined,
                                size: 48.r,
                                color: colorScheme.outline.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'No $_selectedBrand cars available',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ]
                    : _filteredVehicles.map((vehicle) {
                        return VehicleCardExplore(
                          vehicle: vehicle,

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
                                  return VehicleDetailScreen(vehicle: vehicle);
                                },
                              ),
                            );
                          },

                          onFavoriteTap: () {
                            log(
                              'Recommended favorite: '
                              '${vehicle.brand} '
                              '${vehicle.model}',
                            );
                          },
                        );
                      }).toList(),
              ),
            ),
          ),

          // ============================================================
          // BOTTOM SPACE
          // ============================================================
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40.h,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

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
