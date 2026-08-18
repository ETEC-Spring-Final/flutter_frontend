import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/app/theme/app_size.dart';
import 'package:vehicle_rental_system/core/widgets/app_app_bar.dart';
import 'package:vehicle_rental_system/core/widgets/app_button.dart';
import 'package:vehicle_rental_system/core/widgets/app_text_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchController = TextEditingController();
    return Scaffold(
      appBar: AppAppBar(
        title: "LUXIE RIDE",
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              "https://i.pinimg.com/736x/8d/95/03/8d9503a77e4c21ebf0ced6c252819a0e.jpg",
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsGeometry.all(AppDimensions.space12),
            child: Icon(Icons.menu_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: AppDimensions.screenPadding,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: .start,
              children: [
                Text("Hello, Visal 👋", style: theme.textTheme.headlineSmall),
                Text(
                  "Ready for your next journey?",
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),

                // Search field
                AppTextField(
                  controller: searchController,
                  hint: "Search",
                  prefixIcon: Icons.search,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    log("Search : ${searchController.text}");
                  },
                ),
                const SizedBox(height: 24),

                // Banner
                AspectRatio(
                  aspectRatio: AppDimensions.aspectRatioWide,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.cardRadius,
                      ),
                    ),
                    child: Padding(
                      padding: AppDimensions.cardContentPadding,
                      child: Column(
                        crossAxisAlignment: .start,
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: AppDimensions.buttonPadding.copyWith(
                                  top: 5,
                                  bottom: 5,
                                ),

                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusCircular,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "SUMMER SPECIAL",
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(color: AppColors.background),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "20% off summer\nrentals",
                            style: theme.textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: .bold,
                            ),
                          ),
                          Text(
                            "Book now, drive later.",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          AppButton(
                            width: AppSize.w(context, 50),
                            height: AppSize.h(context, 5),
                            text: "Claim Offer",
                            borderRadius: AppDimensions.radius16,
                            backgroundColor: AppColors.background,
                            foregroundColor: AppColors.primary,
                            onPressed: () {
                              log("Claim Offer");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


/*
return Scaffold(
      appBar: AppAppBar(
        title: "Vehicle Rental System",
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: AppBackButton(),
        ),
      ),
      body: Padding(
        padding: AppDimensions.screenPadding,
        child: ListView(
          children: [
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    AppDialog.showInfo(
                      context: context,
                      title: "Information",
                      message: "Confirm",
                    );
                  },
                  child: Text("showInfo"),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    AppDialog.showConfirmation(
                      context: context,
                      title: "Information",
                      message: "Confirm",
                    );
                  },
                  child: Text("showConfirmation"),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    AppDialog.showDeleteConfirmation(
                      context: context,
                      itemName: "sss",
                    );
                  },
                  child: Text("showDeleteConfirmation"),
                ),

                const SizedBox(height: 24),
                AppTextField(
                  controller: emailController,
                  label: "Email",
                  hint: "Enter your email",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppTextField(
                  controller: passwordController,
                  label: "Password",
                  hint: "Enter your password",
                  prefixIcon: Icons.password_outlined,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Psssword is required";
                    }

                    if (value.length < 6) {
                      return "Password must bee atleast 6 character";
                    }

                    return null;
                  },
                ),
                //AppLoading(message: "Loading.."),
                AppError(),
                Center(
                  child: AppButton(
                    text: "Click Me",
                    onPressed: () {
                      log("Button Clicked");
                    },
                  ),
                ),
                AppEmpty(
                  title: "No Vehicles Available",
                  message: "You have not added any vehicles to your favorites.",
                  actionText: "Browse Vehicle",
                  onAction: () {
                    log("Browse Vehicle");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

*/