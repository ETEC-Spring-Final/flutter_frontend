import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';

class HomeBannerSlider extends StatefulWidget {
  final VoidCallback? onExploreTap;

  const HomeBannerSlider({super.key, this.onExploreTap});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  // ============================================================
  // CONTROLLER
  // ============================================================

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  // ============================================================
  // CURRENT INDEX
  // ============================================================

  int _currentIndex = 0;

  // ============================================================
  // BANNERS
  // ============================================================

  final List<_BannerData> _banners = const [
    _BannerData(
      image:
          'https://i.pinimg.com/736x/66/64/0f/66640f4531df98d4d01085182e54aeac.jpg',
      badge: 'Special Offer',
      title: 'Weekend Special:\nUp to 20% OFF',
      description:
          'Premium vehicles for your perfect weekend getaway. Valid until Sunday.',
    ),

    _BannerData(
      image:
          'https://images.unsplash.com/photo-1553440569-bcc63803a83d?auto=format&fit=crop&w=1200&q=80',
      badge: 'Luxury Cars',
      title: 'Drive in Luxury\nWith Confidence',
      description:
          'Experience premium vehicles designed for comfort, style, and performance.',
    ),

    _BannerData(
      image:
          'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80',
      badge: 'New Arrival',
      title: 'Discover Your\nPerfect Ride',
      description:
          'Explore our latest vehicles and find the perfect car for your next journey.',
    ),

    _BannerData(
      image:
          'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?auto=format&fit=crop&w=1200&q=80',
      badge: 'Easy Rental',
      title: 'Rent Your Car\nIn Just Minutes',
      description:
          'Choose your favorite vehicle, select your dates, and start your journey.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ========================================================
        // SLIDER
        // ========================================================
        AspectRatio(
          //aspectRatio: AppDimensions.aspectRatioStandard,
          aspectRatio: AppDimensions.aspectRatioWide,
          child: CarouselSlider.builder(
            carouselController: _carouselController,

            itemCount: _banners.length,

            options: CarouselOptions(
              viewportFraction: 1.0,

              // Auto play
              autoPlay: true,

              autoPlayInterval: const Duration(seconds: 5),

              autoPlayAnimationDuration: const Duration(milliseconds: 800),

              autoPlayCurve: Curves.easeInOut,

              // Slider
              enlargeCenterPage: false,
              enableInfiniteScroll: true,

              // Page changed
              onPageChanged: (index, reason) {
                if (!mounted) return;

                setState(() {
                  _currentIndex = index;
                });
              },
            ),

            itemBuilder: (context, index, realIndex) {
              final banner = _banners[index];

              return SizedBox(
                width: double.infinity,
                height: double.infinity,

                child: _BannerCard(
                  banner: banner,
                  onExploreTap: widget.onExploreTap,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // ========================================================
        // INDICATORS
        // ========================================================
        _BannerIndicator(count: _banners.length, currentIndex: _currentIndex),
      ],
    );
  }
}

// ==================================================================
// BANNER CARD
// ==================================================================

class _BannerCard extends StatelessWidget {
  final _BannerData banner;
  final VoidCallback? onExploreTap;

  const _BannerCard({required this.banner, required this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: double.infinity,

      clipBehavior: Clip.antiAlias,

      decoration: BoxDecoration(
        color: AppColors.primary,

        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),

      child: Stack(
        fit: StackFit.expand,

        children: [
          // ======================================================
          // IMAGE
          // ======================================================
          Image.network(
            banner.image,

            fit: BoxFit.cover,

            filterQuality: FilterQuality.high,

            // ----------------------------------------------------
            // LOADING
            // ----------------------------------------------------
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }

              return Container(
                color: AppColors.primary,

                alignment: Alignment.center,

                child: const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              );
            },

            // ----------------------------------------------------
            // ERROR
            // ----------------------------------------------------
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.primary,

                alignment: Alignment.center,

                child: Icon(
                  Icons.image_not_supported_outlined,

                  size: AppDimensions.iconExtraLarge,

                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              );
            },
          ),

          // ======================================================
          // DARK GRADIENT
          // ======================================================
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: [
                  Colors.black.withValues(alpha: 0.15),

                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),

          // ======================================================
          // CONTENT
          // ======================================================
          Padding(
            padding: AppDimensions.cardContentPadding,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                // ==================================================
                // BADGE
                // ==================================================
                Container(
                  padding: AppDimensions.buttonPadding.copyWith(
                    top: 5,
                    bottom: 5,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.primary,

                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusCircular,
                    ),
                  ),

                  child: Text(
                    banner.badge.toUpperCase(),

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.white,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // ==================================================
                // TEXT
                // ==================================================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ------------------------------------------------
                    // TITLE
                    // ------------------------------------------------
                    Text(
                      banner.title,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: AppColors.white,

                        fontWeight: FontWeight.w800,

                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ------------------------------------------------
                    // DESCRIPTION
                    // ------------------------------------------------
                    Text(
                      banner.description,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),

                        height: 1.3,
                      ),
                    ),
                  ],
                ),

                // ==================================================
                // BUTTON
                // ==================================================
                FractionallySizedBox(
                  widthFactor: 0.45,

                  child: AspectRatio(
                    aspectRatio: 5,

                    child: Material(
                      color: AppColors.primary,

                      borderRadius: BorderRadius.circular(
                        AppDimensions.radius8,
                      ),

                      child: InkWell(
                        onTap: onExploreTap,

                        borderRadius: BorderRadius.circular(
                          AppDimensions.radius8,
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Text(
                              'Explore Now',

                              style: theme.textTheme.labelLarge?.copyWith(
                                color: AppColors.white,

                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(width: 4),

                            Icon(
                              Icons.arrow_forward_rounded,

                              size: AppDimensions.iconMedium,

                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// INDICATOR
// ==================================================================

class _BannerIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _BannerIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: List.generate(count, (index) {
        final bool isSelected = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),

          curve: Curves.easeOut,

          margin: const EdgeInsets.symmetric(horizontal: 3),

          width: isSelected ? 22 : 7,

          height: 7,

          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.25),

            borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
          ),
        );
      }),
    );
  }
}

// ==================================================================
// BANNER MODEL
// ==================================================================

class _BannerData {
  final String image;
  final String badge;
  final String title;
  final String description;

  const _BannerData({
    required this.image,
    required this.badge,
    required this.title,
    required this.description,
  });
}
