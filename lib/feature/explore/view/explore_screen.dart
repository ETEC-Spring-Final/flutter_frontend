import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_text_field.dart';
import 'package:vehicle_rental_system/feature/explore/widget/explore_category_filter.dart';
import 'package:vehicle_rental_system/feature/explore/widget/vehicle_card_explore.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/vehicle_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController searchController = TextEditingController();

  final FocusNode searchFocusNode = FocusNode();
  int selectedCategory = 0;

  Future<void> refreshData() async {
    /*
  context.read<VehicleBloc>().add(
    const GetVehiclesEvent(
      refresh: true,
    ),
  );
  */
  }

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
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ExploreCategoryFilter(
                    selectedIndex: selectedCategory,
                    onSelected: (index) {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: AppDimensions.screenPadding,
            sliver: SliverList.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
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
