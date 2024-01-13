import 'package:flutter/material.dart';

class DrawingPoint {
  int id;
  List<Offset> offsets;
  Color color;
  double width;

  DrawingPoint({
    this.id = 01,
    this.offsets = const [],
    this.color = Colors.black,
    this.width = 1,
  });
}
