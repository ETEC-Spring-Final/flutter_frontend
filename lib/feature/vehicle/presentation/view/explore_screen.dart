import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_text_field.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/explore_category_filter.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/vehicle_card_explore.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/vehicle_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => ExploreScreenState();
}

class ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  int selectedCategory = 0;

  void focusSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      searchFocusNode.requestFocus();
    });
  }

  List<Vehicle> get _filteredVehicles {
    final query = searchController.text.trim().toLowerCase();

    final types = ExploreCategoryFilter.typesForIndex(selectedCategory);

    return vehicles.where((vehicle) {
      final matchesCategory =
          types == null || types.contains(vehicle.type);

      final matchesQuery =
          query.isEmpty ||
          vehicle.brand.toLowerCase().contains(query) ||
          vehicle.model.toLowerCase().contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    /*
  context.read<VehicleBloc>().add(
    const GetVehiclesEvent(
      refresh: true,
    ),
  );
  */
  }

  // @override
  // void initState() {
  //   super.initState();

  //   if (widget.autoFocus) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (mounted) {
  //         searchFocusNode.requestFocus();
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppAppBar(title: "Explore"),
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: AppTextField(
      //     focusNode: searchFocusNode,
      //     controller: searchController,
      //     hint: "Search cars or brands..",
      //     prefixIcon: Icons.search,
      //     keyboardType: TextInputType.text,
      //     onChanged: (value) {
      //       log("Search : ${searchController.text}");
      //     },
      //   ),
      // ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,

            // Hide when scrolling down
            floating: true,

            // Show immediately when scrolling up
            snap: true,

            // Don't stay pinned
            pinned: false,

            elevation: 0,

            scrolledUnderElevation: 0,

            backgroundColor: Theme.of(context).scaffoldBackgroundColor,

            surfaceTintColor: Colors.transparent,

            titleSpacing: 16,
            centerTitle: false,
            title: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: AppTextField(
                contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                focusNode: searchFocusNode,
                controller: searchController,
                hint: "Search cars or brands..",
                prefixIcon: Icons.search,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {});
                  log("Search : ${searchController.text}");
                },
              ),
            ),
          ),

          CupertinoSliverRefreshControl(
            onRefresh: refreshData,

            refreshTriggerPullDistance: 90,

            refreshIndicatorExtent: 56,

            builder:
                (
                  context,
                  refreshState,
                  pulledExtent,
                  refreshTriggerPullDistance,
                  refreshIndicatorExtent,
                ) {
                  final colorScheme = Theme.of(context).colorScheme;

                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,

                      color: colorScheme.primary,

                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.10,
                      ),
                    ),
                  );
                },
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                ExploreCategoryFilter(
                  selectedIndex: selectedCategory,
                  onSelected: (index) {
                    setState(() {
                      selectedCategory = index;
                    });
                  },
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: EdgeInsetsGeometry.all(
              AppDimensions.chipHorizontalPadding,
            ),
            sliver: SliverList.builder(
              itemCount: _filteredVehicles.isEmpty ? 1 : _filteredVehicles.length,
              itemBuilder: (context, index) {
                if (_filteredVehicles.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 48.h),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 56.r,
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "No cars found",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Try a different search or filter.",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  );
                }

                final vehicle = _filteredVehicles[index];
                return VehicleCardExplore(
                  vehicle: vehicle,
                  onTap: () {
                    log('Selected: ${vehicle.brand} ${vehicle.model}');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VehicleDetailScreen(vehicle: vehicle),
                      ),
                    );
                  },
                  onFavoriteTap: () {
                    log('Favorite: ${vehicle.brand} ${vehicle.model}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
