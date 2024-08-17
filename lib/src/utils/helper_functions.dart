import 'package:flutter/material.dart';

class HelperFunctions {
  static void showSnackBar(BuildContext context, int duration, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          duration: Duration(milliseconds: duration), content: Text(message)));
  }
}
