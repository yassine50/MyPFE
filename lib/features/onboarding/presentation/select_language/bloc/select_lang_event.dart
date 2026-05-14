part of 'select_lang_bloc.dart';

@immutable
sealed class SelectLangEvent {}

class SelectLanguageEvent extends SelectLangEvent {
  final int index;
  SelectLanguageEvent(this.index);
}
