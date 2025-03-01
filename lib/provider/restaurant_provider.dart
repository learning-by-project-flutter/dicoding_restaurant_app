import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/api/api_services.dart';
import 'package:dicoding_restaurant_app/static/restaurant_state.dart';

class RestaurantProvider with ChangeNotifier {
  RestaurantState _state = RestaurantInitial();
  RestaurantState get state => _state;

  Future<void> fetchRestaurants() async {
    _state = RestaurantLoading();
    notifyListeners();

    try {
      final restaurants = await ApiServices.fetchRestaurants();
      _state = RestaurantSuccess(restaurants);
    } catch (e) {
      _state = RestaurantError('Gagal memuat restoran: $e');
    }

    notifyListeners();
  }
}
