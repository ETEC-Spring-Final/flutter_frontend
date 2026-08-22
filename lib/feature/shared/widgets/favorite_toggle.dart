import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';

class FavoriteToggle extends StatelessWidget {
  const FavoriteToggle({
    super.key,
    required this.onFavoriteTap,
    required this.vehicle,
  });

  final VoidCallback? onFavoriteTap;
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        onTap: onFavoriteTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            vehicle.isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            size: 22,
            color: vehicle.isFavorite ? Colors.red : Colors.black87,
          ),
        ),
      ),
    );
  }
}
