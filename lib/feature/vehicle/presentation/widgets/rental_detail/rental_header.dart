import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';

class RentalHeader extends StatelessWidget {
  const RentalHeader({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        _VehicleImage(
          imageUrl: vehicle.images.isNotEmpty ? vehicle.images.first : null,
        ),

        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.45, 1.0],
              colors: [
                Colors.black.withValues(alpha: 0.45),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.85),
              ],
            ),
          ),
        ),

        Positioned(
          left: 20.w,
          right: 20.w,
          bottom: 22.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${vehicle.brand} ${vehicle.model}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),

              SizedBox(height: 10.h),

              Row(
                children: [
                  _HeaderChip(label: vehicle.type),

                  SizedBox(width: 8.w),

                  _HeaderChip(
                    label: '\$${vehicle.pricePerDay.toStringAsFixed(0)}/day',
                    emphasized: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.label, this.emphasized = false});

  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: emphasized ? Colors.white : Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5.sp,
          fontWeight: FontWeight.w700,
          color: emphasized ? Colors.black87 : Colors.white,
        ),
      ),
    );
  }
}

class _VehicleImage extends StatelessWidget {
  const _VehicleImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _PlaceholderImage(
        color: colors.surfaceContainerHighest,
        iconColor: colors.onSurfaceVariant,
      );
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,

      errorBuilder: (_, __, ___) {
        return _PlaceholderImage(
          color: colors.surfaceContainerHighest,
          iconColor: colors.onSurfaceVariant,
        );
      },

      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }

        return _PlaceholderImage(
          color: colors.surfaceContainerHighest,
          iconColor: colors.onSurfaceVariant,
          showLoading: true,
        );
      },
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage({
    required this.color,
    required this.iconColor,
    this.showLoading = false,
  });

  final Color color;
  final Color iconColor;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      alignment: Alignment.center,
      child: showLoading
          ? const CircularProgressIndicator(strokeWidth: 2)
          : Icon(Icons.directions_car_rounded, size: 48.sp, color: iconColor),
    );
  }
}
