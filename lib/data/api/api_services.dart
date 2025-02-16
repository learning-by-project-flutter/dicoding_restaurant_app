import 'dart:convert';
import 'package:dicoding_restaurant_app/data/model/restaurant.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/data/model/review.dart';
import 'package:dicoding_restaurant_app/data/model/seartch_result.dart';
import 'package:http/http.dart' as http;

Future<List<Restaurant>> fetchRestaurants() async {
  final response =
      await http.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));

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

Future<List<Review>> fetchReviews(String restaurantId) async {
  final response = await http.get(
    Uri.parse('https://restaurant-api.dicoding.dev/detail/$restaurantId'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> reviewsJson = data['restaurant']['customerReviews'];
    return reviewsJson.map((json) => Review.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load reviews');
  }
}

Future<void> postReview(String restaurantId, String name, String review) async {
  final response = await http.post(
    Uri.parse('https://restaurant-api.dicoding.dev/review'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'id': restaurantId,
      'name': name,
      'review': review,
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final Map<String, dynamic> responseBody = json.decode(response.body);
    if (responseBody['error'] == false) {
      return;
    }
  }

  throw Exception('Failed to post review');
}
