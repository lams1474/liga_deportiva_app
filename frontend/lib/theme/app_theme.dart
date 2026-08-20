import 'package:flutter/material.dart';

class AppTheme {
  // ============================
  // TOKENS PRIMITIVOS
  // ============================

  static const Color greenPrimary = Color(0xFF2E7D32);
  static const Color greenDark = Color(0xFF1B5E20);
  static const Color greenLight = Color(0xFFE8F5E9);

  static const Color redError = Color(0xFFC62828);
  static const Color blueAction = Color(0xFF1565C0);

  static const Color white = Colors.white;
  static const Color black = Color(0xFF212121);
  static const Color grey = Color(0xFF757575);

  // ============================
  // TOKENS DE ESPACIADO
  // ============================

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  // ============================
  // TOKENS DE RADIO
  // ============================

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;

  // ============================
  // TEMA PRINCIPAL
  // ============================

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: greenPrimary,
        primary: greenPrimary,
        error: redError,
      ),

      scaffoldBackgroundColor: Colors.grey[50],

      appBarTheme: const AppBarTheme(
        backgroundColor: greenPrimary,
        foregroundColor: white,
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radiusSm),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radiusSm),
          ),
          borderSide: BorderSide(
            color: greenPrimary,
            width: 2,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            50,
          ),
          backgroundColor: greenPrimary,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radiusSm),
            ),
          ),
        ),
      ),
    );
  }
}