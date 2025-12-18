import 'package:flutter/material.dart';

class AppColors {
  // Primary Gradient Colors
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color primaryTeal = Color(0xFF50C878);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background Colors - Light Mode
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Background Colors - Dark Mode
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFFFFFFFF);

  // Semantic Colors
  static const Color success = Color(0xFF06D6A0);
  static const Color warning = Color(0xFFFFBE0B);
  static const Color error = Color(0xFFEF476F);
  static const Color info = Color(0xFF118AB2);

  // Income & Expense
  static const Color income = Color(0xFF06D6A0);
  static const Color expense = Color(0xFFEF476F);

  // Category Colors (vibrant palette)
  static const List<Color> categoryColors = [
    Color(0xFFFF6B6B), // Red
    Color(0xFF4ECDC4), // Teal
    Color(0xFFFFBE0B), // Yellow
    Color(0xFFFF006E), // Pink
    Color(0xFF06FFA5), // Green
    Color(0xFF8338EC), // Purple
    Color(0xFFFF9F1C), // Orange
    Color(0xFF3A86FF), // Blue
  ];

  // Glassmorphism overlay
  static Color glassOverlay(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.1)
        : Colors.white.withOpacity(0.7);
  }
}
