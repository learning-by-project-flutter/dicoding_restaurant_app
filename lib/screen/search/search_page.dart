import 'package:dicoding_restaurant_app/provider/search_provider.dart';
import 'package:dicoding_restaurant_app/screen/detail/restaurant_detail_page.dart';
import 'package:dicoding_restaurant_app/static/search_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_performSearch);
  }

  void _performSearch() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      final provider = Provider.of<SearchProvider>(context, listen: false);
      provider.searchRestaurants(query);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cari Restoran'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) {
                final state = provider.state;

                if (state is SearchLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SearchError) {
                  return Center(child: Text(state.message));
                } else if (state is SearchSuccess) {
                  final restaurants = state.restaurants;
                  return ListView.builder(
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = restaurants[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Image.network(
                            'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(restaurant.name),
                          subtitle: Text(
                              '${restaurant.city} - Rating: ${restaurant.rating}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestaurantDetailPage(
                                  restaurantId: restaurant.id,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                      child: Text('Masukkan kata kunci untuk mencari'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
