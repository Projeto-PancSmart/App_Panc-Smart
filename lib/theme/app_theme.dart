import 'package:flutter/material.dart';
class AppColors {
  static const primary = Color(0xFF2E7D32);
  static const primaryLight = Color(0xFF60A05A);
  static const primaryDark = Color(0xFF205C2E);

  static const accent = Color(0xFF8BC34A);
  static const surface = Color(0xFFF6F8F4);
  static const background = Color(0xFFF1F6F3);
  static const mutedText = Color(0xFF6B6B6B);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFB74D);
}

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData.light();

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
    );

    TextStyle safeInter(
        {double? fontSize, FontWeight? fontWeight, Color? color}) {
      return TextStyle(
          fontSize: fontSize, fontWeight: fontWeight, color: color);
    }

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: safeInter(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: base.textTheme.copyWith(
        bodyLarge: safeInter(fontSize: 16, color: Colors.black87),
        bodyMedium: safeInter(fontSize: 14, color: AppColors.mutedText),
        headlineSmall: safeInter(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        )),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
    );
  }
}

class AppSpacing {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}
