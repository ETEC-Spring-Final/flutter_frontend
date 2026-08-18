import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vehicle_rental_system/app/locale/bloc/locale_bloc.dart';
import 'package:vehicle_rental_system/app/theme/bloc/theme_bloc.dart';
import 'package:vehicle_rental_system/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),

      body: ListView(
        padding: const EdgeInsets.all(16),
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
                    radius: 32,
                    child: Icon(Icons.person, size: 36),
                  ),

                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'john@example.com',
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
