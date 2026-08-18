import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_rental_system/app/locale/bloc/locale_bloc.dart';
import 'package:vehicle_rental_system/app/router/app_router.dart';
import 'package:vehicle_rental_system/app/theme/bloc/theme_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vehicle_rental_system/app/theme/app_theme.dart';
import 'package:vehicle_rental_system/l10n/app_localizations.dart';

class CarRentalApp extends StatelessWidget {
  const CarRentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, localeState) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              title: "Vehicle Rental System",
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.themeMode,
              // Router
              routerConfig: AppRouter.router,
              // Current language (Locale) from the BLoC state
              locale: localeState.locale,
              // Localization
              // Run Command: flutter gen-l10n
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              // Languages
              supportedLocales: [Locale('en'), Locale('km')],
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
