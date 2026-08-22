import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/feature/shared/widgets/favorite_toggle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/service/map_service.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  late bool isFavorite;
  late PageController _pageController;

  int currentImageIndex = 0;

  //final getLocationName = GetIt.instance<GetLocationName>();

  @override
  void initState() {
    super.initState();

    isFavorite = widget.vehicle.isFavorite;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vehicle = widget.vehicle;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // =====================================================================
      // BODY
      // =====================================================================
      body: CustomScrollView(
        slivers: [
          // ===================================================================
          // HERO IMAGE
          // ===================================================================
          SliverToBoxAdapter(child: _buildHero(context, vehicle)),

          // ===================================================================
          // CONTENT
          // ===================================================================
          SliverPadding(
            padding: AppDimensions.screenPadding,

            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),

                // ===========================================================
                // TITLE + PRICE
                // ===========================================================
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

                    const SizedBox(width: 12),

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

                const SizedBox(height: 10),

                // ===========================================================
                // RATING + TYPE
                // ===========================================================
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      '4.5',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(width: 4),

                    Text(
                      '(124 Reviews)',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Text(
                      vehicle.type,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ===========================================================
                // SPECIFICATIONS
                // ===========================================================
                Text(
                  'Specifications',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                _buildSpecifications(context, vehicle),

                const SizedBox(height: 28),

                // ===========================================================
                // DESCRIPTION
                // ===========================================================
                Text(
                  'Description',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  vehicle.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 28),

                // ===========================================================
                // FEATURES
                // ===========================================================
                Text(
                  'Features',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 14),

                _buildFeatures(context, vehicle),

                const SizedBox(height: 28),

                // ===========================================================
                // PICKUP LOCATION
                // ===========================================================
                Text(
                  'Location',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                /*

                const SizedBox(height: 12),

                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),

                    const SizedBox(width: 8),

                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pickup Location',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            '${vehicle.latitude.toStringAsFixed(4)}, '
                            '${vehicle.longitude.toStringAsFixed(4)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    
                  ],
                ),

                */
                const SizedBox(height: 14),

                // ===========================================================
                // MAP
                // ===========================================================
                _buildMapPreview(context, vehicle.latitude, vehicle.longitude),

                // ===========================================================
                // BOTTOM SPACE
                // ===========================================================
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),

      // =====================================================================
      // BOTTOM BOOKING BAR
      // =====================================================================
      bottomNavigationBar: _buildBottomBar(context, vehicle),
    );
  }

  // ===========================================================================
  // HERO
  // ===========================================================================

  Widget _buildHero(BuildContext context, Vehicle vehicle) {
    final colorScheme = Theme.of(context).colorScheme;

    if (vehicle.images.isEmpty) {
      return SizedBox(
        height: 340,
        child: Container(
          color: colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.directions_car_rounded,
            size: 70,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return SizedBox(
      height: 340,

      child: Stack(
        fit: StackFit.expand,

        children: [
          // ================================================================
          // IMAGE SLIDER
          // ================================================================
          CarouselSlider.builder(
            itemCount: vehicle.images.length,

            options: CarouselOptions(
              height: 340,

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
                        size: 60,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // ================================================================
          // GRADIENT
          // ================================================================
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

          // ================================================================
          // BACK
          // ================================================================
          Positioned(
            top: 42,
            left: 16,

            child: _circleButton(
              icon: Icons.arrow_back_rounded,

              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

          // ================================================================
          // SHARE
          // ================================================================
          /*
          Positioned(
            top: 42,
            right: 68,

            child: _circleButton(
              icon: Icons.share_rounded,

              onTap: () {
                // TODO: Share vehicle.
              },
            ),
          ),
          */

          // ================================================================
          // FAVORITE
          // ================================================================
          Positioned(
            top: 42,
            right: 16,
            child: FavoriteToggle(onFavoriteTap: () {}, vehicle: vehicle),
          ),
          /*
          Positioned(
            top: 42,
            right: 16,

            child: _circleButton(
              icon: isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,

              iconColor: isFavorite ? Colors.red : Colors.white,

              onTap: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ),

          */

          // ================================================================
          // IMAGE COUNTER
          // ================================================================
          Positioned(
            right: 16,
            bottom: 18,

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),

                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                '${currentImageIndex + 1}/${vehicle.images.length}',

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // ================================================================
          // PAGINATION
          // ================================================================
          Positioned(
            bottom: 21,
            left: 0,
            right: 0,

            child: _buildPagination(context, vehicle.images.length),
          ),
        ],
      ),
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

          margin: const EdgeInsets.symmetric(horizontal: 3),

          width: isSelected ? 22 : 7,
          height: 7,

          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.50),

            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
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

      //(icon: Icons.category_rounded, label: 'Type', value: vehicle.type),
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

      // (
      //   icon: Icons.directions_car_rounded,
      //   label: 'Brand',
      //   value: vehicle.brand,
      // ),
    ];

    return Container(
      //color: Colors.amber,
      child: GridView.builder(
        shrinkWrap: true,

        physics: const NeverScrollableScrollPhysics(),

        itemCount: specifications.length,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,

          crossAxisSpacing: 12,

          mainAxisSpacing: 12,

          childAspectRatio: 1.1,

          //childAspectRatio: AppDimensions.aspectRatioSquare,
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
                Icon(item.icon, size: 25, color: AppColors.primary),

                const SizedBox(height: 8),

                Text(
                  item.label,

                  textAlign: TextAlign.center,

                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 3),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),

                  child: Text(
                    item.value,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    textAlign: TextAlign.center,

                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
          color: colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Container(
      //color: Colors.amber,
      child: GridView.builder(
        shrinkWrap: true,

        physics: const NeverScrollableScrollPhysics(),

        itemCount: vehicle.feature.length,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,

          crossAxisSpacing: 12,

          mainAxisSpacing: 8,

          childAspectRatio: 3.5,
        ),

        itemBuilder: (context, index) {
          return Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,

                color: AppColors.primary,

                size: AppDimensions.iconMedium,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  vehicle.feature[index],

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,

                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      ),
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
      //future: getLocationName(latitude: latitude, longitude: longitude),
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

                  // =========================================================
                  // LOCATION NAME
                  // =========================================================
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,

                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),

                        borderRadius: BorderRadius.circular(
                          AppDimensions.radius8,
                        ),
                      ),

                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              'Pickup Location: '
                              '$locationName',

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

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
  // CIRCLE BUTTON
  // ===========================================================================

  Widget _circleButton({
    required IconData icon,

    required VoidCallback onTap,

    Color iconColor = Colors.white,
  }) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),

      shape: const CircleBorder(),

      child: InkWell(
        onTap: onTap,

        customBorder: const CircleBorder(),

        child: Padding(
          padding: const EdgeInsets.all(10),

          child: Icon(icon, size: 22, color: iconColor),
        ),
      ),
    );
  }

  // ===========================================================================
  // BOTTOM BAR
  // ===========================================================================

  Widget _buildBottomBar(BuildContext context, Vehicle vehicle) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),

      decoration: BoxDecoration(
        color: colorScheme.surface,

        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),

      child: SafeArea(
        top: false,

        child: Row(
          children: [
            // ================================================================
            // PRICE
            // ================================================================
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

                const SizedBox(height: 2),

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

            const SizedBox(width: 20),

            // ================================================================
            // BOOK NOW
            // ================================================================
            Expanded(
              child: SizedBox(
                height: 52,

                child: ElevatedButton(
                  onPressed: () {
                    // TODO:
                    // Navigate to booking screen.
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

                  child: const Text(
                    'Book Now',

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
