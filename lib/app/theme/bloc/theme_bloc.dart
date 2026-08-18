import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.light)) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetLightThemeEvent>(_onSetLightTheme);
    on<SetDarkThemeEvent>(_onSetDarkTheme);
  }
  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    if (state.themeMode == ThemeMode.light) {
      emit(state.copyWith(themeMode: ThemeMode.dark));
    } else {
      emit(state.copyWith(themeMode: ThemeMode.light));
    }
  }

  void _onSetLightTheme(SetLightThemeEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(themeMode: ThemeMode.light));
  }

  void _onSetDarkTheme(SetDarkThemeEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(themeMode: ThemeMode.dark));
  }
}
