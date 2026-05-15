import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfe/features/home/data/repositories/property_repository.dart';
import 'package:pfe/core/models/property_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PropertyRepository _repository;

  HomeBloc(this._repository) : super(HomeInitial()) {
    on<LoadProperties>(_onLoadProperties);
  }

  Future<void> _onLoadProperties(LoadProperties event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final properties = await _repository.fetchProperties();
      
      final featured = properties.where((p) => p.isFeatured).toList();
      final coliving = properties.where((p) => p.isColiving).toList();

      emit(HomeLoaded(
        featuredProperties: featured,
        colivingProperties: coliving,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
