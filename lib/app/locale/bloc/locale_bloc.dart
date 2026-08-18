import 'dart:ui';
import 'package:bloc/bloc.dart';

part 'locale_event.dart';
part 'locale_state.dart';

// BLoC handles: ChangeLocale -> LocaleBloc -> LocaleState

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState()) {
    on<ChangeLocale>(_onChangeLocale);
  }

  void _onChangeLocale(ChangeLocale event, Emitter<LocaleState> emit) {
    emit(LocaleState(locale: event.locale));
  }
}
