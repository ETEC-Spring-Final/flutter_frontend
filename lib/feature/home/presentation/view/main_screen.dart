import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:vehicle_rental_system/feature/booking/presentation/view/bookng_screen.dart';
import 'package:vehicle_rental_system/feature/explore/view/explore_screen.dart';
import 'package:vehicle_rental_system/feature/favorite/presentation/view/favorite_screen.dart';
import 'package:vehicle_rental_system/feature/home/presentation/widgets/app_botton_navigation.dart';
import 'package:vehicle_rental_system/feature/home/presentation/view/home_screen.dart';
import 'package:vehicle_rental_system/feature/profile/presentation/view/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int index;

  const MainScreen({super.key, required this.index});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.index;
  }

  // ================================================================
  // CHANGE TAB
  // ================================================================

  void changeTab(int index) {
    if (currentIndex == index) {
      return;
    }

    setState(() {
      currentIndex = index;

      log('Current tab: $currentIndex');
    });
  }

  // ================================================================
  // BUILD CURRENT SCREEN
  // ================================================================

  Widget _buildScreen() {
    switch (currentIndex) {
      // ============================================================
      // HOME
      // ============================================================

      case 0:
        return HomeScreen(
          // Home → Explore
          onExploreTap: () {
            changeTab(1);
          },

          // Home → Booking
          onBookingTap: () {
            changeTab(2);
          },

          // Home → Favorite
          onFavoriteTap: () {
            changeTab(3);
          },

          // Home → Profile
          onProfileTap: () {
            changeTab(4);
          },
        );

      // ============================================================
      // EXPLORE
      // ============================================================

      case 1:
        return const ExploreScreen();

      // ============================================================
      // BOOKING
      // ============================================================

      case 2:
        return const BookngScreen();

      // ============================================================
      // FAVORITE
      // ============================================================

      case 3:
        return const FavoriteScreen();

      // ============================================================
      // PROFILE
      // ============================================================

      case 4:
        return ProfileScreen(
          // Profile → Explore
          onExploreTap: () {
            changeTab(1);
          },

          // Profile → Booking
          onBookingsTap: () {
            changeTab(2);
          },

          // Profile → Favorite
          onFavoritesTap: () {
            changeTab(3);
          },

          // Profile → Home
          onHomeTap: () {
            changeTab(0);
          },
        );

      // ============================================================
      // DEFAULT
      // ============================================================

      default:
        return HomeScreen(
          onExploreTap: () {
            changeTab(1);
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
    }
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),

        switchInCurve: Curves.easeOutCubic,

        switchOutCurve: Curves.easeInCubic,

        transitionBuilder: (child, animation) {
          final slideAnimation =
              Tween<Offset>(
                begin: const Offset(0.15, 0),

                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          return FadeTransition(
            opacity: animation,

            child: SlideTransition(position: slideAnimation, child: child),
          );
        },

        child: KeyedSubtree(key: ValueKey(currentIndex), child: _buildScreen()),
      ),

      // ============================================================
      // BOTTOM NAVIGATION
      // ============================================================
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: currentIndex,

        onTap: changeTab,
      ),
    );
  }
}
