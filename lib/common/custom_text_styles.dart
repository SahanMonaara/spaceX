import 'package:flutter/material.dart';

/// It's a class that contains static methods that return TextStyle objects
class CustomTextStyles {
  static TextStyle titleStyle() {
    return const TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20);
  }

  static TextStyle subTitleStyle() {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle regularStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );
  }
}
