import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExploreCategoryFilter extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ExploreCategoryFilter({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const List<_CategoryItem> categories = [
    _CategoryItem(title: 'All', icon: null, types: null),
    _CategoryItem(
      title: 'SUV',
      icon: Icons.directions_car_outlined,
      types: ['SUV'],
    ),
    _CategoryItem(
      title: 'Sedan',
      icon: Icons.directions_car_filled_outlined,
      types: ['Sedan'],
    ),
    _CategoryItem(
      title: 'Luxury',
      icon: Icons.workspace_premium_outlined,
      types: ['Luxury'],
    ),
    _CategoryItem(
      title: 'Pickup',
      icon: Icons.local_shipping_outlined,
      types: ['Pickup'],
    ),
    _CategoryItem(
      title: 'Van',
      icon: Icons.airport_shuttle_outlined,
      types: ['Van'],
    ),
    _CategoryItem(
      title: 'Electric',
      icon: Icons.electric_car_outlined,
      types: ['Electric'],
    ),
  ];

  static List<String>? typesForIndex(int index) {
    if (index < 0 || index >= categories.length) return null;
    return categories[index].types;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 30.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedIndex == index;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelected(index),
              borderRadius: BorderRadius.circular(28),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: category.icon == null ? 21.r : 18.r,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (category.icon != null) ...[
                      Icon(
                        category.icon,
                        size: 20.r,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      category.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                        // fontWeight: isSelected
                        //     ? FontWeight.w700
                        //     : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final IconData? icon;
  final List<String>? types;

  const _CategoryItem({required this.title, this.icon, this.types});
}
