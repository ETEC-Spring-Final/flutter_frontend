import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/app/locale/bloc/locale_bloc.dart';
import 'package:vehicle_rental_system/app/router/app_router.dart';
import 'package:vehicle_rental_system/app/theme/app_theme.dart';
import 'package:vehicle_rental_system/app/theme/bloc/theme_bloc.dart';
import 'package:vehicle_rental_system/l10n/app_localizations.dart';

class CarRentalApp extends StatelessWidget {
  const CarRentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, localeState) {
            return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return MaterialApp.router(
                  title: 'Vehicle Rental App',

                  // THEME
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeState.themeMode,

                  // ROUTER
                  routerConfig: AppRouter.router,

                  // LOCALE
                  locale: localeState.locale,

                  // LOCALIZATION
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],

                  supportedLocales: const [Locale('en'), Locale('km')],
                  debugShowCheckedModeBanner: false,
                );
              },
            );
          },
        );
      },
    );
  }
}
