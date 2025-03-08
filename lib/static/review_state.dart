import 'package:dicoding_restaurant_app/data/model/review.dart';

sealed class ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final List<Review> reviews;

  ReviewSuccess(this.reviews);
}

class ReviewError extends ReviewState {
  final String message;

  ReviewError(this.message);
}
