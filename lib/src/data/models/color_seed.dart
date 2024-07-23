import 'package:flutter/material.dart';

enum ColorSeed {
  blue(1, 'Blue', Colors.blue),
  teal(2, 'Teal', Colors.teal),
  green(3, 'Green', Colors.green),
  red(4, 'Red', Colors.red),
  pink(5, 'Pink', Colors.pink),
  purple(6, 'Purple', Colors.deepPurple);

  final int id;
  final String label;
  final Color color;

  const ColorSeed(this.id, this.label, this.color);
}
