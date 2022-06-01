import 'package:flutter/material.dart';

class GlobalStyle {
  static BoxShadow normalShadow = const BoxShadow(
    color: Color(0x42999999),
    offset: Offset(0, 0.5),
    blurRadius: 5,
  );
  static BoxShadow bottomShadow = const BoxShadow(
    color: Color(0x42999999),
    offset: Offset(0, 0.5),
    blurRadius: 5,
  );
  static BoxShadow noShadow = const BoxShadow(
    color: Color(0x42999999),
    offset: Offset(0, 0.5),
    blurRadius: 5,
  );

  static const Color mainThemeColor = Color(0xFF3b3e43);

  static LinearGradient mainThemeGradient = const LinearGradient(colors: [
    Color(0xFF494947),
    Color(0xFFFFFFFF),
  ]);
}
