import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_rental_system/app/router/router_names.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/view/login_screen.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/view/register_screen.dart';

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
    initialLocation: AppRoutes.splash,

    routes: [
      // ============================================================
      // SPLASH
      // ============================================================
      GoRoute(
        path: AppRoutes.splash,
        name: RouterNames.splash,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      // ============================================================
      // ONBOARDING
      // ============================================================
      GoRoute(
        path: AppRoutes.onboarding,
        name: RouterNames.onboarding,
        builder: (context, state) {
          return const OnboardingScreen();
        },
      ),

      // ============================================================
      // login
      // ============================================================
      GoRoute(
        path: AppRoutes.login,
        name: RouterNames.login,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      // ============================================================
      // signup
      // ============================================================
      GoRoute(
        path: AppRoutes.register,
        name: RouterNames.register,
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),

      // ============================================================
      // MAIN HOME
      // ============================================================
      GoRoute(
        path: AppRoutes.mainHome,
        name: RouterNames.main,
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
        name: RouterNames.home,
        builder: (context, state) {
          return const MainScreen(index: 0);
        },
      ),

      // ============================================================
      // EXPLORE
      // ============================================================
      GoRoute(
        path: AppRoutes.explore,
        name: RouterNames.explore,
        builder: (context, state) {
          return const ExploreScreen();
        },
      ),

      // ============================================================
      // BOOKING
      // ============================================================
      GoRoute(
        path: AppRoutes.booking,
        name: RouterNames.booking,
        builder: (context, state) {
          return const BookingScreen();
        },
      ),

      // ============================================================
      // FAVORITE
      // ============================================================
      GoRoute(
        path: AppRoutes.favorite,
        name: RouterNames.favorite,
        builder: (context, state) {
          return const FavoriteScreen();
        },
      ),

      // ============================================================
      // PROFILE
      // ============================================================
      GoRoute(
        path: AppRoutes.profile,
        name: RouterNames.profile,
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),

      // ============================================================
      // VEHICLE DETAIL
      // ============================================================
      GoRoute(
        path: '${AppRoutes.detail}/:id',
        name: RouterNames.detail,
        builder: (context, state) {
          final vehicle = state.extra;

          return VehicleDetailScreen(vehicle: vehicle as dynamic);
        },
      ),
    ],
  );
}
