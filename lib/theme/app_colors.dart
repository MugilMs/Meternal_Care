import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFC8884); // Coral Pink
  static const Color primaryDark = Color(0xFF374A5A); // Dark Blue-Gray
  static const Color secondary = Color(0xFFA0F1EA); // Light Teal
  static const Color accent = Color(0xFFEAD6EE); // Light Lavender
  
  // Status Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color error = Color(0xFFEF4444); // Red
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color info = Color(0xFF3B82F6); // Blue
  
  // Background Colors
  static const Color background = Color(0xFFF8FAFC); // Lightest Blue
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color card = Color(0xFFFFFFFF); // White
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B); // Dark Blue-Gray
  static const Color textSecondary = Color(0xFF64748B); // Gray
  static const Color textTertiary = Color(0xFF94A3B8); // Light Gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White
  
  // Border Colors
  static const Color border = Color(0xFFE2E8F0); // Light Gray
  static const Color divider = Color(0xFFF1F5F9); // Lighter Gray
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFFF9E9E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Social Colors
  static const Color google = Color(0xFFDB4437);
  static const Color facebook = Color(0xFF4267B2);
  static const Color apple = Color(0xFF000000);
  
  // Transparent
  static const Color transparent = Color(0x00000000);
  
  // Shimmer Colors
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF1F5F9);
  
  // Shadow Colors
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];
  
  // Overlay Colors
  static const Color overlayDark = Color(0x80000000);
  static const Color overlayLight = Color(0x33FFFFFF);
  
  // Custom Colors
  static const Color lightPink = Color(0xFFFFF0F0);
  static const Color lightBlue = Color(0xFFF0F9FF);
  static const Color lightPurple = Color(0xFFF8F0FF);
  static const Color lightGreen = Color(0xFFF0FFF4);
  static const Color lightYellow = Color(0xFFFFF7E6);
}
