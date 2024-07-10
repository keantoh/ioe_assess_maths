import 'package:flutter/material.dart';

enum ColorSeed {
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  red('Red', Colors.red),
  pink('Pink', Colors.pink),
  purple('Purple', Colors.deepPurple);

  final String label;
  final Color color;

  const ColorSeed(this.label, this.color);
}
