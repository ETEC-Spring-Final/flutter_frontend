import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_size.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_BottomNavItem> items = [
    _BottomNavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    _BottomNavItem(
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
      label: 'Explore',
    ),
    _BottomNavItem(
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month,
      label: 'Bookings',
    ),
    _BottomNavItem(
      icon: Icons.favorite_border,
      selectedIcon: Icons.favorite,
      label: 'Favorites',
    ),
    _BottomNavItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ============================================================
    // LIGHT MODE COLORS
    // ============================================================

    final backgroundColor = isDark ? AppColors.darkSurface : AppColors.surface;

    final selectedIconColor = isDark
        ? AppColors.darkPrimary
        : AppColors.primary;

    final unselectedIconColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final selectedBackgroundColor = isDark
        ? AppColors.darkPrimary.withOpacity(0.20)
        : AppColors.primary100;

    final selectedTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return SafeArea(
      top: false,
      child: Container(
        height: AppSize.h(context, 7.5),

        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.30 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),

        child: Row(
          children: List.generate(items.length, (index) {
            return Expanded(
              child: _BottomNavButton(
                item: items[index],
                selected: currentIndex == index,
                onTap: () => onTap(index),

                selectedIconColor: selectedIconColor,
                unselectedIconColor: unselectedIconColor,
                selectedBackgroundColor: selectedBackgroundColor,
                selectedTextColor: selectedTextColor,
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ================================================================
// BOTTOM NAVIGATION BUTTON
// ================================================================

class _BottomNavButton extends StatelessWidget {
  final _BottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  final Color selectedIconColor;
  final Color unselectedIconColor;
  final Color selectedBackgroundColor;
  final Color selectedTextColor;

  const _BottomNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.selectedIconColor,
    required this.unselectedIconColor,
    required this.selectedBackgroundColor,
    required this.selectedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,

        child: SizedBox(
          height: 82,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              // ==================================================
              // ICON
              // ==================================================
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,

                width: selected ? 64 : 50,
                height: 38,

                decoration: BoxDecoration(
                  color: selected
                      ? selectedBackgroundColor
                      : Colors.transparent,

                  borderRadius: BorderRadius.circular(22),
                ),

                child: Center(
                  child: Icon(
                    selected ? item.selectedIcon : item.icon,

                    size: 27,

                    color: selected ? selectedIconColor : unselectedIconColor,
                  ),
                ),
              ),

              const SizedBox(height: 3),

              // ==================================================
              // LABEL
              // ==================================================
              Text(
                item.label,

                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  fontSize: 15,

                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,

                  color: selected ? selectedTextColor : unselectedIconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// NAVIGATION ITEM
// ================================================================

class _BottomNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _BottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
