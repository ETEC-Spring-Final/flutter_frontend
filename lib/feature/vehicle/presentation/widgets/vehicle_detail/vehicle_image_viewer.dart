import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/vehicle_detail/image_viewer_arrow.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/vehicle_detail/vehicle_image_thumbnails.dart';

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
  late int currentImageIndex;

  final CarouselSliderController controller = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    currentImageIndex = widget.initialIndex;
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
                      currentImageIndex = index;
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
                    '${currentImageIndex + 1} / ${images.length}',
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
                      if (currentImageIndex > 0) {
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
                      if (currentImageIndex < images.length - 1) {
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
                child: VehicleImageThumbnails(
                  vehicle: widget.vehicle,
                  currentImageIndex: currentImageIndex,
                  onImageSelected: (index) {
                    //_carouselController.animateToPage(index);
                    controller.animateToPage(index);
                    setState(() {
                      currentImageIndex = index;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
