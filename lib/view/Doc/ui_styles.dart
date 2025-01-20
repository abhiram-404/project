// ui_styles.dart
import 'package:flutter/material.dart';

const kGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Color(0xFF1976D2), // Blue shade700 equivalent
      Color(0xFF2196F3), // Blue shade500 equivalent
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);
