import 'dart:math';
import 'package:flutter/material.dart';

class RandomUI {
  static final _random = Random();

  /// Random Icon
  static IconData randomIcon() {
    const icons = [
      Icons.category,
      Icons.home,
      Icons.shopping_bag,
      Icons.shopping_cart,
      Icons.car_rental,
      Icons.pets,
      Icons.computer,
      Icons.phone_android,
      Icons.house,
      Icons.local_offer,
      Icons.store,
      Icons.local_mall,
      Icons.explore,
      Icons.chair,
      Icons.brush,
      Icons.sports_soccer,
      Icons.fastfood,
      Icons.directions_car,
      Icons.apartment,
    ];
    return icons[_random.nextInt(icons.length)];
  }

  /// Random bright color
  static Color randomColor() {
    const colors = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.cyanAccent,
      Colors.tealAccent,
      Colors.yellowAccent,
      Colors.pinkAccent,
      Colors.deepPurpleAccent,
      Colors.indigoAccent,
      Colors.lightBlueAccent,
      Colors.amberAccent,
    ];
    return colors[_random.nextInt(colors.length)];
  }
}
