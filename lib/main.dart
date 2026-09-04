import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/app.dart';
import 'package:vehicle_rental_system/app/locale/bloc/locale_bloc.dart';
import 'package:vehicle_rental_system/app/theme/bloc/theme_bloc.dart';
import 'package:vehicle_rental_system/feature/auth/domain/repository/auth_repository.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:vehicle_rental_system/feature/booking/presentation/bloc/booking_bloc.dart';
import 'package:vehicle_rental_system/feature/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vehicle_rental_system/injection/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
        BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(getit<AuthRepository>()),
        ),
        BlocProvider<FavoriteBloc>(create: (_) => getit<FavoriteBloc>()),
        BlocProvider<BookingBloc>(create: (_) => getit<BookingBloc>()),
      ],
      child: const CarRentalApp(),
    ),
  );
}
