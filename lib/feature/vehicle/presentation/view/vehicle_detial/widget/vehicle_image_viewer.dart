import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/vehicle_detial/widget/image_viewer_arrow.dart';

class VehicleImageViewer extends StatefulWidget {
  final Vehicle vehicle;
  final int initialIndex;

  const VehicleImageViewer({
    super.key,
    required this.vehicle,
    required this.initialIndex,
  });

  @override
  State<VehicleImageViewer> createState() => _VehicleImageViewerState();
}

class _VehicleImageViewerState extends State<VehicleImageViewer> {
  late int currentIndex;

  final CarouselSliderController controller = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.vehicle.images;

    if (images.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.broken_image_rounded,
                  color: Colors.white,
                  size: 70,
                ),
              ),
              Positioned(
                top: 12.h,
                right: 16.w,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 26.r,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ===========================================================
            // MAIN IMAGE VIEWER
            // ===========================================================
            Center(
              child: CarouselSlider.builder(
                carouselController: controller,
                itemCount: images.length,
                options: CarouselOptions(
                  initialPage: widget.initialIndex,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: images.length > 1,
                  height: double.infinity,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    if (!mounted) return;

                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final image = images[index];

                  return SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Image.network(
                        image.fileUrl,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: Colors.white,
                              size: 70,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            // ===========================================================
            // CLOSE BUTTON
            // ===========================================================
            Positioned(
              top: 12.h,
              right: 16.w,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 26.r,
                  ),
                ),
              ),
            ),

            // ===========================================================
            // IMAGE COUNTER
            // ===========================================================
            Positioned(
              top: 20.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${currentIndex + 1} / ${images.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // ===========================================================
            // PREVIOUS BUTTON
            // ===========================================================
            if (images.length > 1)
              Positioned(
                left: 12.w,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (currentIndex > 0) {
                        controller.previousPage();
                      } else {
                        controller.animateToPage(images.length - 1);
                      }
                    },
                    child: const ImageViewerArrow(
                      icon: Icons.chevron_left_rounded,
                    ),
                  ),
                ),
              ),

            // ===========================================================
            // NEXT BUTTON
            // ===========================================================
            if (images.length > 1)
              Positioned(
                right: 12.w,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (currentIndex < images.length - 1) {
                        controller.nextPage();
                      } else {
                        controller.animateToPage(0);
                      }
                    },
                    child: const ImageViewerArrow(
                      icon: Icons.chevron_right_rounded,
                    ),
                  ),
                ),
              ),

            // ===========================================================
            // THUMBNAILS
            // ===========================================================
            if (images.length > 1)
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
                child: SizedBox(
                  height: 60.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: images.length,
                    separatorBuilder: (_, index) {
                      return SizedBox(width: 8.w);
                    },
                    itemBuilder: (context, index) {
                      final image = images[index];
                      final isSelected = index == currentIndex;

                      return GestureDetector(
                        onTap: () {
                          controller.animateToPage(index);

                          setState(() {
                            currentIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 72.w,
                          height: 58.h,
                          padding: EdgeInsets.all(isSelected ? 2.w : 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white.withValues(alpha: 0.7),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              image.fileUrl,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.medium,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade900,
                                  child: const Icon(
                                    Icons.broken_image_rounded,
                                    color: Colors.white54,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
