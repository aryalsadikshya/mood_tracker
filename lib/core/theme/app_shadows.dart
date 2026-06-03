import 'package:flutter/material.dart';

class AppShadows {
  static List<BoxShadow> softShadow(Color color) {
    return [
      BoxShadow(
        color: color.withOpacity(0.15),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ];
  }
}