import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/database/database_helper.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant.dart';

class FavoriteProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Restaurant> _favorites = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Restaurant> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _databaseHelper.getFavorites();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error loading favorites: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final restaurant = await _databaseHelper.getFavoriteById(id);
    return restaurant != null;
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    try {
      await _databaseHelper.insertFavorite(restaurant);
      await loadFavorites();
    } catch (e) {
      _errorMessage = 'Error adding to favorites: $e';
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await _databaseHelper.removeFavorite(id);
      await loadFavorites();
    } catch (e) {
      _errorMessage = 'Error removing from favorites: $e';
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Restaurant restaurant) async {
    final isFav = await isFavorite(restaurant.id);
    if (isFav) {
      await removeFavorite(restaurant.id);
    } else {
      await addFavorite(restaurant);
    }
  }
}
