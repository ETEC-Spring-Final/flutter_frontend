import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_back_button.dart';
import 'package:vehicle_rental_system/core/widgets/favorite_toggle.dart';
import 'package:vehicle_rental_system/feature/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/service/map_service.dart';
import 'package:vehicle_rental_system/feature/rental/presentation/view/rental_details_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/vehicle_detail/vehicle_image_thumbnails.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/vehicle_detail/vehicle_image_viewer.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/vehicle_card.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/vehicle_unavailable_days.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;

  /// All available vehicles.
  ///
  /// Vehicles with the same type/category as the current
  /// vehicle will be displayed as recommendations.
  final List<Vehicle> recommendedVehicles;

  const VehicleDetailScreen({
    super.key,
    required this.vehicle,
    this.recommendedVehicles = const [],
  });

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  // ===========================================================================
  // STATE
  // ===========================================================================

  int currentImageIndex = 0;

  bool _isDescriptionExpanded = false;

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  void _showImageViewer(
    BuildContext context,
    Vehicle vehicle,
    int initialIndex,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (_) {
        return VehicleImageViewer(vehicle: vehicle, initialIndex: initialIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vehicle = widget.vehicle;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // =========================================================================
      // BODY
      // =========================================================================
      body: CustomScrollView(
        slivers: [
          // =====================================================================
          // APP BAR + HERO IMAGE
          // =====================================================================
          SliverAppBar(
            expandedHeight: 340.h,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: colorScheme.surface,
            automaticallyImplyLeading: false,

            // ===================================================================
            // BACK BUTTON
            // ===================================================================
            leading: AppBackButton(),

            // leading: Padding(
            //   padding: EdgeInsets.all(5.w),
            //   child: const Center(child: AppBackButton()),
            // ),

            // ===================================================================
            // FAVORITE BUTTON
            // ===================================================================
            actions: [
              FavoriteToggle(
                onFavoriteTap: () {
                  context.read<FavoriteBloc>().add(
                    ToggleFavoriteEvent(vehicle.id),
                  );
                },
                vehicle: vehicle,
              ),
              SizedBox(width: 12.w),
            ],

            // ===================================================================
            // HERO IMAGE
            // ===================================================================
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Hero(
                tag: vehicle.id,
                child: _buildHero(context, vehicle),
              ),
            ),
          ),

          // =========================================================================
          // CONTENT
          // =========================================================================
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.chipHorizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 10.h),
                // =================================================================
                // TITLE + PRICE
                // =================================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${vehicle.brand} ${vehicle.model}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$${vehicle.pricePerDay.toStringAsFixed(0)}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 26,
                            ),
                          ),
                          TextSpan(
                            text: ' / day',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                // =================================================================
                // TYPE
                // =================================================================
                Row(
                  children: [
                    Icon(
                      Icons.directions_car_rounded,
                      size: 20.r,
                      color: colorScheme.primary,
                    ),

                    SizedBox(width: 6.w),

                    Text(
                      vehicle.type,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Text(
                      '${vehicle.yearOfManufacture}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Text(
                      vehicle.color,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // =================================================================
                // UNAVAILABLE DAYS
                // =================================================================
                VehicleUnavailableDays(vehicle: vehicle),

                // =================================================================
                // SPECIFICATIONS
                // =================================================================
                SizedBox(height: 16.h),
                _buildSpecifications(context, vehicle),

                SizedBox(height: 28.h),

                // =================================================================
                // DESCRIPTION
                // =================================================================
                _buildDescription(context, vehicle),

                SizedBox(height: 20.h),

                // =================================================================
                // FEATURES
                // =================================================================

                // Your new backend Vehicle entity does not contain `feature`.
                // So this section is removed for now.

                // =================================================================
                // LOCATION
                // =================================================================
                Text(
                  'Location',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 14.h),

                // Your new Vehicle entity does not contain latitude/longitude.
                //
                // If you add latitude and longitude to the backend later,
                // you can enable:
                //
                // _buildMapPreview(
                //   context,
                //   vehicle.latitude,
                //   vehicle.longitude,
                // ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.cardRadius,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: 24.r,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          'Vehicle location will be available soon.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // =================================================================
                // RECOMMENDED VEHICLES
                // =================================================================
                SizedBox(height: 28.h),

                _buildRecommendedVehicles(context, vehicle),

                // =================================================================
                // BOTTOM SPACE
                // =================================================================
                SizedBox(height: 100.h),
              ]),
            ),
          ),
        ],
      ),

      // =========================================================================
      // FIXED BOTTOM BOOKING BAR
      // =========================================================================
      bottomNavigationBar: _buildBottomBar(context, vehicle),
    );
  }

  // ===========================================================================
  // HERO
  // ===========================================================================

  Widget _buildHero(BuildContext context, Vehicle vehicle) {
    final colorScheme = Theme.of(context).colorScheme;

    if (vehicle.images.isEmpty) {
      return Container(
        color: colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.directions_car_rounded,
            size: 70.r,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // =====================================================================
        // IMAGE SLIDER
        // =====================================================================
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: vehicle.images.length,
          options: CarouselOptions(
            height: double.infinity,
            viewportFraction: 1.0,
            enableInfiniteScroll: vehicle.images.length > 1,
            autoPlay: vehicle.images.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 700),
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                currentImageIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final image = vehicle.images[index];

            return GestureDetector(
              onTap: () {
                _showImageViewer(context, vehicle, index);
              },
              child: SizedBox(
                width: double.infinity,
                child: Image.network(
                  image.fileUrl,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.broken_image_rounded,
                        size: 60.r,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),

        // =====================================================================
        // CAR GALLERY THUMBNAILS
        // =====================================================================
        if (vehicle.images.length > 1)
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 52.h,
            child: VehicleImageThumbnails(
              vehicle: vehicle,
              currentImageIndex: currentImageIndex,
              onImageSelected: (index) {
                _carouselController.animateToPage(index);

                setState(() {
                  currentImageIndex = index;
                });
              },
            ),
          ),

        // =====================================================================
        // GRADIENT
        // =====================================================================
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.45),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.40),
                  ],
                ),
              ),
            ),
          ),
        ),

        // =====================================================================
        // IMAGE COUNTER
        // =====================================================================
        Positioned(
          right: 16.w,
          bottom: 18.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '${currentImageIndex + 1}/${vehicle.images.length}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        // =====================================================================
        // PAGINATION
        // =====================================================================
        Positioned(
          bottom: 21.h,
          left: 0,
          right: 0,
          child: _buildPagination(context, vehicle.images.length),
        ),
      ],
    );
  }

  // ===========================================================================
  // IMAGE THUMBNAILS
  // ===========================================================================

  // ===========================================================================
  // PAGINATION
  // ===========================================================================

  Widget _buildPagination(BuildContext context, int count) {
    if (count <= 1) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isSelected = index == currentImageIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: isSelected ? 22.w : 7.w,
          height: 7.h,
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.50),
            borderRadius: BorderRadius.circular(20.r),
          ),
        );
      }),
    );
  }

  // ===========================================================================
  // DESCRIPTION
  // ===========================================================================

  Widget _buildDescription(BuildContext context, Vehicle vehicle) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool showButton = vehicle.description.length > 150;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),

        SizedBox(height: 10.h),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: GestureDetector(
            onTap: showButton
                ? () {
                    setState(() {
                      _isDescriptionExpanded = !_isDescriptionExpanded;
                    });
                  }
                : null,
            child: Text(
              vehicle.description,
              maxLines: _isDescriptionExpanded ? null : 3,
              overflow: _isDescriptionExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),

        if (showButton) ...[
          SizedBox(height: 6.h),

          GestureDetector(
            onTap: () {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isDescriptionExpanded ? 'Show less' : 'Show more',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(width: 4.w),

                AnimatedRotation(
                  turns: _isDescriptionExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20.r,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ===========================================================================
  // SPECIFICATIONS
  // ===========================================================================

  Widget _buildSpecifications(BuildContext context, Vehicle vehicle) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final specifications = [
      (
        icon: Icons.settings_rounded,
        label: 'Transmission',
        value: vehicle.transmission,
      ),
      (
        icon: Icons.local_gas_station_rounded,
        label: 'Fuel',
        value: vehicle.fuelType,
      ),
      (
        icon: Icons.airline_seat_recline_normal_rounded,
        label: 'Seats',
        value: '${vehicle.seats}',
      ),
      (
        icon: Icons.door_front_door_rounded,
        label: 'Doors',
        value: '${vehicle.doors}',
      ),
      (
        icon: Icons.luggage_rounded,
        label: 'Luggage',
        value: '${vehicle.luggages}',
      ),
      (
        icon: Icons.speed_rounded,
        label: 'Kilometer',
        value: '${vehicle.mileAge} km',
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Text(
              'Specifications',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: specifications.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final item = specifications[index];

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                border: Border.all(
                  color: colorScheme.outline,
                  //color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: 22.r,
                    //color: colorScheme.onSurface.withValues(alpha: 0.8),
                    color: AppColors.primary,
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      item.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                        //color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // MAP PREVIEW
  // ===========================================================================

  Widget _buildMapPreview(
    BuildContext context,
    double latitude,
    double longitude,
  ) {
    final location = LatLng(latitude, longitude);

    return FutureBuilder<String>(
      future: MapService.getLocationName(latitude, longitude),
      builder: (context, snapshot) {
        final locationName = snapshot.data ?? 'Loading location...';

        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outline),
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          ),
          child: AspectRatio(
            aspectRatio: AppDimensions.vehicleCardAspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
              child: Stack(
                children: [
                  // =============================================================
                  // MAP
                  // =============================================================
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: location,
                      initialZoom: 15,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'com.example.vehicle_rental_system',
                      ),

                      MarkerLayer(
                        markers: [
                          Marker(
                            point: location,
                            width: 40,
                            height: 40,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // =============================================================
                  // LOCATION NAME
                  // =============================================================
                  Positioned(
                    left: 12.w,
                    right: 12.w,
                    bottom: 12.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),

                          SizedBox(width: 8.w),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Pickup location',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),

                                Text(
                                  locationName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.black45,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // =============================================================
                  // OPEN GOOGLE MAPS
                  // =============================================================
                  GestureDetector(
                    onTap: () {
                      MapService.openGoogleMaps(latitude, longitude);
                    },
                    child: Container(color: Colors.transparent),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // RECOMMENDED VEHICLES
  // ===========================================================================

  Widget _buildRecommendedVehicles(
    BuildContext context,
    Vehicle currentVehicle,
  ) {
    final theme = Theme.of(context);

    // ---------------------------------------------------------------
    // Get all vehicles.
    //
    // If recommendedVehicles was passed from the previous screen,
    // use it.
    //
    // Otherwise get vehicles from VehicleBloc.
    // ---------------------------------------------------------------

    final vehicleState = context.read<VehicleBloc>().state;

    final List<Vehicle> allVehicles;

    if (widget.recommendedVehicles.isNotEmpty) {
      allVehicles = widget.recommendedVehicles;
    } else if (vehicleState is VehicleLoaded) {
      allVehicles = vehicleState.vehicles;
    } else {
      allVehicles = [];
    }

    // ---------------------------------------------------------------
    // Find vehicles with the same type.
    // ---------------------------------------------------------------

    final recommendedVehicles = allVehicles
        .where(
          (vehicle) =>
              vehicle.id != currentVehicle.id &&
              vehicle.type.toLowerCase().trim() ==
                  currentVehicle.type.toLowerCase().trim(),
        )
        .take(5)
        .toList();

    // ---------------------------------------------------------------
    // No recommendations.
    // ---------------------------------------------------------------

    if (recommendedVehicles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ================================================================
        // TITLE
        // ================================================================
        Text(
          'Recommended ${currentVehicle.type}s',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),

        SizedBox(height: 6.h),

        Text(
          'Other ${currentVehicle.type} vehicles you may like',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        SizedBox(height: 14.h),

        // ================================================================
        // HORIZONTAL VEHICLE LIST
        // ================================================================
        SizedBox(
          height: 300.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: recommendedVehicles.length,
            separatorBuilder: (context, index) {
              return SizedBox(width: 14.w);
            },
            itemBuilder: (context, index) {
              final recommendedVehicle = recommendedVehicles[index];

              return SizedBox(
                width: 280.w,
                child: VehicleCard(
                  vehicle: recommendedVehicle,

                  // ------------------------------------------------------
                  // VEHICLE TAP
                  // ------------------------------------------------------
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleDetailScreen(
                          vehicle: recommendedVehicle,
                          recommendedVehicles: allVehicles,
                        ),
                      ),
                    );
                  },

                  // ------------------------------------------------------
                  // FAVORITE TAP
                  // ------------------------------------------------------
                  onFavoriteTap: () {
                    // Connect to FavoriteBloc here.
                  },

                  // ------------------------------------------------------
                  // RENT TAP
                  // ------------------------------------------------------
                  onRentTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RentalDetailsScreen(vehicle: recommendedVehicle),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // BOTTOM BOOKING BAR
  // ===========================================================================

  Widget _buildBottomBar(BuildContext context, Vehicle vehicle) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 12.h),
      decoration: BoxDecoration(color: colorScheme.surface),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // =================================================================
            // PRICE
            // =================================================================
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                SizedBox(height: 2.h),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\$${vehicle.pricePerDay.toStringAsFixed(0)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      TextSpan(
                        text: ' / day',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(width: 20.w),

            // =================================================================
            // RENT NOW
            // =================================================================
            Expanded(
              child: SizedBox(
                height: 45.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RentalDetailsScreen(vehicle: vehicle),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radius12,
                      ),
                    ),
                  ),
                  child: Text(
                    'Rent Now',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
