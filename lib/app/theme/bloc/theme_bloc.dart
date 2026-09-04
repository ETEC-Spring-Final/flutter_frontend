import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _prefsKey = 'theme_mode';

  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.light)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetLightThemeEvent>(_onSetLightTheme);
    on<SetDarkThemeEvent>(_onSetDarkTheme);

    add(LoadThemeEvent());
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_prefsKey);
      if (stored == null) return;

      final mode = stored == 'dark' ? ThemeMode.dark : ThemeMode.light;
      emit(state.copyWith(themeMode: mode));
    } catch (_) {
      // Ignore: fall back to the default light theme.
    }
  }

  Future<void> _persistTheme(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _prefsKey,
        mode == ThemeMode.dark ? 'dark' : 'light',
      );
    } catch (_) {
      // Ignore persistence errors.
    }
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final next = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(state.copyWith(themeMode: next));
    _persistTheme(next);
  }

  void _onSetLightTheme(SetLightThemeEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(themeMode: ThemeMode.light));
    _persistTheme(ThemeMode.light);
  }

  void _onSetDarkTheme(SetDarkThemeEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(themeMode: ThemeMode.dark));
    _persistTheme(ThemeMode.dark);
  }
}
