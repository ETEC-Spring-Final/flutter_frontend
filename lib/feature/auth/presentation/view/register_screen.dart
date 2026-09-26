import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:vehicle_rental_system/app/router/app_routes.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_button.dart';
import 'package:vehicle_rental_system/core/widgets/app_circle_btn.dart';
import 'package:vehicle_rental_system/core/widgets/app_text_field.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _selectedGender;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  static const _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ============================================================
  // VALIDATORS
  // ============================================================

  String? _validateFirstName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Enter your first name.';
    }

    if (name.length < 2) {
      return 'First name is too short.';
    }

    return null;
  }

  String? _validateLastName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Enter your last name.';
    }

    if (name.length < 2) {
      return 'Last name is too short.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Enter your email.';
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email.';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Enter your phone number.';
    }

    if (!RegExp(r'^[0-9+\-\s]{7,15}$').hasMatch(phone)) {
      return 'Enter a valid phone number.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a password.';
    }

    if (value.length < 6) {
      return 'Use at least 6 characters.';
    }

    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password.';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match.';
    }

    return null;
  }

  String? _validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Select your gender.';
    }

    return null;
  }

  // ============================================================
  // SIGN UP
  // ============================================================

  void _signUp() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
      RegisterSubmitted(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: _selectedGender!.toUpperCase(),
      ),
    );
  }

  // ============================================================
  // FIELD DECORATION
  // ============================================================

  InputDecoration _inputDecoration(
    BuildContext context, {
    required IconData icon,
    required String hint,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InputDecoration(
      hintText: hint,
      hintStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(icon, size: 21.r, color: colorScheme.onSurfaceVariant),
      suffixIcon: suffixIcon,

      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.38),

      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: colorScheme.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
    );
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

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            padding: EdgeInsets.all(AppDimensions.chipHorizontalPadding),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==================================================
                // TOP BAR
                // ==================================================
                Row(
                  children: [
                    AppCircleBtn(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => context.pop(),
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      iconColor: colorScheme.onSurface,
                    ),

                    const Spacer(),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 7.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_car_rounded,
                            size: 15.r,
                            color: colorScheme.primary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'AUTO RENT Premium',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 28.h),

                // ==================================================
                // MODERN HEADER
                // ==================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 62.r,
                      height: 62.r,

                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withValues(alpha: 0.72),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),

                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.20),
                            blurRadius: 20.r,
                            offset: Offset(0, 8.h),
                          ),
                        ],
                      ),

                      child: Icon(
                        Icons.person_add_alt_1_rounded,
                        color: Colors.white,
                        size: 30.r,
                      ),
                    ),

                    SizedBox(width: 16.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create your account',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.7,
                            ),
                          ),

                          SizedBox(height: 5.h),

                          Text(
                            'Start your journey with Auto Rent.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30.h),

                // ==================================================
                // PERSONAL INFORMATION LABEL
                // ==================================================
                _SectionTitle(
                  icon: Icons.person_outline_rounded,
                  title: 'Personal information',
                ),

                SizedBox(height: 14.h),

                // ==================================================
                // FIRST + LAST NAME
                // ==================================================
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _firstNameController,
                        hint: 'First name',
                        prefixIcon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                        validator: _validateFirstName,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: AppTextField(
                        controller: _lastNameController,
                        hint: 'Last name',
                        prefixIcon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                        validator: _validateLastName,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                // ==================================================
                // EMAIL
                // ==================================================
                AppTextField(
                  controller: _emailController,
                  hint: 'Email address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),

                SizedBox(height: 14.h),

                // ==================================================
                // PHONE
                // ==================================================
                AppTextField(
                  controller: _phoneController,
                  hint: 'Phone number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: _validatePhone,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),

                SizedBox(height: 14.h),

                // ==================================================
                // GENDER
                // ==================================================
                DropdownButtonFormField<String>(
                  initialValue: _selectedGender,

                  hint: Text(
                    'Select gender',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),

                  decoration: _inputDecoration(
                    context,
                    icon: Icons.wc_outlined,
                    hint: 'Select gender',
                  ).copyWith(hintText: null),

                  dropdownColor: colorScheme.surface,

                  borderRadius: BorderRadius.circular(16.r),

                  items: _genderOptions
                      .map(
                        (gender) => DropdownMenuItem<String>(
                          value: gender,
                          child: Text(
                            gender,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),

                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },

                  validator: _validateGender,
                ),

                SizedBox(height: 28.h),

                // ==================================================
                // SECURITY SECTION
                // ==================================================
                _SectionTitle(
                  icon: Icons.lock_outline_rounded,
                  title: 'Account security',
                ),

                SizedBox(height: 14.h),

                // ==================================================
                // PASSWORD
                // ==================================================
                AppTextField(
                  controller: _passwordController,
                  hint: 'Password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                  filled: true,

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 21.r,
                    ),
                  ),

                  onChanged: (_) {
                    if (_confirmController.text.isNotEmpty) {
                      _formKey.currentState?.validate();
                    }
                  },

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
                  hint: 'Confirm password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirm,
                  filled: true,

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 21.r,
                    ),
                  ),

                  onSubmitted: (_) => _signUp(),

                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),

                SizedBox(height: 12.h),

                // ==================================================
                // PASSWORD INFO
                // ==================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16.r,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 7.w),
                    Expanded(
                      child: Text(
                        'Use at least 6 characters for a secure password.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 26.h),

                // ==================================================
                // SIGN UP BUTTON
                // ==================================================
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Account created successfully!'),
                        ),
                      );

                      context.go(AppRoutes.mainHome);
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
                      text: 'Create Account',
                      height: 56.h,
                      borderRadius: 16.r,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _signUp,
                    );
                  },
                ),

                SizedBox(height: 20.h),

                // ==================================================
                // LOGIN
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(width: 5.w),

                    GestureDetector(
                      onTap: () => context.pop(),

                      child: Text(
                        'Login',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // ==================================================
                // TERMS
                // ==================================================
                Text(
                  'By creating an account, you agree to our Terms & Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// SECTION TITLE
// ================================================================

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 30.r,
          height: 30.r,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: Icon(icon, size: 17.r, color: colorScheme.primary),
        ),

        SizedBox(width: 9.w),

        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}
