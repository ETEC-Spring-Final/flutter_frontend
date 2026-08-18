import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/core/widgets/app_app_bar.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppAppBar(title: "Favorites"));
  }
}
