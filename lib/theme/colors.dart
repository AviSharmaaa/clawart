import 'package:flutter/material.dart';

class AppColor {
  static List<Color> availableColors = const [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  static Color white = const Color(0xFFFAF9F6);
  static Color neutral = const Color(0xffBCBEC3);
  static Color background = const Color(0xFF0D1518);
  static Color transparent = Colors.transparent;
  static MaterialColor primary = const MaterialColor(
    0xFF00a884,
    {
      50: Color(0xFFe0f2f1),
      100: Color(0xFFb2dfdb),
      200: Color(0xFF80cbc4),
      300: Color(0xFF4db6ac),
      400: Color(0xFF26a69a),
      500: Color(0xFF00a884),
      600: Color(0xFF00897b),
      700: Color(0xFF00796b),
      800: Color(0xFF00695c),
      900: Color(0xFF004d40),
    },
  );
}
