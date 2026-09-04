import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/app/locale/bloc/locale_bloc.dart';
import 'package:vehicle_rental_system/app/theme/bloc/theme_bloc.dart';
import 'package:vehicle_rental_system/feature/auth/domain/repository/auth_repository.dart';
import 'package:vehicle_rental_system/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:vehicle_rental_system/feature/booking/domain/repository/booking_repository.dart';
import 'package:vehicle_rental_system/feature/booking/presentation/bloc/booking_bloc.dart';
import 'package:vehicle_rental_system/feature/favorite/domain/repository/favorite_repository.dart';
import 'package:vehicle_rental_system/feature/favorite/presentation/bloc/favorite_bloc.dart';

final getIt = GetIt.instance;

void registerBlocs() {
  // Locale BLoC

  getIt.registerFactory<LocaleBloc>(() => LocaleBloc());

  // Theme BLoC

  getIt.registerFactory<ThemeBloc>(() => ThemeBloc());

  // Auth Bloc

  // getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));

  // Favorite BLoC

  getIt.registerFactory<FavoriteBloc>(
    () => FavoriteBloc(getIt<FavoriteRepository>()),
  );

  // Booking BLoC

  getIt.registerFactory<BookingBloc>(
    () => BookingBloc(getIt<BookingRepository>()),
  );
}
