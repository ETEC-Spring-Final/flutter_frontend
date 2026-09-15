import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/app.dart';
import 'package:vehicle_rental_system/app/locale/bloc/locale_bloc.dart';
import 'package:vehicle_rental_system/app/theme/bloc/theme_bloc.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:vehicle_rental_system/feature/booking/presentation/bloc/booking_bloc.dart';
import 'package:vehicle_rental_system/feature/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'package:vehicle_rental_system/core/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
        BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<FavoriteBloc>(create: (_) => sl<FavoriteBloc>()),
        BlocProvider<BookingBloc>(create: (_) => sl<BookingBloc>()),
        BlocProvider<VehicleBloc>(create: (_) => sl<VehicleBloc>()),
      ],
      child: const CarRentalApp(),
    ),
  );
}
