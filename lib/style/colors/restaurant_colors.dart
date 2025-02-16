// todo-03: create and add colors for this app
import 'package:flutter/material.dart';

enum RestaurantColors {
  blue("Blue", Colors.blue);

  const RestaurantColors(this.name, this.color);

  final String name;
  final Color color;
}
