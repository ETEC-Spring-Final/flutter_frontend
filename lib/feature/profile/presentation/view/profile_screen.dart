import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vehicle_rental_system/app/locale/bloc/locale_bloc.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/app/theme/bloc/theme_bloc.dart';
import 'package:vehicle_rental_system/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),

        slivers: [
          // =====================================================
          // App Bar
          // =====================================================
          SliverAppBar(
            automaticallyImplyLeading: false,

            // Hide when scrolling down
            floating: true,

            // Show immediately when scrolling up
            snap: true,

            // Don't stay pinned
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
          ),

          // =====================================================
          // Profile Content
          // =====================================================
          SliverPadding(
            padding: EdgeInsets.all(AppDimensions.chipHorizontalPadding),

            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // =================================================
                  // Profile Header
                  // =================================================
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 32,

                            backgroundImage: NetworkImage(
                              "https://i.pinimg.com/236x/0f/21/77/0f21770c1e42550d64e8c210266141d2.jpg",
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  'Kim Kim Ourn',

                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  'kimkim@example.com',

                                  style: theme.textTheme.bodyMedium,

                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // Settings
                  // =================================================
                  Text(
                    l10n.settings,

                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // =================================================
                  // Language
                  // =================================================
                  BlocBuilder<LocaleBloc, LocaleState>(
                    builder: (context, state) {
                      final currentLocale = state.locale.languageCode;

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.language),

                          title: Text(l10n.language),

                          subtitle: Text(
                            currentLocale == 'km' ? 'ខ្មែរ' : 'English',
                          ),

                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),

                          onTap: () {
                            _showLanguageDialog(context, currentLocale);
                          },
                        ),
                      );
                    },
                  ),

                  // =================================================
                  // Dark Mode
                  // =================================================
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) {
                      return Card(
                        child: SwitchListTile(
                          secondary: Icon(
                            state.isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                          ),

                          title: const Text('Dark Mode'),

                          subtitle: Text(
                            state.isDarkMode ? 'Dark theme' : 'Light theme',
                          ),

                          value: state.isDarkMode,

                          onChanged: (_) {
                            context.read<ThemeBloc>().add(ToggleThemeEvent());
                          },
                        ),
                      );
                    },
                  ),

                  // =================================================
                  // Extra content
                  // =================================================
                  const SizedBox(height: 24),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.book_online),

                      title: const Text('My Bookings'),

                      subtitle: const Text('View your bookings'),

                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                      onTap: onBookingsTap,
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.favorite),

                      title: const Text('Favorites'),

                      subtitle: const Text('View your favorite vehicles'),

                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                      onTap: onFavoritesTap,
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.explore),

                      title: const Text('Explore Vehicles'),

                      subtitle: const Text('Find your next vehicle'),

                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                      onTap: onExploreTap,
                    ),
                  ),

                  // =================================================
                  // Bottom spacing
                  // =================================================
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      /*
      appBar: AppAppBar(centerTitle: false, title: l10n.profile),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.chipHorizontalPadding,
        ),
        child: ListView(
          children: [
            // ==========================================
            // Profile Header
            // ==========================================
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://scontent.fpnh2-2.fna.fbcdn.net/v/t39.30808-6/491968431_1333977137906097_3745547215927394055_n.jpg?stp=dst-jpg_tt6&cstp=mx970x960&ctp=s970x960&_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGX2jXOvNyFkMdU_nHv0_TBLC6QkSp9leUsLpCRKn2V5Uv6wof_Vu5Xc0cjDDFK8I_KxOLFewIUlVXw94akzmKm&_nc_ohc=28p1SuhBkPwQ7kNvwGT5yx6&_nc_oc=AdrUW13_mAxCDkK_fOI2s8--AA2xyqLU9DXhRp2uEMYLB12LE_V1B0Jowg_7Y3R4qAo&_nc_zt=23&_nc_ht=scontent.fpnh2-2.fna&_nc_gid=s_fbaJLoBIWod-PWjdIzRA&_nc_ss=7b2a8&oh=00_AQGN5_K1c1NL_vzQZLKregsB4kTjJFJsv772ceprkaPguA&oe=6A8A8437",
                      ),
                      radius: 32,

                      //child: Icon(Icons.person, size: 36),
                    ),

                    const SizedBox(width: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sorn Visal',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'visal@example.com',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ==========================================
            // Settings
            // ==========================================
            Text(
              l10n.settings,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // ==========================================
            // Language
            // ==========================================
            BlocBuilder<LocaleBloc, LocaleState>(
              builder: (context, state) {
                final currentLocale = state.locale.languageCode;

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.language),

                    title: Text(l10n.language),

                    subtitle: Text(currentLocale == 'km' ? 'ខ្មែរ' : 'English'),

                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                    onTap: () {
                      _showLanguageDialog(context, currentLocale);
                    },
                  ),
                );
              },
            ),

            // ==========================================
            // Dark Mode
            // ==========================================
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Card(
                  child: SwitchListTile(
                    secondary: Icon(
                      state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    ),

                    title: const Text('Dark Mode'),

                    subtitle: Text(
                      state.isDarkMode ? 'Dark theme' : 'Light theme',
                    ),

                    value: state.isDarkMode,

                    onChanged: (value) {
                      context.read<ThemeBloc>().add(ToggleThemeEvent());
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ), 


      */
    );
  }

  // ==========================================
  // Language Dialog
  // ==========================================

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
              // ========================================
              // English
              // ========================================
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

              // ========================================
              // Khmer
              // ========================================
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
}
