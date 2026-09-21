import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_rental_system/app/router/app_routes.dart';
import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // ============================================================
  // PAGE CONTROLLER
  // ============================================================

  late final PageController _pageController;

  int _currentPage = 0;

  // ============================================================
  // PAGES DATA
  // ============================================================

  static const List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      icon: Icons.directions_car_filled_rounded,
      title: 'Find Your Perfect Ride',
      description:
          'Browse a wide range of vehicles and pick the one that fits '
          'your style, budget, and journey.',
    ),
    _OnboardingPageData(
      icon: Icons.calendar_month_rounded,
      title: 'Book in Seconds',
      description:
          'Choose your pickup and return dates and confirm your booking '
          'with just a few simple taps.',
    ),
    _OnboardingPageData(
      icon: Icons.category_rounded,
      title: 'Rent With Confidence',
      description:
          'Transparent pricing, secure payments, and full flexibility for '
          'every adventure on the road.',
    ),
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ============================================================
  // GETTERS
  // ============================================================

  bool get _isLastPage => _currentPage == _pages.length - 1;

  // ============================================================
  // NEXT PAGE
  // ============================================================

  void _nextPage() {
    if (_isLastPage) {
      _goToLogin();
      return;
    }

    if (!_pageController.hasClients) {
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  // ============================================================
  // SKIP
  // ============================================================

  void _skip() {
    _goToLogin();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  void _goToLogin() {
    if (!mounted) return;

    context.go(AppRoutes.login);
  }

  // ============================================================
  // PAGE CHANGED
  // ============================================================

  void _onPageChanged(int index) {
    if (!mounted) return;

    setState(() {
      _currentPage = index;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // ----------------------------------------------------------
      // BODY
      // ----------------------------------------------------------
      body: SafeArea(
        child: Column(
          children: [
            // ====================================================
            // TOP BAR
            // ====================================================
            SizedBox(
              height: 56.h,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: AppDimensions.space16),
                  child: TextButton(
                    onPressed: _isLastPage ? null : _skip,
                    child: Text(
                      'Skip',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: _isLastPage
                            ? colorScheme.onSurface.withValues(alpha: 0.35)
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ====================================================
            // PAGE VIEW
            // ====================================================
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                physics: const BouncingScrollPhysics(),
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: _pages[index]);
                },
              ),
            ),

            // ====================================================
            // PAGE INDICATORS
            // ====================================================
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  return _Dot(isActive: index == _currentPage);
                }),
              ),
            ),

            // ====================================================
            // ACTION BUTTONS
            // ====================================================
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.space16,
                28.h,
                AppDimensions.space16,
                0,
              ),
              child: _buildActions(),
            ),

            // ====================================================
            // BOTTOM SPACE
            // ====================================================
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACTION BUTTONS
  // ============================================================

  Widget _buildActions() {
    if (_isLastPage) {
      return SizedBox(
        width: double.infinity,
        child: AppButton(
          text: "Let's Go",
          height: AppDimensions.buttonLargeHeight,
          borderRadius: AppDimensions.radius16,
          onPressed: _goToLogin,
        ),
      );
    }

    return Row(
      children: [
        // ------------------------------------------------------
        // GET STARTED
        // ------------------------------------------------------
        Expanded(
          child: AppButton(
            text: 'Get Started',
            height: AppDimensions.buttonLargeHeight,
            borderRadius: AppDimensions.radius16,
            isOutlined: true,
            isFullWidth: true,
            onPressed: _goToLogin,
          ),
        ),

        // ------------------------------------------------------
        // SPACE
        // ------------------------------------------------------
        SizedBox(width: AppDimensions.space16.w),

        // ------------------------------------------------------
        // NEXT
        // ------------------------------------------------------
        Expanded(
          child: AppButton(
            text: 'Next',
            height: AppDimensions.buttonLargeHeight,
            borderRadius: AppDimensions.radius16,
            isFullWidth: true,
            onPressed: _nextPage,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ONBOARDING PAGE
// ============================================================

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: 20.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ==================================================
                  // ILLUSTRATION
                  // ==================================================
                  Container(
                    width: 220.w,
                    height: 220.w,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 150.w,
                        height: 150.w,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowMedium,
                              blurRadius: 30.r,
                              offset: Offset(0, 12.h),
                            ),
                          ],
                        ),
                        child: Icon(
                          data.icon,
                          size: 84.sp,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // SPACE
                  // ==================================================
                  SizedBox(height: 40.h),

                  // ==================================================
                  // TITLE
                  // ==================================================
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),

                  // ==================================================
                  // SPACE
                  // ==================================================
                  SizedBox(height: 16.h),

                  // ==================================================
                  // DESCRIPTION
                  // ==================================================
                  Text(
                    data.description,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// DOT INDICATOR
// ============================================================

class _Dot extends StatelessWidget {
  final bool isActive;

  const _Dot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 28.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
      ),
    );
  }
}

// ============================================================
// PAGE DATA
// ============================================================

class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
  });
}
