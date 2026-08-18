import 'package:go_router/go_router.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/view/home_screen.dart';
import 'package:vehicle_rental_system/feature/home/presentation/view/main_screen.dart';
import 'package:vehicle_rental_system/app/router/app_routes.dart';
import 'package:vehicle_rental_system/app/router/router_names.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/",
    routes: [
      // Splash
      // Authentication
      // Onboarding
      // Main app
      GoRoute(
        path: AppRoutes.main,
        name: RouterNames.main,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: RouterNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
