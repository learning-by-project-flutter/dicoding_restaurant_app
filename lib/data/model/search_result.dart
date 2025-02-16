import 'package:dicoding_restaurant_app/data/model/restaurant.dart';

class SearchResult {
  final bool error;
  final int founded;
  final List<Restaurant> restaurants;

  SearchResult({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      error: json['error'],
      founded: json['founded'],
      restaurants: (json['restaurants'] as List)
          .map((item) => Restaurant.fromJson(item))
          .toList(),
    );
  }
}
