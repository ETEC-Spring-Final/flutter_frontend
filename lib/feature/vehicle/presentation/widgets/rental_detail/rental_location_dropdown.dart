import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/rental_detail/rental_section_card.dart';

class RentalLocationDropdown extends StatelessWidget {
  const RentalLocationDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  static const locations = [
    'Phnom Penh International Airport',
    'Phnom Penh City Center',
    'Aeon Mall Sen Sok',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RentalFieldLabel(label: label),

        SizedBox(height: 8.h),

        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,

          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colors.onSurfaceVariant,
          ),

          borderRadius: BorderRadius.circular(14.r),

          decoration: InputDecoration(
            filled: true,
            fillColor: colors.surface,

            prefixIcon: Padding(
              padding: EdgeInsets.all(10.w),
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  size: 15.sp,
                  color: colors.primary,
                ),
              ),
            ),

            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: colors.outline),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: colors.outline),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
          ),

          items: locations.map((location) {
            return DropdownMenuItem<String>(
              value: location,
              child: Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),

          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ],
    );
  }
}
