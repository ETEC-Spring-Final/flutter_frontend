part of 'theme_bloc.dart';

abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class SetLightThemeEvent extends ThemeEvent {}

class SetDarkThemeEvent extends ThemeEvent {}
