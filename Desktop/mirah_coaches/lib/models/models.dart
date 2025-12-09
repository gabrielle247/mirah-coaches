// lib/models/models.dart

// This file exports all models so you only need to import this one file.
import 'package:flutter/material.dart';

export 'ticket.dart';
export 'expense.dart';
export 'trips.dart';

BoxDecoration allGradientBoxes({
  required List<Color> color,
  required double radius,
}) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: color,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.circular(radius),
  );
}