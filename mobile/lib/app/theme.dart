import 'package:flutter/material.dart';

class AppTheme {
  // Brand
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color accent = secondary; // Alias for backward compatibility
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Light Theme Colors
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Dark Theme Colors (softer, easier on eyes)
  static const Color backgroundDark = Color(0xFF1A1F2E);
  static const Color surfaceDark = Color(0xFF242938);
  static const Color surface = surfaceDark; // Alias for backward compatibility
  static const Color textPrimaryDark = Color(0xFFE8EAF0);
  static const Color textSecondaryDark = Color(0xFFB0B8C8);
  static const Color borderDark = Color(0xFF3D4455);

  // ─── Gradient Presets ───
  static const List<Color> heroGradient = [
    Color(0xFF4F46E5),
    Color(0xFF7C3AED),
    Color(0xFFA855F7),
  ];
  static const List<Color> ctaGradient = [primary, secondary];
  static const List<Color> successGradient = [Color(0xFF059669), success];

  // ─── Spacing Rhythm ───
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacing2xl = 48;
  static const double sectionGap = 32;
  static const double cardGap = 12;

  // ─── Typography Helpers ───
  static const TextStyle displayStyle = TextStyle(
    fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5,
  );
  static const TextStyle headlineStyle = TextStyle(
    fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3,
  );
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w700,
  );
  static const TextStyle captionStyle = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500,
  );
  static const TextStyle overlineStyle = TextStyle(
    fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5,
  );

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surfaceLight,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryLight,
        onError: Colors.white,
        outline: borderLight,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimaryLight),
        bodyMedium: TextStyle(color: textPrimaryLight),
        bodySmall: TextStyle(color: textSecondaryLight),
        titleLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceLight,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.05),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderLight, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(color: borderLight, thickness: 1),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceLight,
        foregroundColor: textPrimaryLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surfaceDark,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryDark,
        onError: Colors.white,
        outline: borderDark,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimaryDark),
        bodyMedium: TextStyle(color: textPrimaryDark),
        bodySmall: TextStyle(color: textSecondaryDark),
        titleLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.4),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderDark, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(color: borderDark, thickness: 1),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: textPrimaryDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
