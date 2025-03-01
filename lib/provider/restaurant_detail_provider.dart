import 'package:dicoding_restaurant_app/static/restaurant_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/api/api_services.dart';

class RestaurantDetailProvider with ChangeNotifier {
  RestaurantDetailState _state = RestaurantDetailInitial();
  RestaurantDetailState get state => _state;

  Future<void> fetchRestaurantDetail(String id) async {
    _state = RestaurantDetailLoading();
    notifyListeners();

    try {
      final restaurant = await ApiServices.fetchRestaurantDetail(id);
      _state = RestaurantDetailSuccess(restaurant);
    } catch (e) {
      _state = RestaurantDetailError('Gagal memuat detail restoran: $e');
    }

    notifyListeners();
  }
}
