import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/api/api_services.dart';
import 'package:dicoding_restaurant_app/data/model/review.dart';

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchReviews(String restaurantId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final reviews = await ApiServices.fetchReviews(restaurantId);
      _reviews = reviews;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Gagal memuat ulasan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> postReview(
      String restaurantId, String name, String review) async {
    try {
      await ApiServices.postReview(restaurantId, name, review);
      await fetchReviews(
          restaurantId); // Refresh ulasan setelah berhasil mengirim
    } catch (e) {
      _errorMessage = 'Gagal mengirim ulasan: $e';
      notifyListeners();
    }
  }
}
