import 'package:dicoding_restaurant_app/data/api/api_services.dart';
import 'package:dicoding_restaurant_app/data/model/seartch_result.dart';
import 'package:dicoding_restaurant_app/screen/detail/restaurant_detail_page.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late Future<SearchResult> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults =
        Future.value(SearchResult(error: false, founded: 0, restaurants: []));
  }

  void _performSearch(String query) {
    setState(() {
      _searchResults = searchRestaurants(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cari Restoran'),
      ),
      body: Column(
        children: [
          // TextField untuk Pencarian
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _performSearch(_searchController.text);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) {
                _performSearch(value);
              },
            ),
          ),
          // Hasil Pencarian
          Expanded(
            child: FutureBuilder<SearchResult>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data!.restaurants.isEmpty) {
                  return Center(child: Text('Tidak ada hasil ditemukan'));
                } else {
                  final restaurants = snapshot.data!.restaurants;
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
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
