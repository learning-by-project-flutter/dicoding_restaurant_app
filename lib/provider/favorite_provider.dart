import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/database/database_helper.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant.dart';

class FavoriteProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Restaurant> _favorites = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Map<String, bool> _favoriteStatus = {};

  List<Restaurant> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  bool isFavoriteById(String id) {
    return _favoriteStatus[id] ?? false;
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _databaseHelper.getFavorites();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Tidak ada koneksi internet. Silakan cek koneksi Anda.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkFavoriteStatus(String id) async {
    try {
      final restaurant = await _databaseHelper.getFavoriteById(id);
      _favoriteStatus[id] = restaurant != null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Tidak ada koneksi internet. Silakan cek koneksi Anda.';
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
      _favoriteStatus[restaurant.id] = true;
      await loadFavorites();
    } catch (e) {
      _errorMessage = 'Error adding to favorites: $e';
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await _databaseHelper.removeFavorite(id);
      _favoriteStatus[id] = false;
      await loadFavorites();
    } catch (e) {
      _errorMessage = 'Error removing from favorites: $e';
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Restaurant restaurant) async {
    if (_favoriteStatus[restaurant.id] ?? false) {
      await removeFavorite(restaurant.id);
    } else {
      await addFavorite(restaurant);
    }
  }
}
