import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';

class AppError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String retryText;
  final IconData icon;

  const AppError({
    super.key,
    this.message = "Something went wrong.",
    this.onRetry,
    this.retryText = "Try Again",
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: AppDimensions.screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppDimensions.iconExtraLarge,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),

          Text(
            "Oop!",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
