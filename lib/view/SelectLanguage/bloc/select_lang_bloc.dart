import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'select_lang_event.dart';
part 'select_lang_state.dart';

class SelectLangBloc extends Bloc<SelectLangEvent, SelectLangState> {
  SelectLangBloc() : super(SelectLangInitial()) {
    on<SelectLanguageEvent>((event, emit) {
      emit(SelectLangInitial(selectedIndex: event.index));
    });
  }
}