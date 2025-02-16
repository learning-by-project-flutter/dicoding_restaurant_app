class Review {
  final String name;
  final String review;
  final String date;

  Review({
    required this.name,
    required this.review,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }
}
