import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';

class AppEmpty extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;

  const AppEmpty({
    super.key,
    this.title = "No Data",
    this.message = "There is no data to display.",
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: AppDimensions.screenPadding,
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(
              icon,
              size: 72,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),

            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],

            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(onPressed: onAction, child: Text(actionText!)),
            ],
          ],
        ),
      ),
    );
  }
}


/*
Usage

AppEmpty(
  title: 'No Favorite Vehicles',
  message: 'You have not added any vehicles to your favorites.',
  icon: Icons.favorite_border,
  actionText: 'Browse Vehicles',
  onAction: () {},
)
*/