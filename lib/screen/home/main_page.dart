import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/screen/home/home_page.dart';
import 'package:dicoding_restaurant_app/screen/search/search_page.dart';
import 'package:dicoding_restaurant_app/provider/main_page_provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(),
      SearchPage(),
    ];

    return Scaffold(
      body: Consumer<MainPageProvider>(
        builder: (context, provider, child) {
          return _pages[provider.selectedIndex];
        },
      ),
      bottomNavigationBar: Consumer<MainPageProvider>(
        builder: (context, provider, child) {
          return BottomNavigationBar(
            currentIndex: provider.selectedIndex,
            onTap: (index) {
              provider.setSelectedIndex(index);
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
            ],
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
          );
        },
      ),
    );
  }
}
