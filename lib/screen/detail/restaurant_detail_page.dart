import 'package:dicoding_restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:dicoding_restaurant_app/static/restaurant_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider =
        Provider.of<RestaurantDetailProvider>(context, listen: false);
    provider.fetchRestaurantDetail(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Restoran'),
      ),
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
          final state = provider.state;

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
                  // Gambar Restoran
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
                  // Nama Restoran
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
                  // Rating dan Kota
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
                  // Deskripsi Restoran
                  Text(
                    restaurant.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 16.0),
                  // Alamat Restoran
                  Text(
                    'Alamat: ${restaurant.address}',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 16.0),
                  // Menu Makanan
                  Text(
                    'Menu Makanan:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Grid untuk Menu Makanan
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
                  // Menu Minuman
                  Text(
                    'Menu Minuman:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Grid untuk Menu Minuman
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
