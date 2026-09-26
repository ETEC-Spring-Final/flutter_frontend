import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:vehicle_rental_system/app/router/app_routes.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  // ============================================================
  // PAGE CONTROLLER
  // ============================================================

  late final PageController _pageController;

  // ============================================================
  // AMBIENT ANIMATION
  // ============================================================

  late final AnimationController _ambientController;

  // ============================================================
  // STATE
  // ============================================================

  int _currentPage = 0;

  // ============================================================
  // ONBOARDING DATA
  // ============================================================

  static const List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      image: 'assets/images/onboarding/onboarding_1.png',
      badge: 'PREMIUM CAR RENTAL',
      title: 'Find Your\nPerfect Ride',
      description:
          'Discover the right car for every journey, from city drives to weekend adventures.',
    ),
    _OnboardingPageData(
      image: 'assets/images/onboarding/onboarding_2.png',
      badge: 'SIMPLE & FAST',
      title: 'Book in\nSeconds',
      description:
          'Select your car, choose your dates, and confirm your booking in just a few taps.',
    ),
    _OnboardingPageData(
      image: 'assets/images/onboarding/onboarding_3.png',
      badge: 'DRIVE WITH CONFIDENCE',
      title: 'Enjoy Every\nJourney',
      description:
          'Transparent pricing, secure payments, and a seamless rental experience.',
    ),
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _pageController.dispose();
    _ambientController.dispose();

    super.dispose();
  }

  // ============================================================
  // GETTERS
  // ============================================================

  bool get _isLastPage => _currentPage == _pages.length - 1;

  // ============================================================
  // NEXT
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
      duration: const Duration(milliseconds: 500),
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
    if (!mounted) {
      return;
    }

    context.go(AppRoutes.login);
  }

  // ============================================================
  // PAGE CHANGED
  // ============================================================

  void _onPageChanged(int index) {
    if (!mounted) {
      return;
    }

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
      body: Stack(
        children: [
          // ======================================================
          // AMBIENT BACKGROUND
          // ======================================================
          _AnimatedBackground(animation: _ambientController),

          // ======================================================
          // CONTENT
          // ======================================================
          SafeArea(
            child: Column(
              children: [
                // ==================================================
                // TOP BAR
                // ==================================================
                _buildTopBar(theme, colorScheme),

                // ==================================================
                // PAGE VIEW
                // ==================================================
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      return _OnboardingPage(
                        data: _pages[index],
                        isActive: index == _currentPage,
                        pageController: _pageController,
                        pageIndex: index,
                      );
                    },
                  ),
                ),

                // ==================================================
                // BOTTOM CONTROLS
                // ==================================================
                _buildBottomControls(theme, colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar(ThemeData theme, ColorScheme colorScheme) {
    return SizedBox(
      height: 56.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.space20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: _isLastPage ? 0 : 1,
              child: IgnorePointer(
                ignoring: _isLastPage,
                child: TextButton(
                  onPressed: _skip,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Skip',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM CONTROLS
  // ============================================================

  Widget _buildBottomControls(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.space20,
        0,
        AppDimensions.space20,
        20.h,
      ),
      child: Column(
        children: [
          // ======================================================
          // PROGRESS
          // ======================================================
          _ProgressIndicator(
            currentPage: _currentPage,
            pageCount: _pages.length,
          ),

          SizedBox(height: 24.h),

          // ======================================================
          // PRIMARY BUTTON
          // ======================================================
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: _isLastPage ? "Let's Go" : 'Next',
              height: 56.h,
              borderRadius: 18.r,
              isFullWidth: true,
              onPressed: _nextPage,
            ),
          ),

          // ======================================================
          // SECONDARY ACTION
          // ======================================================
          if (!_isLastPage) ...[
            SizedBox(height: 8.h),
            TextButton(
              onPressed: _goToLogin,
              style: TextButton.styleFrom(
                minimumSize: Size(double.infinity, 42.h),
              ),
              child: Text(
                'Get Started',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// ANIMATED BACKGROUND
// ============================================================

class _AnimatedBackground extends StatelessWidget {
  final Animation<double> animation;

  const _AnimatedBackground({required this.animation});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final value = Curves.easeInOut.transform(animation.value);

          final movement = (value - 0.5) * 35.h;

          return Stack(
            children: [
              // ==================================================
              // TOP GLOW
              // ==================================================
              Positioned(
                top: -100.h + movement,
                left: -80.w,
                right: -80.w,
                child: Container(
                  height: 360.h,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 0.9,
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.13),
                        colorScheme.primary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // ==================================================
              // RIGHT ORB
              // ==================================================
              Positioned(
                top: 120.h + movement,
                right: -110.w,
                child: _AmbientOrb(
                  size: 250.w,
                  color: colorScheme.primary,
                  opacity: 0.055,
                ),
              ),

              // ==================================================
              // LEFT ORB
              // ==================================================
              Positioned(
                top: 330.h - movement,
                left: -120.w,
                child: _AmbientOrb(
                  size: 280.w,
                  color: colorScheme.primary,
                  opacity: 0.04,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// AMBIENT ORB
// ============================================================

class _AmbientOrb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _AmbientOrb({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}

// ============================================================
// ONBOARDING PAGE
// ============================================================

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;
  final bool isActive;
  final PageController pageController;
  final int pageIndex;

  const _OnboardingPage({
    required this.data,
    required this.isActive,
    required this.pageController,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallHeight = constraints.maxHeight < 650.h;

        final imageHeight = isSmallHeight ? 220.h : 290.h;

        return AnimatedBuilder(
          animation: pageController,
          builder: (context, child) {
            double page = pageIndex.toDouble();

            if (pageController.hasClients &&
                pageController.position.haveDimensions) {
              page = pageController.page ?? pageIndex.toDouble();
            }

            final distance = (page - pageIndex).abs();

            final scale = math.max(0.88, 1.0 - (distance * 0.08));

            final opacity = math.max(0.45, 1.0 - (distance * 0.55));

            final translateX = (page - pageIndex) * 25.w;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space20,
                    vertical: 8.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ==========================================
                      // CAR IMAGE
                      // ==========================================
                      Transform.translate(
                        offset: Offset(translateX, 0),
                        child: Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: opacity,
                            child: _CarIllustration(
                              image: data.image,
                              isActive: isActive,
                              height: imageHeight,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallHeight ? 14.h : 24.h),

                      // ==========================================
                      // BADGE
                      // ==========================================
                      AnimatedOpacity(
                        opacity: isActive ? 1 : 0.5,
                        duration: const Duration(milliseconds: 300),
                        child: _Badge(text: data.badge),
                      ),

                      SizedBox(height: 14.h),

                      // ==========================================
                      // TITLE
                      // ==========================================
                      Text(
                        data.title,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: isSmallHeight ? 29.sp : 34.sp,
                          height: 1.08,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.1,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // ==========================================
                      // DESCRIPTION
                      // ==========================================
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 335.w),
                        child: Text(
                          data.description,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 15.sp,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================
// CAR ILLUSTRATION
// ============================================================

class _CarIllustration extends StatefulWidget {
  final String image;
  final bool isActive;
  final double height;

  const _CarIllustration({
    required this.image,
    required this.isActive,
    required this.height,
  });

  @override
  State<_CarIllustration> createState() => _CarIllustrationState();
}

class _CarIllustrationState extends State<_CarIllustration>
    with TickerProviderStateMixin {
  // Gentle up/down float, loops continuously.
  late final AnimationController _controller;

  // One-shot diagonal light sweep, replayed whenever this
  // illustration becomes the active page.
  late final AnimationController _shineController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
    );

    if (widget.isActive) {
      _shineController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _CarIllustration oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !oldWidget.isActive) {
      _shineController
        ..reset()
        ..repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _shineController.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final movement = math.sin(_controller.value * math.pi) * 4.h;

        return SizedBox(
          width: double.infinity,
          height: widget.height + 35.h,
          child: ClipRect(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ==================================================
                // SOFT FLOOR GLOW
                // ==================================================
                Positioned(
                  bottom: 16.h,
                  child: Container(
                    width: 190.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: RadialGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // CAR
                // ==================================================
                Transform.translate(
                  offset: Offset(0, -movement),
                  child: Image.asset(
                    widget.image,
                    width: double.infinity,
                    height: widget.height,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.directions_car_filled_rounded,
                        size: 90.sp,
                        color: colorScheme.primary.withValues(alpha: 0.35),
                      );
                    },
                  ),
                ),

                // ==================================================
                // ONE-SHOT DIAGONAL LIGHT SWEEP
                // ==================================================
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;

                      return AnimatedBuilder(
                        animation: _shineController,
                        builder: (context, _) {
                          final progress = Curves.easeInOutCubic.transform(
                            _shineController.value,
                          );

                          final dx = _lerp(-w * 0.7, w * 1.3, progress);

                          return Stack(
                            children: [
                              Positioned(
                                top: -h * 0.6,
                                left: dx,
                                child: Transform.rotate(
                                  angle: -0.35,
                                  child: Container(
                                    width: w * 0.28,
                                    height: h * 2.2,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.white.withValues(alpha: 0),
                                          Colors.white.withValues(alpha: 0.22),
                                          Colors.white.withValues(alpha: 0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}

// ============================================================
// BADGE
// ============================================================

class _Badge extends StatelessWidget {
  final String text;

  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 7.w),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROGRESS INDICATOR
// ============================================================

class _ProgressIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const _ProgressIndicator({
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 30.w : 7.w,
          height: 7.h,
          decoration: BoxDecoration(
            color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}

// ============================================================
// PAGE DATA
// ============================================================

class _OnboardingPageData {
  final String image;
  final String badge;
  final String title;
  final String description;

  const _OnboardingPageData({
    required this.image,
    required this.badge,
    required this.title,
    required this.description,
  });
}
