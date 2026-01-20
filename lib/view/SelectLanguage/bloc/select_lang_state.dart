part of 'select_lang_bloc.dart';

@immutable
sealed class SelectLangState {}

class SelectLangInitial extends SelectLangState {
  final int selectedIndex;
  SelectLangInitial({this.selectedIndex = 0});
}
