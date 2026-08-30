import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_back_button.dart';
import 'package:vehicle_rental_system/core/widgets/favorite_toggle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/service/map_service.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/rental_details_screen.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  // ===========================================================================
  // STATE
  // ===========================================================================

  late bool isFavorite;

  int currentImageIndex = 0;

  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();

    isFavorite = widget.vehicle.isFavorite;
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

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
            leading: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Center(child: AppBackButton()),
            ),

            // ===================================================================
            // FAVORITE BUTTON
            // ===================================================================
            actions: [
              FavoriteToggle(onFavoriteTap: () {}, vehicle: vehicle),

              SizedBox(width: 14.w),
            ],

            // ===================================================================
            // HERO
            // ===================================================================
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,

              background: Hero(
                tag: vehicle,
                child: _buildHero(context, vehicle),
              ),
            ),
          ),

          // =====================================================================
          // CONTENT
          // =====================================================================
          SliverPadding(
            padding: AppDimensions.screenPadding,

            sliver: SliverList(
              delegate: SliverChildListDelegate([
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
                // RATING + TYPE
                // =================================================================
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 20.r,
                      color: colorScheme.primary,
                    ),

                    SizedBox(width: 6.w),

                    Text(
                      vehicle.rating.toStringAsFixed(1),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(width: 4.w),

                    Text(
                      '(124 Reviews)',
                      style: theme.textTheme.bodyMedium?.copyWith(
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
                      vehicle.type,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

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
                _buildFeatures(context, vehicle),

                SizedBox(height: 20.h),

                // =================================================================
                // LOCATION TITLE
                // =================================================================
                Text(
                  'Location',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 14.h),

                // =================================================================
                // MAP
                // =================================================================
                _buildMapPreview(context, vehicle.latitude, vehicle.longitude),

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
            final imageUrl = vehicle.images[index];

            debugPrint('IMAGE: $imageUrl');

            return SizedBox(
              width: double.infinity,

              child: Image.network(
                imageUrl,

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
                  debugPrint('IMAGE ERROR: $imageUrl');

                  debugPrint('ERROR: $error');

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
            );
          },
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
        // =====================================================================
        // TITLE
        // =====================================================================
        Text(
          'Description',

          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),

        SizedBox(height: 10.h),

        // =====================================================================
        // DESCRIPTION
        // =====================================================================
        AnimatedSize(
          duration: const Duration(milliseconds: 300),

          curve: Curves.easeInOut,

          child: GestureDetector(
            onTap: () {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },

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

        // =====================================================================
        // SHOW MORE / SHOW LESS
        // =====================================================================
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
        value: '${vehicle.luggage}',
      ),

      (
        icon: Icons.speed_rounded,
        label: 'Kilometer',
        value: '${vehicle.kilometer.toStringAsFixed(0)} km',
      ),
    ];

    return Column(
      children: [
        // =====================================================================
        // TITLE
        // =====================================================================
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

        // =====================================================================
        // GRID
        // =====================================================================
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

                border: Border.all(color: colorScheme.outline),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    item.icon,

                    size: 22.r,

                    color: colorScheme.onSurface.withValues(alpha: 0.8),
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
  // FEATURES
  // ===========================================================================

  Widget _buildFeatures(BuildContext context, Vehicle vehicle) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    if (vehicle.feature.isEmpty) {
      return Text(
        'No features available.',

        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,

          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Column(
      children: [
        // =====================================================================
        // TITLE
        // =====================================================================
        Row(
          children: [
            Text(
              'Features',

              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // =====================================================================
        // FEATURES GRID
        // =====================================================================
        GridView.builder(
          shrinkWrap: true,

          physics: const NeverScrollableScrollPhysics(),

          itemCount: vehicle.feature.length,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,

            crossAxisSpacing: 15,

            mainAxisSpacing: 8,

            childAspectRatio: 3.5,
          ),

          itemBuilder: (context, index) {
            return Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,

                  color: AppColors.primary,

                  size: AppDimensions.iconMedium,
                ),

                SizedBox(width: 8.w),

                Expanded(
                  child: Text(
                    vehicle.feature[index],

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,

                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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

                    foregroundColor: Colors.white,

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
