import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xffE01B1B);

  static MaterialColor primarySwatch = const MaterialColor(
    0xFFE01B1B,
    <int, Color>{
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE0B2),
      200: Color(0xFFFFCC80),
      300: Color(0xFFFFB74D),
      400: Color(0xFFFFA726),
      500: Color(0xFFE01B1B), // Replaced the primary color with 0xffE01B1B
      600: Color(0xFFFB8C00),
      700: Color(0xFFF57C00),
      800: Color(0xFFEF6C00),
      900: Color(0xFFE65100),
    },
  );
  static const Color backgroundSwatch = Color(0xFFFCE7E7);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
}
