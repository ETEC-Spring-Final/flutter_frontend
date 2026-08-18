import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/feature/booking/presentation/view/bookng_screen.dart';
import 'package:vehicle_rental_system/feature/explore/view/explore_screen.dart';
import 'package:vehicle_rental_system/feature/favorite/presentation/view/favorite_screen.dart';
import 'package:vehicle_rental_system/feature/home/presentation/widget/app_botton_navigation.dart';
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

  final List<Widget> screenList = const [
    HomeScreen(onExploreTap: null),
    ExploreScreen(),
    BookngScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  void changeTab(int index) {
    setState(() {
      currentIndex = index;
      log(currentIndex.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: screenList[currentIndex],
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(
            onExploreTap: () {
              changeTab(1);
            },
          ),
          const ExploreScreen(),
          const BookngScreen(),
          const FavoriteScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: currentIndex,
        // onTap: (value) {
        //   setState(() {
        //     currentIndex = value;
        //     log(currentIndex.toString());
        //   });
        // },
        onTap: changeTab,
      ),
    );
  }
}
