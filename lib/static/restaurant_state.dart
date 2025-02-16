import 'package:dicoding_restaurant_app/data/model/restaurant.dart';

sealed class RestaurantState {}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantSuccess extends RestaurantState {
  final List<Restaurant> restaurants;
  RestaurantSuccess(this.restaurants);
}

class RestaurantError extends RestaurantState {
  final String message;
  RestaurantError(this.message);
}
