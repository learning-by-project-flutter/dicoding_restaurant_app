import 'package:dicoding_restaurant_app/screen/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/screen/home/home_page.dart';
import 'package:dicoding_restaurant_app/screen/search/search_page.dart';
import 'package:dicoding_restaurant_app/screen/favorite/favorite_page.dart';
import 'package:dicoding_restaurant_app/provider/main_page_provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(),
      SearchPage(),
      FavoritePage(),
      SettingsPage(),
    ];

    return Scaffold(
      body: Consumer<MainPageProvider>(
        builder: (context, provider, child) {
          return pages[provider.selectedIndex];
        },
      ),
      bottomNavigationBar: Consumer<MainPageProvider>(
        builder: (context, provider, child) {
          return BottomNavigationBar(
            currentIndex: provider.selectedIndex,
            onTap: (index) {
              Future.microtask(() => provider.setSelectedIndex(index));
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Pencarian',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorit',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
          );
        },
      ),
    );
  }
}
