import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_button.dart';
import 'package:vehicle_rental_system/core/widgets/app_circle_btn.dart';
import 'package:vehicle_rental_system/core/widgets/app_text_field.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/view/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Please enter your email.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Please enter a valid email.';
    }
    return null;
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate a network request. Swap with the real auth API later.
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isSuccess = true;
    });
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: AppDimensions.screenPadding.copyWith(top: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ==================================================
              // BACK BUTTON
              // ==================================================
              Align(
                alignment: Alignment.centerLeft,
                child: AppCircleBtn(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.of(context).pop(),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  iconColor: colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 16.h),

              // ==================================================
              // HEADER
              // ==================================================
              Center(
                child: Container(
                  width: 88.r,
                  height: 88.r,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: _isSuccess
                      ? Icon(
                          Icons.check_circle_rounded,
                          size: 48.r,
                          color: const Color(0xFF26A69A),
                        )
                      : Icon(
                          Icons.lock_reset_rounded,
                          size: 44.r,
                          color: AppColors.primary,
                        ),
                ),
              ),

              SizedBox(height: 20.h),

              Text(
                _isSuccess ? 'Check Your Email' : 'Forgot Password',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),

              SizedBox(height: 8.h),

              Text(
                _isSuccess
                    ? 'We sent a password reset link to your email.'
                    : 'Enter your email and we will send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: 28.h),

              // ==================================================
              // FORM
              // ==================================================
              if (!_isSuccess) ...[
                Form(
                  key: _formKey,
                  child: AppTextField(
                    controller: _emailController,
                    hint: 'Email address',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    validator: _validateEmail,
                    filled: true,
                    onSubmitted: (_) => _sendResetLink(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                AppButton(
                  text: 'Send Reset Link',
                  height: AppDimensions.buttonLargeHeight,
                  borderRadius: AppDimensions.radius12,
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _sendResetLink,
                ),
              ] else ...[
                AppButton(
                  text: 'Back to Login',
                  height: AppDimensions.buttonLargeHeight,
                  borderRadius: AppDimensions.radius12,
                  onPressed: _goToLogin,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
