import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(255, 243, 73, 60),
    secondary: Color.fromARGB(255, 208, 65, 113),
    tertiary: Color.fromARGB(255, 32, 225, 148),
    surface: Color.fromARGB(255, 131, 10, 108),
    inversePrimary: Colors.white,
    inverseSurface: Color.fromARGB(255, 13, 107, 99),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 243, 73, 60),
);

ThemeData darkMode = ThemeData(
    colorScheme: const ColorScheme.dark(
        primary: Color.fromARGB(255, 50, 2, 89),
        secondary: Color.fromARGB(255, 148, 42, 194),
        tertiary: Colors.white,
        surface: Color.fromARGB(255, 75, 3, 56),
        inversePrimary: Colors.amber,
        inverseSurface: Color.fromARGB(255, 99, 193, 148)),
    scaffoldBackgroundColor: const Color.fromARGB(255, 50, 2, 89));
