import 'package:flutter/material.dart';

/// ============================================================
/// TOKENS PRIMITIVOS
/// ============================================================

class AppColors {
  // Verde
  static const Color green500 = Color(0xFF2E7D32);
  static const Color green700 = Color(0xFF1B5E20);

  // Neutros
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey900 = Color(0xFF212121);

  // Estados
  static const Color red600 = Color(0xFFD32F2F);
  static const Color blue600 = Color(0xFF1976D2);
}

/// ============================================================
/// TOKENS SEMÁNTICOS
/// ============================================================

class AppSemanticColors {
  static const Color primary = AppColors.green500;
  static const Color primaryDark = AppColors.green700;

  static const Color background = AppColors.grey100;
  static const Color surface = AppColors.white;

  static const Color textPrimary = AppColors.grey900;
  static const Color textSecondary = AppColors.grey700;

  static const Color border = AppColors.grey300;

  static const Color success = AppColors.green500;
  static const Color error = AppColors.red600;
  static const Color information = AppColors.blue600;
}

/// ============================================================
/// TOKENS DE ESPACIADO
/// ============================================================

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// ============================================================
/// TOKENS DE RADIO
/// ============================================================

class AppRadius {
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 16;
}

/// ============================================================
/// TOKENS DE TAMAÑO
/// ============================================================

class AppSizes {
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double touchTarget = 48;
  static const double buttonHeight = 48;
  static const double cardElevation = 2;
}

/// ============================================================
/// TOKENS DE TIPOGRAFÍA
/// ============================================================

class AppTypography {
  static const String fontFamily = 'Roboto';

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppSemanticColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppSemanticColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppSemanticColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppSemanticColors.textSecondary,
  );
}

/// ============================================================
/// TEMA PRINCIPAL
/// ============================================================

class AppTheme {
  static ThemeData get theme => light();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.green500,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,

      colorScheme: colorScheme,

      scaffoldBackgroundColor:
          AppSemanticColors.background,

      fontFamily: AppTypography.fontFamily,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppSemanticColors.primary,
        foregroundColor: AppColors.white,
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.md,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.md,
          ),
          borderSide: const BorderSide(
            color: AppSemanticColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.md,
          ),
          borderSide: const BorderSide(
            color: AppSemanticColors.primary,
            width: 2,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(
            AppSizes.buttonHeight,
          ),
          backgroundColor: AppSemanticColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.md,
            ),
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppSemanticColors.surface,
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.md,
          ),
        ),
      ),
    );
  }
}