import 'package:dicoding_restaurant_app/provider/favorite_provider.dart';
import 'package:dicoding_restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:dicoding_restaurant_app/provider/restaurant_provider.dart';
import 'package:dicoding_restaurant_app/provider/review_provider.dart';
import 'package:dicoding_restaurant_app/provider/search_provider.dart';
import 'package:dicoding_restaurant_app/provider/main_page_provider.dart';
import 'package:dicoding_restaurant_app/provider/theme_provider.dart';
import 'package:dicoding_restaurant_app/screen/home/main_page.dart';
import 'package:dicoding_restaurant_app/service/notification_service.dart';
import 'package:dicoding_restaurant_app/style/theme/restaurant_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantDetailProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => MainPageProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Restoran',
      theme: RestaurantTheme.lightTheme,
      darkTheme: RestaurantTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: MainPage(),
    );
  }
}
