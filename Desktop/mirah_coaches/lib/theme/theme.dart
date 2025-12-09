import 'package:flutter/material.dart';


const Color brandBlue = Color(0xFF003366); // Deep Navy Blue
const Color brandRed = Color(0xFFCC0000); // Vibrant Bus Stripe Red
const Color brandWhite = Color(0xFFFFFFFF);

ThemeData appTheme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: brandBlue,
      onPrimary: brandWhite,
      secondary: brandRed,
      onSecondary: brandWhite,
      error: Colors.red,
      onError: brandWhite,
      surface: Colors.white,
      onSurface: brandWhite,
      tertiary: Colors.grey.shade500,
    ),
  );
}
