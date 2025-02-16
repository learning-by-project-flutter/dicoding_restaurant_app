import 'package:dicoding_restaurant_app/data/model/restaurant.dart';
import 'package:dicoding_restaurant_app/static/restaurant_state.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RestaurantProvider with ChangeNotifier {
  RestaurantState _state = RestaurantInitial();
  RestaurantState get state => _state;

  Future<void> fetchRestaurants() async {
    _state = RestaurantLoading();
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> restaurantsJson = data['restaurants'];
        final restaurants =
            restaurantsJson.map((json) => Restaurant.fromJson(json)).toList();
        _state = RestaurantSuccess(restaurants);
      } else {
        _state = RestaurantError('Failed to load restaurants');
      }
    } catch (e) {
      _state = RestaurantError('Error: $e');
    }

    notifyListeners();
  }
}
