import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/home/presentation/view/main_screen.dart';
import '../../feature/onboarding/view/onboarding_screen.dart';
import '../../feature/onboarding/view/splash_screen.dart';
import '../../feature/profile/presentation/view/profile_screen.dart';
import '../../feature/vehicle/presentation/view/booking_screen.dart';
import '../../feature/vehicle/presentation/view/explore_screen.dart';
import '../../feature/vehicle/presentation/view/favorite_screen.dart';
import '../../feature/vehicle/presentation/view/vehicle_detail_screen.dart';
import '../router/app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    // ============================================================
    // INITIAL ROUTE
    // ============================================================
    initialLocation: AppRoutes.mainHome,

    routes: [
      // ============================================================
      // SPLASH
      // ============================================================
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      // ============================================================
      // MAIN HOME
      // ============================================================
      GoRoute(
        path: AppRoutes.mainHome,
        name: 'mainHome',
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,

            child: const MainScreen(index: 0),

            transitionDuration: const Duration(milliseconds: 700),

            reverseTransitionDuration: const Duration(milliseconds: 500),

            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  // ----------------------------------------------------
                  // CURVE
                  // ----------------------------------------------------

                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  );

                  // ----------------------------------------------------
                  // FADE
                  // ----------------------------------------------------

                  final fadeAnimation = Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(curvedAnimation);

                  // ----------------------------------------------------
                  // SLIDE
                  // ----------------------------------------------------

                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(curvedAnimation);

                  // ----------------------------------------------------
                  // SCALE
                  // ----------------------------------------------------

                  final scaleAnimation = Tween<double>(
                    begin: 0.96,
                    end: 1.0,
                  ).animate(curvedAnimation);

                  return FadeTransition(
                    opacity: fadeAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        child: child,
                      ),
                    ),
                  );
                },
          );
        },
      ),

      // ============================================================
      // HOME
      // ============================================================
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) {
          return const MainScreen(index: 0);
        },
      ),

      // ============================================================
      // EXPLORE
      // ============================================================
      GoRoute(
        path: AppRoutes.explore,
        name: 'explore',
        builder: (context, state) {
          return const ExploreScreen();
        },
      ),

      // ============================================================
      // BOOKING
      // ============================================================
      GoRoute(
        path: AppRoutes.booking,
        name: 'booking',
        builder: (context, state) {
          return const BookingScreen();
        },
      ),

      // ============================================================
      // FAVORITE
      // ============================================================
      GoRoute(
        path: AppRoutes.favorite,
        name: 'favorite',
        builder: (context, state) {
          return const FavoriteScreen();
        },
      ),

      // ============================================================
      // PROFILE
      // ============================================================
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),

      // ============================================================
      // ONBOARDING
      // ============================================================
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) {
          return const OnboardingScreen();
        },
      ),

      // ============================================================
      // VEHICLE DETAIL
      // ============================================================
      GoRoute(
        path: '${AppRoutes.detail}/:id',
        name: 'detail',
        builder: (context, state) {
          final vehicle = state.extra;

          return VehicleDetailScreen(vehicle: vehicle as dynamic);
        },
      ),
    ],
  );
}
