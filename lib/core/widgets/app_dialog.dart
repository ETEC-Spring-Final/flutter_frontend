import 'package:flutter/material.dart';

class AppDialog {
  AppDialog._();

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
    IconData icon = Icons.help_outline,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: iconColor ?? theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(child: Text(title)),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    IconData icon = Icons.info_outline,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: iconColor ?? theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(child: Text(title)),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showDeleteConfirmation({
    required BuildContext context,
    required String itemName,
  }) {
    return showConfirmation(
      context: context,
      title: 'Delete Item',
      message: 'Are you sure you want to delete "$itemName"?',
      cancelText: 'Cancel',
      confirmText: 'Delete',
      icon: Icons.delete_outline,
      iconColor: Colors.red,
    );
  }
}

/*

how to use the AppDialog

final confirmed = await AppDialog.showDeleteConfirmation(
  context: context,
  itemName: 'Toyota Camry',
);

if (confirmed == true) {
  // Delete vehicle
}

*/
