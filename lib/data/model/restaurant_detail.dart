class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.foods,
    required this.drinks,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    final restaurant = json['restaurant'];
    final menus = restaurant['menus'];

    return RestaurantDetail(
      id: restaurant['id'],
      name: restaurant['name'],
      description: restaurant['description'],
      city: restaurant['city'],
      address: restaurant['address'],
      pictureId: restaurant['pictureId'],
      rating: restaurant['rating'].toDouble(),
      foods: (menus['foods'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
      drinks: (menus['drinks'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
    );
  }
}

class MenuItem {
  final String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(name: json['name']);
  }
}
