part of 'locale_bloc.dart';

// The state stores the current language. Initially: Locale('en')
// After selecting Khmer: Locale('km')
class LocaleState {
  final Locale locale;

  const LocaleState({this.locale = const Locale('en')});
}
