import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_button.dart';
import 'package:vehicle_rental_system/core/widgets/app_circle_btn.dart';
import 'package:vehicle_rental_system/core/widgets/app_text_field.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/view/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  /// Optional token prefilled (e.g. from a deep link).
  final String token;

  const ResetPasswordScreen({super.key, this.token = ''});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tokenController;
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(text: widget.token);
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validateToken(String? value) {
    final token = value?.trim() ?? '';
    if (token.isEmpty) return 'Please enter the reset token from your email.';
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Please enter a new password.';
    if (password.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  void _resetPassword() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      ResetPasswordSubmitted(
        token: _tokenController.text.trim(),
        newPassword: _passwordController.text.trim(),
      ),
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
          child: Form(
            key: _formKey,
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
                    child: Icon(
                      Icons.password_rounded,
                      size: 44.r,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                Text(
                  'Reset Password',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Enter the reset token from your email along with your new password.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                SizedBox(height: 28.h),

                // ==================================================
                // RESET TOKEN
                // ==================================================
                AppTextField(
                  controller: _tokenController,
                  hint: 'Reset token',
                  prefixIcon: Icons.key_outlined,
                  textInputAction: TextInputAction.next,
                  validator: _validateToken,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),

                SizedBox(height: 14.h),

                // ==================================================
                // NEW PASSWORD
                // ==================================================
                AppTextField(
                  controller: _passwordController,
                  hint: 'New password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                  filled: true,
                  onChanged: (_) => _formKey.currentState?.validate(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),

                SizedBox(height: 14.h),

                // ==================================================
                // CONFIRM PASSWORD
                // ==================================================
                AppTextField(
                  controller: _confirmController,
                  hint: 'Confirm new password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirm,
                  filled: true,
                  onSubmitted: (_) => _resetPassword(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),

                SizedBox(height: 24.h),

                // ==================================================
                // RESET BUTTON
                // ==================================================
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is ResetPasswordSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password reset successfully!'),
                        ),
                      );
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }

                    if (state is AuthFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return AppButton(
                      text: 'Reset Password',
                      height: AppDimensions.buttonLargeHeight,
                      borderRadius: AppDimensions.radius12,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _resetPassword,
                    );
                  },
                ),

                SizedBox(height: 20.h),

                // ==================================================
                // LOGIN LINK
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remembered your password? ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: Text(
                        'Login',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}