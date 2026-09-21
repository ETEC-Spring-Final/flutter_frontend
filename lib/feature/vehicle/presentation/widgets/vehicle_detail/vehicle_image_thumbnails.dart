import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';

class VehicleImageThumbnails extends StatelessWidget {
  final Vehicle vehicle;
  final int currentImageIndex;
  final ValueChanged<int> onImageSelected;

  const VehicleImageThumbnails({
    super.key,
    required this.vehicle,
    required this.currentImageIndex,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        const double thumbnailWidth = 72;
        const double spacing = 8;

        final totalWidth =
            (thumbnailWidth.w * vehicle.images.length) +
            (spacing.w * (vehicle.images.length - 1));

        // ================================================================
        // FEW IMAGES → CENTER
        // ================================================================
        if (totalWidth <= constraints.maxWidth) {
          return Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(vehicle.images.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == vehicle.images.length - 1 ? 0 : spacing.w,
                  ),
                  child: _buildThumbnail(context, vehicle, index, colorScheme),
                );
              }),
            ),
          );
        }

        // ================================================================
        // MANY IMAGES → HORIZONTAL SCROLL
        // ================================================================
        return SizedBox(
          height: 58.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: vehicle.images.length,
            separatorBuilder: (context, index) {
              return SizedBox(width: spacing.w);
            },
            itemBuilder: (context, index) {
              return _buildThumbnail(context, vehicle, index, colorScheme);
            },
          ),
        );
      },
    );
  }

  Widget _buildThumbnail(
    BuildContext context,
    Vehicle vehicle,
    int index,
    ColorScheme colorScheme,
  ) {
    final image = vehicle.images[index];

    final bool isSelected = index == currentImageIndex;

    return GestureDetector(
      onTap: () {
        onImageSelected(index);
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
              color: Colors.black.withValues(alpha: 0.25),
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
                color: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.broken_image_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 22.r,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
