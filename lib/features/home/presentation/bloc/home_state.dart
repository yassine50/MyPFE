import 'package:pfe/core/models/property_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PropertyModel> allProperties;
  final List<PropertyModel> featuredProperties;
  final List<PropertyModel> colivingProperties;

  HomeLoaded({
    required this.allProperties,
    required this.featuredProperties,
    required this.colivingProperties,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
