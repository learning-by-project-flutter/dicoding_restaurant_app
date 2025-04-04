import 'package:dicoding_restaurant_app/data/model/restaurant.dart';
import 'package:dicoding_restaurant_app/provider/favorite_provider.dart';
import 'package:dicoding_restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:dicoding_restaurant_app/provider/review_provider.dart';
import 'package:dicoding_restaurant_app/static/restaurant_detail_state.dart';
import 'package:dicoding_restaurant_app/static/review_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    Future.microtask(() => reviewProvider.fetchReviews(widget.restaurantId));
  }

  void _submitReview() async {
    final name = _nameController.text;
    final review = _reviewController.text;

    if (name.isEmpty || review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama dan ulasan tidak boleh kosong')),
      );
      return;
    }

    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    await reviewProvider.postReview(widget.restaurantId, name, review);

    _nameController.clear();
    _reviewController.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final detailProvider = Provider.of<RestaurantDetailProvider>(
      context,
      listen: false,
    );
    Future.microtask(
      () => detailProvider.fetchRestaurantDetail(widget.restaurantId),
    );

    final favoriteProvider = Provider.of<FavoriteProvider>(
      context,
      listen: false,
    );
    Future.microtask(
      () => favoriteProvider.checkFavoriteStatus(widget.restaurantId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Restoran'),
        actions: [
          Consumer2<RestaurantDetailProvider, FavoriteProvider>(
            builder: (context, detailProvider, favoriteProvider, _) {
              final state = detailProvider.state;
              if (state is RestaurantDetailSuccess) {
                final isFavorite = favoriteProvider.isFavoriteById(
                  widget.restaurantId,
                );

                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () async {
                    final favoriteProvider = Provider.of<FavoriteProvider>(
                      context,
                      listen: false,
                    );
                    final restaurant = state.restaurant;

                    final restaurantData = Restaurant(
                      id: restaurant.id,
                      name: restaurant.name,
                      description: restaurant.description,
                      pictureId: restaurant.pictureId,
                      city: restaurant.city,
                      rating: restaurant.rating,
                    );

                    await favoriteProvider.toggleFavorite(restaurantData);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isFavorite
                              ? '${restaurant.name} ditambahkan ke favorit'
                              : '${restaurant.name} dihapus dari favorit',
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, detailProvider, child) {
          final state = detailProvider.state;

          if (state is RestaurantDetailLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is RestaurantDetailError) {
            return Center(child: Text(state.message));
          } else if (state is RestaurantDetailSuccess) {
            final restaurant = state.restaurant;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'restaurant-image-${restaurant.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Hero(
                    tag: 'restaurant-name-${restaurant.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        restaurant.name,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20.0),
                      SizedBox(width: 4.0),
                      Text(
                        restaurant.rating.toString(),
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(width: 16.0),
                      Icon(Icons.location_on, color: Colors.grey, size: 20.0),
                      SizedBox(width: 4.0),
                      Flexible(
                        child: Text(
                          restaurant.city,
                          style: TextStyle(fontSize: 16.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    restaurant.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Alamat: ${restaurant.address}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Menu Makanan:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: restaurant.foods.length,
                    itemBuilder: (context, index) {
                      final food = restaurant.foods[index];
                      return Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.fastfood, color: Colors.orange),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  food.name,
                                  style: TextStyle(fontSize: 16.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Menu Minuman:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: restaurant.drinks.length,
                    itemBuilder: (context, index) {
                      final drink = restaurant.drinks[index];
                      return Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.local_drink, color: Colors.blue),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  drink.name,
                                  style: TextStyle(fontSize: 16.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Text(
                    'Tambah Ulasan',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      labelText: 'Ulasan',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: Text('Kirim Ulasan'),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Ulasan Pelanggan',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Consumer<ReviewProvider>(
                    builder: (context, reviewProvider, child) {
                      final state = reviewProvider.state;

                      return switch (state) {
                        ReviewLoading() => Center(
                          child: CircularProgressIndicator(),
                        ),
                        ReviewError(message: final message) => Center(
                          child: Text(message),
                        ),
                        ReviewSuccess(reviews: final reviews) =>
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: reviews.length,
                            itemBuilder: (context, index) {
                              final review = reviews[index];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 4.0),
                                child: ListTile(
                                  title: Text(review.name),
                                  subtitle: Text(review.review),
                                  trailing: Text(
                                    review.date,
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ),
                              );
                            },
                          ),
                      };
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
