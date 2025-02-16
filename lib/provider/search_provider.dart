import 'package:dicoding_restaurant_app/data/model/restaurant.dart';
import 'package:dicoding_restaurant_app/static/search_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchProvider with ChangeNotifier {
  SearchState _state = SearchInitial();
  SearchState get state => _state;

  Future<void> searchRestaurants(String query) async {
    _state = SearchLoading();
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://restaurant-api.dicoding.dev/search?q=$query'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Restaurant> restaurants = (data['restaurants'] as List)
            .map((item) => Restaurant.fromJson(item))
            .toList();
        _state = SearchSuccess(restaurants);
      } else {
        _state = SearchError('Failed to load search results');
      }
    } catch (e) {
      _state = SearchError('Error: $e');
    }

    notifyListeners();
  }
}
