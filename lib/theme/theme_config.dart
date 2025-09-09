import 'package:flutter/material.dart';

class ThemeConfig {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'roboto',
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'roboto',
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red, brightness: Brightness.dark),
  );
}
