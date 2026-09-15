import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/app/locale/bloc/locale_bloc.dart';
import 'package:vehicle_rental_system/app/theme/bloc/theme_bloc.dart';
import 'package:vehicle_rental_system/feature/booking/domain/repository/booking_repository.dart';
import 'package:vehicle_rental_system/feature/booking/presentation/bloc/booking_bloc.dart';
import 'package:vehicle_rental_system/feature/favorite/domain/repository/favorite_repository.dart';
import 'package:vehicle_rental_system/feature/favorite/presentation/bloc/favorite_bloc.dart';

final sl = GetIt.instance;

void registerBlocs() {
  // Locale BLoC

  sl.registerFactory<LocaleBloc>(() => LocaleBloc());

  // Theme BLoC

  sl.registerFactory<ThemeBloc>(() => ThemeBloc());

  // Auth Bloc

  // sl.registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepository>()));

  // Favorite BLoC

  sl.registerFactory<FavoriteBloc>(
    () => FavoriteBloc(sl<FavoriteRepository>()),
  );

  // Booking BLoC

  sl.registerFactory<BookingBloc>(() => BookingBloc(sl<BookingRepository>()));
}
