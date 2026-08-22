import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/app/theme/app_size.dart';
import 'package:vehicle_rental_system/core/widgets/app_text_field.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle_category.dart';
import 'package:vehicle_rental_system/feature/home/presentation/widgets/animated_greeting.dart';
import 'package:vehicle_rental_system/feature/home/presentation/widgets/home_banner_slider.dart';
import 'package:vehicle_rental_system/feature/home/presentation/widgets/popular_cars_section.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/vehicle_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onExploreTap;
  final VoidCallback? onBookingTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onProfileTap;
  const HomeScreen({
    super.key,
    required this.onExploreTap,
    required this.onBookingTap,
    required this.onFavoriteTap,
    required this.onProfileTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;

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
                    radius: 20,

                    backgroundImage: const NetworkImage(
                      "https://scontent.fpnh2-2.fna.fbcdn.net/v/t39.30808-6/491968431_1333977137906097_3745547215927394055_n.jpg?stp=dst-jpg_tt6&cstp=mx970x960&ctp=s970x960&_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGX2jXOvNyFkMdU_nHv0_TBLC6QkSp9leUsLpCRKn2V5Uv6wof_Vu5Xc0cjDDFK8I_KxOLFewIUlVXw94akzmKm&_nc_ohc=28p1SuhBkPwQ7kNvwGT5yx6&_nc_oc=AdrUW13_mAxCDkK_fOI2s8--AA2xyqLU9DXhRp2uEMYLB12LE_V1B0Jowg_7Y3R4qAo&_nc_zt=23&_nc_ht=scontent.fpnh2-2.fna&_nc_gid=s_fbaJLoBIWod-PWjdIzRA&_nc_ss=7b2a8&oh=00_AQGN5_K1c1NL_vzQZLKregsB4kTjJFJsv772ceprkaPguA&oe=6A8A8437",
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
                    const SizedBox(height: AppDimensions.space4),

                    // Search field
                    InkWell(
                      onTap: widget.onExploreTap,
                      child: AppTextField(
                        enabled: false,

                        hint: "Search cars or brands..",
                        prefixIcon: Icons.search,
                        keyboardType: TextInputType.text,
                      ),
                    ),

                    const SizedBox(height: AppDimensions.space12),

                    // Banner
                    HomeBannerSlider(onExploreTap: widget.onExploreTap),

                    //const SizedBox(height: AppDimensions.space12),
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
                          onTap: widget.onExploreTap,
                          child: Text(
                            "View All",
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.space10),

                    SizedBox(
                      height: AppSize.h(context, 8),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.space16,
                        ),
                        itemCount: categories.length,
                        separatorBuilder: (_, __) {
                          return SizedBox(width: AppDimensions.space12);
                        },
                        itemBuilder: (context, index) {
                          final category = categories[index];

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
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          "Popular Cars",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: .bold,
                          ),
                        ),
                        InkWell(
                          onTap: widget.onExploreTap,
                          child: Text(
                            "View All",
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                      ],
                    ),
                    PopularCarsSection(
                      vehicles: vehicles,

                      onSeeAll: widget.onExploreTap,

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
                      },
                    ),
                  ],
                ),
              ]),
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

            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.network(
                image,
                fit: BoxFit.contain,
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
