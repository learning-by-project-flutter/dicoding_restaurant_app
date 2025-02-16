import 'package:dicoding_restaurant_app/data/model/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/static/restaurant_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantDetailProvider with ChangeNotifier {
  RestaurantDetailState _state = RestaurantDetailInitial();
  RestaurantDetailState get state => _state;

  Future<void> fetchRestaurantDetail(String id) async {
    _state = RestaurantDetailLoading();
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://restaurant-api.dicoding.dev/detail/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final restaurant = RestaurantDetail.fromJson(data);
        _state = RestaurantDetailSuccess(restaurant);
      } else {
        _state = RestaurantDetailError('Failed to load restaurant detail');
      }
    } catch (e) {
      _state = RestaurantDetailError('Error: $e');
    }

    notifyListeners();
  }
}
