import 'dart:convert';
import 'package:dicoding_restaurant_app/data/model/restaurant.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/data/model/seartch_result.dart';
import 'package:http/http.dart' as http;

Future<List<Restaurant>> fetchRestaurants() async {
  final response = await http.get(Uri.parse(
      'https://restaurant-api.dicoding.dev/list')); // Ganti dengan URL API yang sesuai

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> restaurantsJson = data['restaurants'];
    return restaurantsJson.map((json) => Restaurant.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load restaurants');
  }
}

Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
  final response = await http.get(
    Uri.parse('https://restaurant-api.dicoding.dev/detail/$id'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return RestaurantDetail.fromJson(data);
  } else {
    throw Exception('Failed to load restaurant detail');
  }
}

Future<SearchResult> searchRestaurants(String query) async {
  final response = await http.get(
    Uri.parse('https://restaurant-api.dicoding.dev/search?q=$query'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return SearchResult.fromJson(data);
  } else {
    throw Exception('Failed to load search results');
  }
}
