import 'package:flutter/material.dart';

import 'package:vehicle_rental_system/feature/home/presentation/view/home_screen.dart';
import 'package:vehicle_rental_system/feature/home/presentation/widgets/app_botton_navigation.dart';
import 'package:vehicle_rental_system/feature/profile/presentation/view/profile_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/booking_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/explore_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/favorite_screen.dart';

class MainScreen extends StatefulWidget {
  final int index;

  const MainScreen({super.key, this.index = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ===========================================================================
  // STATE
  // ===========================================================================

  late int currentIndex;

  // ===========================================================================
  // EXPLORE KEY
  // ===========================================================================

  final GlobalKey<ExploreScreenState> exploreKey =
      GlobalKey<ExploreScreenState>();

  // ===========================================================================
  // INIT
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    currentIndex = widget.index;
  }

  // ===========================================================================
  // CHANGE TAB
  // ===========================================================================

  void changeTab(int index) {
    if (currentIndex == index) {
      return;
    }

    setState(() {
      currentIndex = index;
    });
  }

  // ===========================================================================
  // OPEN EXPLORE
  // ===========================================================================

  void openExplore({bool focus = false}) {
    setState(() {
      currentIndex = 1;
    });

    if (focus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        exploreKey.currentState?.focusSearch();
      });
    }
  }

  // ===========================================================================
  // CURRENT SCREEN
  // ===========================================================================

  Widget get currentScreen {
    switch (currentIndex) {
      // ========================================================================
      // HOME
      // ========================================================================

      case 0:
        return HomeScreen(
          onExploreTap: (focus) {
            openExplore(focus: focus);
          },

          onBookingTap: () {
            changeTab(2);
          },

          onFavoriteTap: () {
            changeTab(3);
          },

          onProfileTap: () {
            changeTab(4);
          },
        );

      // ========================================================================
      // EXPLORE
      // ========================================================================

      case 1:
        return ExploreScreen(key: exploreKey);

      // ========================================================================
      // BOOKING
      // ========================================================================

      case 2:
        return const BookingScreen();

      // ========================================================================
      // FAVORITE
      // ========================================================================

      case 3:
        return const FavoriteScreen();

      // ========================================================================
      // PROFILE
      // ========================================================================

      case 4:
        return ProfileScreen(
          onExploreTap: () {
            openExplore();
          },

          onBookingsTap: () {
            changeTab(2);
          },

          onFavoritesTap: () {
            changeTab(3);
          },

          onHomeTap: () {
            changeTab(0);
          },
        );

      // ========================================================================
      // DEFAULT
      // ========================================================================

      default:
        return const SizedBox.shrink();
    }
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

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
