import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pfe/core/localization/app_strings.dart';

part 'select_lang_event.dart';
part 'select_lang_state.dart';

class SelectLangBloc extends Bloc<SelectLangEvent, SelectLangState> {
  SelectLangBloc() : super(SelectLangInitial(selectedIndex: Hive.box('settings').get('languageIndex', defaultValue: 0))) {
    AppStrings.currentLangIndex = Hive.box('settings').get('languageIndex', defaultValue: 0);

    on<SelectLanguageEvent>((event, emit) async {
      final box = Hive.box('settings');
      await box.put('languageIndex', event.index);
      AppStrings.currentLangIndex = event.index;
      emit(SelectLangInitial(selectedIndex: event.index));
    });
  }
}
