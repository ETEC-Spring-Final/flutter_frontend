import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import 'package:vehicle_rental_system/app/locale/bloc/locale_bloc.dart';
import 'package:vehicle_rental_system/app/router/app_routes.dart';
import 'package:vehicle_rental_system/app/theme/app_colors.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/app/theme/bloc/theme_bloc.dart';
import 'package:vehicle_rental_system/core/constants/app_constants.dart';
import 'package:vehicle_rental_system/core/widgets/app_dialog.dart';
import 'package:vehicle_rental_system/core/widgets/app_loading.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:vehicle_rental_system/feature/booking/presentation/bloc/booking_bloc.dart';
import 'package:vehicle_rental_system/feature/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vehicle_rental_system/feature/profile/domain/entity/user_profile.dart';
import 'package:vehicle_rental_system/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:vehicle_rental_system/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onHomeTap;
  final VoidCallback? onExploreTap;
  final VoidCallback? onBookingsTap;
  final VoidCallback? onFavoritesTap;

  const ProfileScreen({
    super.key,
    this.onHomeTap,
    this.onExploreTap,
    this.onBookingsTap,
    this.onFavoritesTap,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;

  Future<void> _refreshProfile() async {
    final bloc = context.read<ProfileBloc>();
    bloc.add(const LoadProfileEvent());
    await bloc.stream.firstWhere(
      (state) => state is! ProfileLoading && state is! ProfileInitial,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRoutes.login);
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.failure.message)));
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final profile = switch (state) {
                ProfileLoaded(profile: final p) => p,
                ProfileUpdating(profile: final p) => p,
                ProfileError(cached: final UserProfile? p) => p,
                _ => null,
              };

              final isBusy = state is ProfileLoading || state is ProfileInitial;

              final isLoading = isBusy && profile == null;

              return RefreshIndicator(
                onRefresh: _refreshProfile,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      floating: true,
                      snap: true,
                      pinned: false,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                      surfaceTintColor: Colors.transparent,
                      titleSpacing: 16,
                      centerTitle: false,
                      title: Text(
                        l10n.profile,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      actions: [
                        TextButton.icon(
                          onPressed: () {
                            context.read<AuthBloc>().add(LogoutRequested());
                          },
                          icon: Icon(
                            Icons.logout_rounded,
                            size: 20.r,
                            color: theme.colorScheme.error,
                          ),
                          label: Text(
                            'Logout',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.chipHorizontalPadding,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isLoading) ...[
                              const _ProfileLoadingSkeleton(),
                            ] else ...[
                              if (state is ProfileError && profile == null)
                                _ProfileLoadError(
                                  message: state.failure.message,
                                  onRetry: () => context
                                      .read<ProfileBloc>()
                                      .add(const LoadProfileEvent()),
                                )
                              else
                                _ProfileHeader(
                                  profile: profile,
                                  localImage: _profileImage,
                                  defaultAvatar: AppConstants.defaultAvatar,
                                  loading: isLoading,
                                  updating: state is ProfileUpdating,
                                  onEditTap: _pickProfileImage,
                                ),

                              SizedBox(height: 24.h),

                              Row(
                                children: [
                                  BlocBuilder<BookingBloc, BookingState>(
                                    builder: (context, bookingState) {
                                      final bookings =
                                          bookingState is BookingLoaded
                                          ? bookingState.bookings.length
                                          : 0;
                                      return _StatCard(
                                        icon: Icons.book_online_rounded,
                                        value: '$bookings',
                                        label: 'Bookings',
                                      );
                                    },
                                  ),
                                  SizedBox(width: 12.w),
                                  BlocBuilder<FavoriteBloc, FavoriteState>(
                                    builder: (context, favoriteState) {
                                      final favorites =
                                          favoriteState is FavoriteLoaded
                                          ? favoriteState.favoriteIds.length
                                          : 0;
                                      return _StatCard(
                                        icon: Icons.favorite_rounded,
                                        value: '$favorites',
                                        label: 'Favorites',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],

                            SizedBox(height: 28.h),

                            _SectionTitle(title: l10n.settings),

                            SizedBox(height: 12.h),

                            _MenuCard(
                              children: [
                                BlocBuilder<LocaleBloc, LocaleState>(
                                  builder: (context, localeState) {
                                    final current =
                                        localeState.locale.languageCode;
                                    return _MenuTile(
                                      icon: Icons.language_rounded,
                                      title: l10n.language,
                                      subtitle: current == 'km'
                                          ? 'Khmer (ខ្មែរ)'
                                          : 'English',
                                      onTap: () {
                                        _showLanguageDialog(context, current);
                                      },
                                    );
                                  },
                                ),

                                BlocBuilder<ThemeBloc, ThemeState>(
                                  builder: (context, themeState) {
                                    return SwitchListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      activeThumbColor:
                                          theme.colorScheme.primary,
                                      secondary: Container(
                                        width: 38.r,
                                        height: 38.r,
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary
                                              .withValues(alpha: 0.10),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          themeState.isDarkMode
                                              ? Icons.dark_mode_rounded
                                              : Icons.light_mode_rounded,
                                          size: 20.r,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      title: Text(
                                        'Dark Mode',
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      subtitle: Text(
                                        themeState.isDarkMode
                                            ? 'Dark theme'
                                            : 'Light theme',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                      value: themeState.isDarkMode,
                                      onChanged: (_) {
                                        context.read<ThemeBloc>().add(
                                          ToggleThemeEvent(),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),

                            SizedBox(height: 24.h),

                            _SectionTitle(title: 'My Activity'),

                            SizedBox(height: 12.h),

                            _MenuCard(
                              children: [
                                _MenuTile(
                                  icon: Icons.book_online_outlined,
                                  title: 'My Bookings',
                                  subtitle: 'View and manage bookings',
                                  onTap: widget.onBookingsTap,
                                ),
                                _MenuTile(
                                  icon: Icons.favorite_border_rounded,
                                  title: 'Favorites',
                                  subtitle: 'Cars you have liked',
                                  onTap: widget.onFavoritesTap,
                                ),
                                _MenuTile(
                                  icon: Icons.explore_outlined,
                                  title: 'Explore Vehicles',
                                  subtitle: 'Find your next ride',
                                  onTap: widget.onExploreTap,
                                ),
                              ],
                            ),

                            /*

                            SizedBox(height: 24.h),

                            _SectionTitle(title: 'Developer Tools'),

                            SizedBox(height: 12.h),

                            _MenuCard(
                              children: [
                                _MenuTile(
                                  icon: Icons.build_outlined,
                                  title: 'Vehicle CRUD (Test)',
                                  subtitle: 'Create, edit and delete vehicles',
                                  onTap: () =>
                                      context.push(AppRoutes.vehicleCrud),
                                ),
                              ],
                            ),

                            */
                            SizedBox(height: 24.h),

                            /*
                            
                            Center(
                              child: TextButton.icon(
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                    LogoutRequested(),
                                  );
                                },
                                icon: Icon(
                                  Icons.logout_rounded,
                                  size: 20.r,
                                  color: theme.colorScheme.error,
                                ),
                                label: Text(
                                  'Logout',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            */
                            Center(
                              child: SizedBox(
                                height: 45.h,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final confirmLogout =
                                        await AppDialog.showConfirmation(
                                          context: context,
                                          title: 'Logout',
                                          message: 'Do you want to logout?',
                                          confirmText: 'Confirm',
                                        );

                                    if (confirmLogout != true) {
                                      return;
                                    }
                                    // Loading
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return Dialog.fullscreen(
                                          backgroundColor: Colors.transparent,
                                          child: AppLoading(),
                                        );
                                      },
                                    );
                                    // Delay
                                    await Future.delayed(
                                      const Duration(seconds: 3),
                                    );

                                    if (!mounted) return;

                                    Navigator.of(context).pop();

                                    if (confirmLogout == true) {
                                      context.read<AuthBloc>().add(
                                        LogoutRequested(),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: AppColors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.radius8,
                                      ),
                                    ),
                                  ),
                                  child: Text('Logout'),
                                ),
                              ),
                            ),

                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // =====================================================
  // Language Dialog
  // =====================================================
  void _showLanguageDialog(BuildContext context, String currentLocale) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                value: 'en',
                groupValue: currentLocale,
                title: const Text('English'),
                secondary: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
                onChanged: (value) {
                  if (value == null) return;
                  context.read<LocaleBloc>().add(
                    const ChangeLocale(Locale('en')),
                  );
                  Navigator.pop(dialogContext);
                },
              ),
              RadioListTile<String>(
                value: 'km',
                groupValue: currentLocale,
                title: const Text('ខ្មែរ'),
                secondary: const Text('🇰🇭', style: TextStyle(fontSize: 24)),
                onChanged: (value) {
                  if (value == null) return;
                  context.read<LocaleBloc>().add(
                    const ChangeLocale(Locale('km')),
                  );
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // =====================================================
  // Profile Image Picker
  // =====================================================
  Future<void> _pickProfileImage() async {
    final picked = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Theme.of(
                    sheetContext,
                  ).colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take a Photo'),
                onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );

    if (picked == null) return;

    try {
      final image = await ImagePicker().pickImage(
        source: picked,
        imageQuality: 85,
        maxWidth: 1000,
      );
      if (image == null) return;
      if (!mounted) return;

      setState(() => _profileImage = File(image.path));
      context.read<ProfileBloc>().add(UpdateProfilePictureEvent(image.path));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not pick an image. Please try again.'),
        ),
      );
    }
  }
}

// =====================================================================
// PROFILE LOADING SKELETON (shimmer placeholder)
// =====================================================================

class _ProfileLoadingSkeleton extends StatelessWidget {
  const _ProfileLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fill = colorScheme.surfaceContainerHighest;

    Widget bar(double width, double height) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    Widget statSkeleton() {
      return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Column(
            children: [
              Container(
                width: 22.r,
                height: 22.r,
                decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
              ),
              SizedBox(height: 8.h),
              bar(64.w, 16),
              SizedBox(height: 2.h),
              bar(80.w, 10),
            ],
          ),
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: fill,
      highlightColor: colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Row(
              children: [
                Container(
                  width: 68.r,
                  height: 68.r,
                  decoration: BoxDecoration(
                    color: fill,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bar(140.w, 18),
                      SizedBox(height: 8.h),
                      bar(180.w, 14),
                      SizedBox(height: 8.h),
                      bar(100.w, 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              statSkeleton(),
              SizedBox(width: 12.w),
              statSkeleton(),
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// PROFILE HEADER
// =====================================================================

class _ProfileHeader extends StatelessWidget {
  final UserProfile? profile;
  final File? localImage;
  final String defaultAvatar;
  final bool loading;
  final bool updating;
  final VoidCallback onEditTap;

  const _ProfileHeader({
    required this.profile,
    required this.localImage,
    required this.defaultAvatar,
    required this.loading,
    required this.updating,
    required this.onEditTap,
  });

  ImageProvider _avatar() {
    if (localImage != null) return FileImage(localImage!);

    final pictureUrl = profile?.profilePicture;
    if (pictureUrl != null && pictureUrl.isNotEmpty) {
      return NetworkImage(pictureUrl);
    }

    return NetworkImage(defaultAvatar);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final name = profile?.fullName ?? '';
    final email = profile?.email ?? '';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(radius: 34.r, backgroundImage: _avatar()),
              if (loading || updating)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.scrim.withValues(alpha: 0.35),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: onEditTap,
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.surface, width: 2),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 12.r,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 16.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? (loading ? 'Loading…' : 'Your Profile') : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  email.isEmpty
                      ? (loading ? 'Fetching your account…' : '—')
                      : email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 14.r,
                      color: profile?.active ?? false
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      (profile?.active ?? false)
                          ? 'Verified Member'
                          : 'Account Inactive',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: profile?.active ?? false
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// PROFILE LOAD ERROR
// =====================================================================

class _ProfileLoadError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProfileLoadError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 40.r,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 12.h),
          Text(
            'Could not load your profile',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            message,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 12.h),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// STAT CARD
// =====================================================================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22.r, color: colorScheme.primary),
            SizedBox(height: 8.h),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// SECTION TITLE
// =====================================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

// =====================================================================
// MENU CARD (groups tiles together)
// =====================================================================

class _MenuCard extends StatelessWidget {
  final List<Widget> children;

  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                indent: 68.w,
                color: colorScheme.outline,
              ),
          ],
        ],
      ),
    );
  }
}

// =====================================================================
// MENU TILE
// =====================================================================

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      leading: Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.10),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20.r, color: colorScheme.primary),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16.r,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
