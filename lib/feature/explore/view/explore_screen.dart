import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_text_field.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController searchController = TextEditingController();

  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppAppBar(title: "Explore"),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppTextField(
          focusNode: searchFocusNode,
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
