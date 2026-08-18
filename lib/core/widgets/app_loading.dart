import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  final String? message;
  final double size;
  final double strokWidth;
  const AppLoading({
    super.key,
    this.message,
    this.size = 40,
    this.strokWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokWidth,
            color: theme.colorScheme.primary,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(message!, style: theme.textTheme.bodyMedium),
        ],
      ],
    );
  }
}
