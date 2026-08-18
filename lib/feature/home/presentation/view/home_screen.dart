import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/app/theme/app_size.dart';
import 'package:vehicle_rental_system/core/widgets/app_app_bar.dart';
import 'package:vehicle_rental_system/core/widgets/app_text_field.dart';
import 'package:vehicle_rental_system/feature/home/presentation/view/main_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onExploreTap;
  const HomeScreen({super.key, required this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppAppBar(
        title: "AutoRentPremium",
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
            child: Icon(Icons.notifications_rounded),
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
                Text("Hello, Visal 👋", style: theme.textTheme.titleLarge),
                Text(
                  "Ready for your next journey?",
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),

                // Search field
                InkWell(
                  // onTap: () {
                  //   // Navigator.push(
                  //   //   context,
                  //   //   MaterialPageRoute(builder: (context) => ExploreScreen()),
                  //   // );
                  //   // setState(() {
                  //   //   MainScreen(index: 1);
                  //   // });

                  // },
                  onTap: onExploreTap,
                  child: AppTextField(
                    enabled: false,

                    hint: "Search cars or brands..",
                    prefixIcon: Icons.search,
                    keyboardType: TextInputType.text,
                  ),
                ),

                const SizedBox(height: 24),

                // Banner
                AspectRatio(
                  aspectRatio: AppDimensions.aspectRatioStandard,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.cardRadius,
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          "https://i.pinimg.com/736x/66/64/0f/66640f4531df98d4d01085182e54aeac.jpg",
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                        Container(color: Colors.black.withValues(alpha: 0.35)),
                        Padding(
                          padding: AppDimensions.cardContentPadding,
                          child: Column(
                            crossAxisAlignment: .start,
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: AppDimensions.buttonPadding
                                        .copyWith(top: 5, bottom: 5),

                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusCircular,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Special Offer".toUpperCase(),
                                        style: theme.textTheme.titleMedium!
                                            .copyWith(
                                              color: AppColors.background,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                "Weekend Special:\nUp to 20% OFF",
                                style: theme.textTheme.headlineMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: .bold,
                                ),
                              ),
                              Text(
                                "Premium vehicles for your perfect weekend getaway. Valid until Sunday.",
                                // style: theme.textTheme.bodyLarge!.copyWith(
                                //   color: Colors.white.withOpacity(0.5),
                                // ),
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  log("Explore Now");
                                },
                                child: Container(
                                  width: AppSize.w(context, 50),
                                  height: AppSize.h(context, 5),

                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radius8,
                                    ),
                                  ),

                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: .center,
                                      children: [
                                        Text(
                                          "Explore Now",
                                          style: theme.textTheme.titleMedium!
                                              .copyWith(
                                                color: AppColors.white,
                                                fontWeight: .bold,
                                              ),
                                        ),
                                        Icon(
                                          Icons.arrow_right_alt_outlined,
                                          size: AppDimensions.iconLarge,
                                          color: AppColors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
