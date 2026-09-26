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
  // ANIMATION CONTROLLERS
  // ============================================================

  late final AnimationController _introController;
  late final AnimationController _floatController;
  late final AnimationController _glowController;
  late final AnimationController _rotationController;

  // Text shine
  late final AnimationController _titleShineController;

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

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _setupAnimations();

    // Intro
    _introController.forward();

    // Floating
    _floatController.repeat(reverse: true);

    // Glow
    _glowController.repeat(reverse: true);

    // Rotation
    _rotationController.repeat();

    // Text shine
    _titleShineController.repeat();

    _checkAuthentication();
  }

  // ============================================================
  // SETUP ANIMATIONS
  // ============================================================

  void _setupAnimations() {
    // ------------------------------------------------------------
    // INTRO
    // ------------------------------------------------------------

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // ------------------------------------------------------------
    // FLOAT
    // ------------------------------------------------------------

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // ------------------------------------------------------------
    // GLOW
    // ------------------------------------------------------------

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // ------------------------------------------------------------
    // ROTATION
    // ------------------------------------------------------------

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );

    // ------------------------------------------------------------
    // TITLE SHINE
    // ------------------------------------------------------------

    _titleShineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // ============================================================
    // LOGO
    // ============================================================

    _logoScale = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    // ============================================================
    // TITLE
    // ============================================================

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
      ),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
          ),
        );

    // ============================================================
    // SUBTITLE
    // ============================================================

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.60, 0.90, curve: Curves.easeOut),
      ),
    );

    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.60, 0.90, curve: Curves.easeOutCubic),
          ),
        );

    // ============================================================
    // FLOATING
    // ============================================================

    _floatingY = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // ============================================================
    // GLOW
    // ============================================================

    _glow = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // ============================================================
    // ROTATION
    // ============================================================

    _rotation = Tween<double>(
      begin: 0.0,
      end: math.pi * 2,
    ).animate(_rotationController);
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
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _introController.dispose();
    _floatController.dispose();
    _glowController.dispose();
    _rotationController.dispose();
    _titleShineController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ======================================================
            // BACKGROUND
            // ======================================================
            const _SplashBackground(),

            // ======================================================
            // ROTATING RINGS
            // ======================================================
            AnimatedBuilder(
              animation: _rotation,
              builder: (context, child) {
                return Transform.rotate(angle: _rotation.value, child: child);
              },
              child: _buildRotatingRings(colorScheme),
            ),

            // ======================================================
            // CONTENT
            // ======================================================
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 115.h),
                    // ==================================================
                    // LOGO
                    // ==================================================
                    FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: AnimatedBuilder(
                          animation: _floatController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _floatingY.value),
                              child: child,
                            );
                          },
                          child: _buildLogo(colorScheme),
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // ==================================================
                    // TITLE
                    // ==================================================
                    FadeTransition(
                      opacity: _titleFade,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: _buildTitle(colorScheme),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // ==================================================
                    // SUBTITLE
                    // ==================================================
                    FadeTransition(
                      opacity: _subtitleFade,
                      child: SlideTransition(
                        position: _subtitleSlide,
                        child: _buildSubtitle(colorScheme),
                      ),
                    ),

                    SizedBox(height: 200.h),

                    // ==================================================
                    // LOADING
                    // ==================================================
                    _buildLoading(colorScheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _buildLogo(ColorScheme colorScheme) {
    return Container(
      width: 105.w,
      height: 105.w,
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 35.r,
            spreadRadius: 2.r,
            offset: Offset(0, 15.h),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.directions_car_rounded,
          size: 58.sp,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  // ============================================================
  // TITLE
  //
  // BASE TITLE + WHITE DIAGONAL SHINE OVERLAY
  // ============================================================

  Widget _buildTitle(ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _titleShineController,
      builder: (context, child) {
        final progress = _titleShineController.value;

        return Stack(
          alignment: Alignment.center,
          children: [
            // ------------------------------------------------------
            // 1. NORMAL TITLE
            // ------------------------------------------------------
            _buildTitleText(colorScheme),

            // ------------------------------------------------------
            // 2. WHITE SHINE
            // ------------------------------------------------------
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                // Start outside the left side.
                //
                // Then move all the way to the right.
                final shinePosition = -1.5 + (progress * 3.0);

                return LinearGradient(
                  // Diagonal:
                  //
                  //      ╲
                  //       ╲
                  //        ╲
                  //
                  // Top-left -> Bottom-right
                  begin: Alignment(shinePosition - 0.18, -1.0),
                  end: Alignment(shinePosition + 0.18, 1.0),

                  colors: [
                    Colors.transparent,
                    Colors.transparent,

                    // Soft beginning
                    Colors.white.withValues(alpha: 0.65),

                    // Bright center
                    Colors.white,

                    // Soft ending
                    Colors.white.withValues(alpha: 0.65),

                    Colors.transparent,
                    Colors.transparent,
                  ],

                  stops: const [0.0, 0.40, 0.46, 0.50, 0.54, 0.60, 1.0],
                ).createShader(bounds);
              },

              // IMPORTANT:
              //
              // This text is ONLY the white shine.
              // The normal colored title remains underneath.
              child: _buildTitleShineText(),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // NORMAL TITLE
  // ============================================================

  Widget _buildTitleText(ColorScheme colorScheme) {
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
              color: colorScheme.onPrimary,
              fontSize: 34.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: -1.2,
            ),
          ),

          TextSpan(
            text: ' Premium',
            style: TextStyle(
              color: colorScheme.onPrimary.withValues(alpha: 0.75),
              fontSize: 34.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.2,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WHITE SHINE TEXT
  // ============================================================

  Widget _buildTitleShineText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Auto ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.2,
            ),
          ),

          TextSpan(
            text: 'Rent',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: -1.2,
            ),
          ),

          TextSpan(
            text: ' Premium',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34.sp,
              fontWeight: FontWeight.w700,
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
    return Text(
      'DRIVE YOUR JOURNEY',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: colorScheme.onPrimary.withValues(alpha: 0.72),
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 3.2,
      ),
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
            strokeWidth: 2.2,
            valueColor: AlwaysStoppedAnimation<Color>(
              colorScheme.onPrimary.withValues(alpha: 0.85),
            ),
          ),
        ),

        SizedBox(height: 14.h),

        Text(
          'Preparing your journey',
          style: TextStyle(
            color: colorScheme.onPrimary.withValues(alpha: 0.62),
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ROTATING RINGS
  // ============================================================

  Widget _buildRotatingRings(ColorScheme colorScheme) {
    return IgnorePointer(
      child: Center(
        child: SizedBox(
          width: 430.w,
          height: 430.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 350.w,
                height: 350.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.onPrimary.withValues(alpha: 0.055),
                    width: 1,
                  ),
                ),
              ),

              Container(
                width: 270.w,
                height: 270.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.onPrimary.withValues(alpha: 0.045),
                    width: 1,
                  ),
                ),
              ),

              Container(
                width: 190.w,
                height: 190.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.onPrimary.withValues(alpha: 0.035),
                    width: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// SPLASH BACKGROUND
// ==================================================================

class _SplashBackground extends StatefulWidget {
  const _SplashBackground();

  @override
  State<_SplashBackground> createState() => _SplashBackgroundState();
}

class _SplashBackgroundState extends State<_SplashBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glow = Curves.easeInOut.transform(_controller.value);

        return Stack(
          fit: StackFit.expand,
          children: [
            // ------------------------------------------------------
            // MAIN BACKGROUND
            // ------------------------------------------------------
            ColoredBox(color: colorScheme.primary),

            // ------------------------------------------------------
            // TOP LEFT GLOW
            // ------------------------------------------------------
            Positioned(
              top: -170.h,
              left: -120.w,
              child: _GlowCircle(
                size: 330.w,
                color: colorScheme.onPrimary.withValues(
                  alpha: 0.07 + (glow * 0.025),
                ),
              ),
            ),

            // ------------------------------------------------------
            // BOTTOM RIGHT GLOW
            // ------------------------------------------------------
            Positioned(
              right: -150.w,
              bottom: -180.h,
              child: _GlowCircle(
                size: 370.w,
                color: colorScheme.onPrimary.withValues(
                  alpha: 0.055 + (glow * 0.025),
                ),
              ),
            ),

            // ------------------------------------------------------
            // CENTER GLOW
            // ------------------------------------------------------
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.20,
              left: MediaQuery.sizeOf(context).width * 0.10,
              child: _GlowCircle(
                size: 300.w,
                color: colorScheme.onPrimary.withValues(
                  alpha: 0.025 + (glow * 0.015),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ==================================================================
// GLOW CIRCLE
// ==================================================================

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: size * 0.45,
              spreadRadius: size * 0.08,
            ),
          ],
        ),
      ),
    );
  }
}
