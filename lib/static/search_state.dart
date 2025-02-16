import 'package:dicoding_restaurant_app/data/model/restaurant.dart';

sealed class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Restaurant> restaurants;
  SearchSuccess(this.restaurants);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
