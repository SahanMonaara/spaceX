import 'package:flutter/material.dart';

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

  static TextStyle timerStyle({double size = 15}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w800,
      color: Colors.blue,
    );
  }
}
