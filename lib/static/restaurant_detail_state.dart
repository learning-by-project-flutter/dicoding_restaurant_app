import 'package:dicoding_restaurant_app/data/model/restaurant_detail.dart';

sealed class RestaurantDetailState {}

class RestaurantDetailInitial extends RestaurantDetailState {}

class RestaurantDetailLoading extends RestaurantDetailState {}

class RestaurantDetailSuccess extends RestaurantDetailState {
  final RestaurantDetail restaurant;
  RestaurantDetailSuccess(this.restaurant);
}

class RestaurantDetailError extends RestaurantDetailState {
  final String message;
  RestaurantDetailError(this.message);
}
