import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_rental_system/core/widgets/app_circle_btn.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        AppCircleBtn(
          icon: Icons.arrow_back_rounded,
          onTap: () {
            //Navigator.pop(context);
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ],
    );
  }
}
