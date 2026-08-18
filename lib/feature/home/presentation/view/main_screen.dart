import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/feature/home/presentation/view/home_screen.dart';
import 'package:vehicle_rental_system/feature/profile/presentation/view/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screenList = const [
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: "Booking",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: "Alerts",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
