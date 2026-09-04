import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:vehicle_rental_system/app/locale/bloc/locale_bloc.dart';
import 'package:vehicle_rental_system/app/router/app_routes.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/app/theme/bloc/theme_bloc.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/bloc/auth_bloc.dart';
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

  static const String _defaultAvatar =
      "https://i.pinimg.com/736x/9d/16/4e/9d164e4e074d11ce4de0a508914537a8.jpg";

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
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: true,
              snap: true,
              pinned: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (_) => const _LogoutPlaceholder(),
                    //   ),
                    // );
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
                    // =====================================================
                    // PROFILE HEADER CARD
                    // =====================================================
                    _ProfileHeader(
                      image: _profileImage,
                      defaultAvatar: _defaultAvatar,
                      onEditTap: _pickProfileImage,
                    ),

                    SizedBox(height: 24.h),

                    // =====================================================
                    // QUICK STATS
                    // =====================================================
                    Row(
                      children: [
                        _StatCard(
                          icon: Icons.route_rounded,
                          value: '12',
                          label: 'Trips',
                        ),
                        SizedBox(width: 12.w),
                        _StatCard(
                          icon: Icons.book_online_rounded,
                          value: '3',
                          label: 'Bookings',
                        ),
                        SizedBox(width: 12.w),
                        _StatCard(
                          icon: Icons.favorite_rounded,
                          value: '7',
                          label: 'Favorites',
                        ),
                      ],
                    ),

                    SizedBox(height: 28.h),

                    // =====================================================
                    // MY ACTIVITY
                    // =====================================================
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

                    SizedBox(height: 24.h),

                    // =====================================================
                    // SETTINGS
                    // =====================================================
                    _SectionTitle(title: l10n.settings),

                    SizedBox(height: 12.h),

                    _MenuCard(
                      children: [
                        // ---------- Language ----------
                        BlocBuilder<LocaleBloc, LocaleState>(
                          builder: (context, state) {
                            final current = state.locale.languageCode;
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

                        // ---------- Dark Mode ----------
                        BlocBuilder<ThemeBloc, ThemeState>(
                          builder: (context, state) {
                            return SwitchListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                              ),
                              activeThumbColor: theme.colorScheme.primary,
                              secondary: Container(
                                width: 38.r,
                                height: 38.r,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.10,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  state.isDarkMode
                                      ? Icons.dark_mode_rounded
                                      : Icons.light_mode_rounded,
                                  size: 20.r,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              title: Text(
                                'Dark Mode',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                state.isDarkMode ? 'Dark theme' : 'Light theme',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              value: state.isDarkMode,
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

                    // =====================================================
                    // SUPPORT
                    // =====================================================
                    _SectionTitle(title: 'Support'),

                    SizedBox(height: 12.h),

                    _MenuCard(
                      children: [
                        _MenuTile(
                          icon: Icons.help_outline_rounded,
                          title: 'Help Center',
                          subtitle: 'Get answers and support',
                          onTap: () {},
                        ),
                        _MenuTile(
                          icon: Icons.receipt_long_outlined,
                          title: 'Terms & Privacy',
                          subtitle: 'Policies and agreements',
                          onTap: () {},
                        ),
                        _MenuTile(
                          icon: Icons.info_outline_rounded,
                          title: 'About',
                          subtitle: 'Vehicle Rental System v1.0.0',
                          onTap: () {},
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // =====================================================
                    // LOGOUT
                    // =====================================================
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          context.read<AuthBloc>().add(LogoutRequested());
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (_) => const _LogoutPlaceholder(),
                          //   ),
                          // );
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

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
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
// PROFILE HEADER
// =====================================================================

class _ProfileHeader extends StatelessWidget {
  final File? image;
  final String defaultAvatar;
  final VoidCallback onEditTap;

  const _ProfileHeader({
    required this.image,
    required this.defaultAvatar,
    required this.onEditTap,
  });

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
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 34.r,
                backgroundImage: image != null
                    ? FileImage(File(image!.path))
                    : NetworkImage(defaultAvatar) as ImageProvider,
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
                  'Kim Kim Ourn',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'kimkim@example.com',
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
                      color: colorScheme.primary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Verified Member',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
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

// =====================================================================
// Logout placeholder (kept minimal)
// =====================================================================

// class _LogoutPlaceholder extends StatelessWidget {
//   const _LogoutPlaceholder();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Logout')),
//       body: const Center(child: Text('Logout feature coming soon')),
//     );
//   }
// }
