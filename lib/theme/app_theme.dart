import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // App Colors
  static const Color primaryColor = Color(0xFFFC8884); // coral pink
  static const Color primaryDarkColor = Color(0xFF374A5A); // dark blue-gray
  static const Color secondaryColor = Color(0xFFA0F1EA); // light teal
  static const Color accentColor = Color(0xFFEAD6EE); // light lavender
  static const Color greenColor = Color(0xFF10B981); // green-500 (keeping for status indicators)
  static const Color redColor = Color(0xFFEF4444); // red-500 (keeping for status indicators)
  static const Color yellowColor = Color(0xFFF59E0B); // amber-500 (keeping for status indicators)
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFF0F9FF); // light blue background
  static const Color cardColor = Colors.white;
  static const Color surfaceColor = Color(0xFFEAD6EE); // light lavender surface
  
  // Text Colors
  static const Color textPrimaryColor = Color(0xFF374A5A); // dark blue-gray for primary text
  static const Color textSecondaryColor = Color(0xFF5A6B7B); // lighter blue-gray for secondary text
  static const Color textTertiaryColor = Color(0xFF8A97A3); // lightest blue-gray for tertiary text

  // Status Colors
  static const Color confirmedColor = Color(0xFFA0F1EA); // light teal for confirmed
  static const Color confirmedTextColor = Color(0xFF374A5A); // dark blue-gray text
  static const Color pendingColor = Color(0xFFEAD6EE); // light lavender for pending
  static const Color pendingTextColor = Color(0xFF374A5A); // dark blue-gray text
  static const Color completedColor = Color(0xFFF0F9FF); // light blue for completed
  static const Color completedTextColor = Color(0xFF374A5A); // dark blue-gray text

  // Get ThemeData
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        background: backgroundColor,
        surface: surfaceColor,
        error: redColor,
        onPrimary: Colors.white,
        onSecondary: textPrimaryColor,
        onBackground: textPrimaryColor,
        onSurface: textPrimaryColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: const CardTheme(
        color: cardColor,
        elevation: 2,
        surfaceTintColor: Color(0xFFEAD6EE), // light lavender tint
        margin: EdgeInsets.zero,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.inter(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.inter(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: GoogleFonts.inter(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.inter(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: GoogleFonts.inter(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.inter(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.inter(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.inter(
          color: textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.inter(
          color: textSecondaryColor,
        ),
        bodyMedium: GoogleFonts.inter(
          color: textSecondaryColor,
        ),
        bodySmall: GoogleFonts.inter(
          color: textTertiaryColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: accentColor.withOpacity(0.8), // Light lavender with opacity
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(
          color: primaryDarkColor, // Dark blue-gray for icons
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, // Soft pink background
          foregroundColor: primaryDarkColor, // Dark blue-gray text
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // More rounded corners
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor, // Soft pink text
          side: const BorderSide(color: primaryColor), // Soft pink border
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // More rounded corners
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor, // Soft pink text
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // More rounded corners
          borderSide: const BorderSide(color: Color(0xFFEAD6EE)), // Light lavender border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEAD6EE)), // Light lavender border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor), // Soft pink when focused
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: redColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE5E7EB), // gray-200
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primaryColor.withOpacity(0.1),
        labelTextStyle: MaterialStateProperty.all(
          GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
