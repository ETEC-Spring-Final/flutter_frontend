import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/bloc/auth_bloc.dart';

import '../../../app/router/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  late final AnimationController _introController;
  late final AnimationController _jumpController;

  // ============================================================
  // INTRO ANIMATIONS
  // ============================================================

  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoFadeAnimation;

  late final Animation<double> _textFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;

  // ============================================================
  // JUMP ANIMATION
  // ============================================================

  late final Animation<double> _jumpAnimation;

  @override
  void initState() {
    super.initState();

    // Check whether JWT token already exists
    context.read<AuthBloc>().add(CheckAuthStatus());

    _setupIntroAnimation();
    _setupJumpAnimation();

    _introController.forward();

    // Start jump after logo entrance animation.
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;

      _jumpController.repeat();
    });

    _goToNextScreen();
  }

  // ============================================================
  // INTRO ANIMATION
  // ============================================================

  void _setupIntroAnimation() {
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // ----------------------------------------------------------
    // LOGO SCALE
    // ----------------------------------------------------------

    _logoScaleAnimation = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    // ----------------------------------------------------------
    // LOGO FADE
    // ----------------------------------------------------------

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    // ----------------------------------------------------------
    // TEXT FADE
    // ----------------------------------------------------------

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
      ),
    );

    // ----------------------------------------------------------
    // TEXT SLIDE
    // ----------------------------------------------------------

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.35, 0.9, curve: Curves.easeOutCubic),
          ),
        );
  }

  // ============================================================
  // JUMP ANIMATION
  // ============================================================

  void _setupJumpAnimation() {
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _jumpAnimation = TweenSequence<double>([
      // --------------------------------------------------------
      // Jump UP
      // --------------------------------------------------------
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: -28.h,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),

      // --------------------------------------------------------
      // Fall + Bounce
      // --------------------------------------------------------
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -28.h,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 60,
      ),
    ]).animate(_jumpController);
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  Future<void> _goToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 5000));

    if (!mounted) return;

    context.go(AppRoutes.onboarding);
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _introController.dispose();
    _jumpController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRoutes.mainHome);
        }

        if (state is AuthUnauthenticated) {
          context.go(AppRoutes.onboarding);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.primary,
        body: SafeArea(
          child: Stack(
            children: [
              // ======================================================
              // TOP RIGHT DECORATION
              // ======================================================
              Positioned(
                top: -90.h,
                right: -80.w,
                child: Container(
                  width: 220.w,
                  height: 220.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.onPrimary.withValues(alpha: 0.08),
                  ),
                ),
              ),

              // ======================================================
              // BOTTOM LEFT DECORATION
              // ======================================================
              Positioned(
                bottom: -120.h,
                left: -100.w,
                child: Container(
                  width: 280.w,
                  height: 280.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.onPrimary.withValues(alpha: 0.06),
                  ),
                ),
              ),

              // ======================================================
              // CENTER CONTENT
              // ======================================================
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ==================================================
                    // JUMPING CAR LOGO
                    // ==================================================
                    AnimatedBuilder(
                      animation: _jumpAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _jumpAnimation.value),
                          child: child,
                        );
                      },
                      child: FadeTransition(
                        opacity: _logoFadeAnimation,
                        child: ScaleTransition(
                          scale: _logoScaleAnimation,
                          child: _buildLogo(colorScheme),
                        ),
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // ==================================================
                    // APP NAME
                    // ==================================================
                    FadeTransition(
                      opacity: _textFadeAnimation,
                      child: SlideTransition(
                        position: _textSlideAnimation,
                        child: Column(
                          children: [
                            Text(
                              'Auto Rent',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),

                            SizedBox(height: 8.h),

                            Text(
                              'Drive your journey',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimary.withValues(
                                  alpha: 0.75,
                                ),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ======================================================
              // LOADING
              // ======================================================
              Positioned(
                left: 0,
                right: 0,
                bottom: 42.h,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2.w,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary.withValues(alpha: 0.85),
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Text(
                        'Loading...',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onPrimary.withValues(alpha: 0.65),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _buildLogo(ColorScheme colorScheme) {
    return Container(
      width: 118.w,
      height: 118.w,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 25.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Icon(
        Icons.directions_car_rounded,
        size: 66.sp,
        color: colorScheme.primary,
      ),
    );
  }
}
