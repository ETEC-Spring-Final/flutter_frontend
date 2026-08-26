import 'package:flutter/material.dart';

import 'package:vehicle_rental_system/feature/home/presentation/view/home_screen.dart';
import 'package:vehicle_rental_system/feature/home/presentation/widgets/app_botton_navigation.dart';
import 'package:vehicle_rental_system/feature/profile/presentation/view/profile_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/bookng_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/explore_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/favorite_screen.dart';

class MainScreen extends StatefulWidget {
  final int index;

  const MainScreen({super.key, required this.index});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int currentIndex;

  final exploreKey = GlobalKey<ExploreScreenState>();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void openExplore({bool focus = false}) {
    changeTab(1);

    if (focus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        exploreKey.currentState?.focusSearch();
      });
    }
  }

  Widget get currentScreen {
    switch (currentIndex) {
      case 0:
        return HomeScreen(
          onExploreTap: (focus) {
            openExplore(focus: focus);
          },
          onBookingTap: () => changeTab(2),
          onFavoriteTap: () => changeTab(3),
          onProfileTap: () => changeTab(4),
        );

      case 1:
        return ExploreScreen(key: exploreKey);

      case 2:
        return const BookngScreen();

      case 3:
        return const FavoriteScreen();

      case 4:
        return ProfileScreen(
          onExploreTap: () => openExplore(),
          onBookingsTap: () => changeTab(2),
          onFavoritesTap: () => changeTab(3),
          onHomeTap: () => changeTab(0),
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentScreen,

      bottomNavigationBar: AppBottomNavigation(
        currentIndex: currentIndex,
        onTap: changeTab,
      ),
    );
  }
}
