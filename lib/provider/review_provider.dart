import 'package:dicoding_restaurant_app/static/review_state.dart';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/api/api_services.dart';

class ReviewProvider with ChangeNotifier {
  ReviewState _state = ReviewLoading();

  ReviewState get state => _state;

  Future<void> fetchReviews(String restaurantId) async {
    _state = ReviewLoading();
    notifyListeners();

    try {
      final reviews = await ApiServices.fetchReviews(restaurantId);
      _state = ReviewSuccess(reviews);
    } catch (e) {
      _state = ReviewError('Gagal memuat ulasan: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> postReview(
    String restaurantId,
    String name,
    String review,
  ) async {
    try {
      await ApiServices.postReview(restaurantId, name, review);
      await fetchReviews(restaurantId);
    } catch (e) {
      _state = ReviewError('Gagal mengirim ulasan: $e');
      notifyListeners();
    }
  }
}
