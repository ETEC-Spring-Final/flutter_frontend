import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_app_bar.dart';
import 'package:vehicle_rental_system/core/widgets/app_back_button.dart';
import 'package:vehicle_rental_system/core/widgets/app_text_field.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return Scaffold(
      //appBar: AppAppBar(title: "Explore"),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppTextField(
          controller: searchController,
          hint: "Search cars or brands..",
          prefixIcon: Icons.search,
          keyboardType: TextInputType.text,
          onChanged: (value) {
            log("Search : ${searchController.text}");
          },
        ),
      ),
      body: Padding(
        padding: AppDimensions.screenPadding,
        child: Column(children: [
            
            
          ],
        ),
      ),
    );
  }
}
