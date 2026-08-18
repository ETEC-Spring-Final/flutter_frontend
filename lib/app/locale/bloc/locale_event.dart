part of 'locale_bloc.dart';

abstract class LocaleEvent {
  const LocaleEvent();
}

// The event tells BLoC: "The user wants to change the language."
class ChangeLocale extends LocaleEvent {
  final Locale locale;

  const ChangeLocale(this.locale);
}
