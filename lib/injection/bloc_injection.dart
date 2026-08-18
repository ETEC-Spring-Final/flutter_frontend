import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/app/locale/bloc/locale_bloc.dart';
import 'package:vehicle_rental_system/app/theme/bloc/theme_bloc.dart';

final getIt = GetIt.instance;

void registerBlocs() {
  // ==========================================
  // Locale BLoC
  // ==========================================
  getIt.registerFactory<LocaleBloc>(() => LocaleBloc());
  // ==========================================
  // Theme BLoC
  // ==========================================
  getIt.registerFactory<ThemeBloc>(() => ThemeBloc());
}
