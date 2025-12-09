// lib/utils/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color brandBlue = Color(0xFF003366); // Deep Navy
  static const Color brandRed = Color(0xFFCC0000);  // Bus Stripe Red
  static const Color brandWhite = Color(0xFFFFFFFF);
  static const Color brandGrey = Color(0xFF9E9E9E);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: brandBlue,
      onPrimary: brandWhite,
      secondary: brandRed,
      onSecondary: brandWhite,
      surface: brandWhite,
      onSurface: brandBlue, // Text on white background is blue
      tertiary: brandGrey,
    ),
    
    // Standard Card Style
      // cardTheme: CardTheme(
      //   color: brandWhite,
      //   elevation: 4,
      //   shadowColor: Colors.black26,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // ),

    // Standard AppBar Style
    appBarTheme: const AppBarTheme(
      backgroundColor: brandBlue,
      foregroundColor: brandWhite,
      centerTitle: true,
      elevation: 0,
    ),
  );
}