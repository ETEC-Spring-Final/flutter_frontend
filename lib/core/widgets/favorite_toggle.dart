import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/feature/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';

class FavoriteToggle extends StatelessWidget {
  const FavoriteToggle({
    super.key,
    required this.onFavoriteTap,
    required this.vehicle,
    this.size = 35,
    this.iconSize = 18,
  });

  final VoidCallback? onFavoriteTap;
  final Vehicle vehicle;

  /// Total button size
  final double size;

  /// Favorite icon size
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        final isFavorite =
            state is FavoriteLoaded && state.contains(vehicle.id);

        return Material(
          color: Colors.white.withValues(alpha: 0.80),
          shape: const CircleBorder(),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.15),
          child: InkWell(
            onTap: () {
              context
                  .read<FavoriteBloc>()
                  .add(ToggleFavoriteEvent(vehicle.id));
              onFavoriteTap?.call();
            },
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: size.w,
              height: size.h,
              child: Center(
                child: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: iconSize.r,
                  fontWeight: FontWeight.bold,
                  color: isFavorite ? Colors.red : AppColors.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
