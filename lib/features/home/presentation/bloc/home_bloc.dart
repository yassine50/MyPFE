import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfe/features/home/data/repositories/property_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      final allProps = await _repository.fetchProperties();
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      
      // Filter out properties owned by the current user
      final properties = allProps.where((p) => p.hostId != currentUserId).toList();
      
      final featured = properties.where((p) => p.isFeatured).toList();
      final coliving = properties.where((p) => p.isColiving).toList();

      emit(HomeLoaded(
        allProperties: properties,
        featuredProperties: featured,
        colivingProperties: coliving,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
