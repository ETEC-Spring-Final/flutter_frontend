import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:vehicle_rental_system/app/router/app_routes.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/bloc/auth_bloc.dart';

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
  late final AnimationController _floatController;
  late final AnimationController _glowController;
  late final AnimationController _rotationController;

  // ============================================================
  // ANIMATIONS
  // ============================================================

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;

  late final Animation<double> _floatingY;
  late final Animation<double> _glow;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();

    _setupAnimations();

    _introController.forward();

    _floatController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
    _rotationController.repeat();

    _checkAuthentication();
  }

  // ============================================================
  // AUTHENTICATION
  // ============================================================

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    context.read<AuthBloc>().add(CheckAuthStatus());
  }

  // ============================================================
  // ANIMATIONS
  // ============================================================

  void _setupAnimations() {
    // ----------------------------------------------------------
    // INTRO
    // ----------------------------------------------------------

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // ----------------------------------------------------------
    // LOGO SCALE
    // ----------------------------------------------------------

    _logoScale = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    // ----------------------------------------------------------
    // LOGO FADE
    // ----------------------------------------------------------

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // ----------------------------------------------------------
    // TITLE
    // ----------------------------------------------------------

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
      ),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.35, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    // ----------------------------------------------------------
    // SUBTITLE
    // ----------------------------------------------------------

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.55, 0.95, curve: Curves.easeOut),
      ),
    );

    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.55, 0.95, curve: Curves.easeOutCubic),
          ),
        );

    // ----------------------------------------------------------
    // FLOATING CAR
    // ----------------------------------------------------------

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _floatingY = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // ----------------------------------------------------------
    // GLOW
    // ----------------------------------------------------------

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _glow = Tween<double>(begin: 0.12, end: 0.24).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // ----------------------------------------------------------
    // SUBTLE ROTATION
    // ----------------------------------------------------------

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    _rotation = Tween<double>(
      begin: 0,
      end: math.pi * 2,
    ).animate(_rotationController);
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _introController.dispose();
    _floatController.dispose();
    _glowController.dispose();
    _rotationController.dispose();

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
              // ==================================================
              // BACKGROUND
              // ==================================================
              _buildBackground(colorScheme),

              // ==================================================
              // CENTER CONTENT
              // ==================================================
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ------------------------------------------------
                    // LOGO
                    // ------------------------------------------------
                    FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: AnimatedBuilder(
                          animation: Listenable.merge([
                            _floatController,
                            _glowController,
                          ]),
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _floatingY.value),
                              child: _buildLogo(colorScheme),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // ------------------------------------------------
                    // APP NAME
                    // ------------------------------------------------
                    FadeTransition(
                      opacity: _titleFade,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: _buildTitle(colorScheme),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // ------------------------------------------------
                    // SUBTITLE
                    // ------------------------------------------------
                    FadeTransition(
                      opacity: _subtitleFade,
                      child: SlideTransition(
                        position: _subtitleSlide,
                        child: _buildSubtitle(colorScheme),
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // BOTTOM LOADING
              // ==================================================
              Positioned(
                left: 0,
                right: 0,
                bottom: 38.h,
                child: FadeTransition(
                  opacity: _subtitleFade,
                  child: _buildLoading(colorScheme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BACKGROUND
  // ============================================================

  Widget _buildBackground(ColorScheme colorScheme) {
    return Stack(
      children: [
        // --------------------------------------------------------
        // TOP GLOW
        // --------------------------------------------------------
        Positioned(
          top: -150.h,
          right: -100.w,
          child: AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Container(
                width: 330.w,
                height: 330.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.onPrimary.withValues(alpha: _glow.value),
                ),
              );
            },
          ),
        ),

        // --------------------------------------------------------
        // BOTTOM GLOW
        // --------------------------------------------------------
        Positioned(
          bottom: -170.h,
          left: -130.w,
          child: Container(
            width: 360.w,
            height: 360.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.onPrimary.withValues(alpha: 0.08),
            ),
          ),
        ),

        // --------------------------------------------------------
        // DECORATIVE RING
        // --------------------------------------------------------
        Positioned(
          top: 85.h,
          right: -75.w,
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotation.value,
                child: Container(
                  width: 190.w,
                  height: 190.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.onPrimary.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // --------------------------------------------------------
        // SECOND RING
        // --------------------------------------------------------
        Positioned(
          bottom: 70.h,
          left: -90.w,
          child: Container(
            width: 170.w,
            height: 170.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.onPrimary.withValues(alpha: 0.06),
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _buildLogo(ColorScheme colorScheme) {
    return Container(
      width: 128.w,
      height: 128.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 35.r,
            spreadRadius: 2.r,
            offset: Offset(0, 18.h),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft inner circle
          Container(
            width: 82.w,
            height: 82.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.08),
            ),
          ),

          // Car icon
          Icon(
            Icons.directions_car_rounded,
            size: 66.sp,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TITLE
  // ============================================================

  Widget _buildTitle(ColorScheme colorScheme) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Auto ',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 34.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.2,
            ),
          ),
          TextSpan(
            text: 'Rent',
            style: TextStyle(
              color: colorScheme.onPrimary.withValues(alpha: 0.72),
              fontSize: 34.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: -1.2,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUBTITLE
  // ============================================================

  Widget _buildSubtitle(ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22.w,
          height: 1.h,
          color: colorScheme.onPrimary.withValues(alpha: 0.35),
        ),

        SizedBox(width: 10.w),

        Text(
          'DRIVE YOUR JOURNEY',
          style: TextStyle(
            color: colorScheme.onPrimary.withValues(alpha: 0.68),
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.2,
          ),
        ),

        SizedBox(width: 10.w),

        Container(
          width: 22.w,
          height: 1.h,
          color: colorScheme.onPrimary.withValues(alpha: 0.35),
        ),
      ],
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoading(ColorScheme colorScheme) {
    return Column(
      children: [
        SizedBox(
          width: 26.w,
          height: 26.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            valueColor: AlwaysStoppedAnimation<Color>(
              colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
        ),

        SizedBox(height: 12.h),

        Text(
          'Preparing your journey',
          style: TextStyle(
            color: colorScheme.onPrimary.withValues(alpha: 0.55),
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
