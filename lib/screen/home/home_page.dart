import 'package:dicoding_restaurant_app/provider/restaurant_provider.dart';
import 'package:dicoding_restaurant_app/screen/home/restaurant_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    restaurantProvider.fetchRestaurants();

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Restoran'),
      ),
      body: RestaurantList(),
    );
  }
}
