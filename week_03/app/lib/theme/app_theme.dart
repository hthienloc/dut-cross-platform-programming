import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// App UI style selection: Material Design 3 or Apple Cupertino
enum AppDesignStyle {
  material,
  cupertino,
}

/// Global application state notifier for Theme and Design Style
class AppStateNotifier extends ChangeNotifier {
  AppDesignStyle _style = AppDesignStyle.material;
  ThemeMode _themeMode = ThemeMode.light;

  AppDesignStyle get style => _style;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleStyle() {
    _style = _style == AppDesignStyle.material
        ? AppDesignStyle.cupertino
        : AppDesignStyle.material;
    notifyListeners();
  }

  void setStyle(AppDesignStyle newStyle) {
    if (_style != newStyle) {
      _style = newStyle;
      notifyListeners();
    }
  }

  void toggleThemeMode() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

/// Centralized Design Tokens: Spacings, Colors, and Accessibility constraints
class AppTokens {
  // Standard 8dp Grid Spacing
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  // Touch Target Accessibility Standards
  static const double minTouchTargetMaterial = 48.0;
  static const double minTouchTargetCupertino = 44.0;

  // Material 3 Seed Colors
  static const Color primarySeed = Color(0xFF0D6EFD); // Blue 600

  // Cupertino Colors
  static const Color cupertinoPrimary = CupertinoColors.activeBlue;
}

/// Material Design 3 Theme configuration
class MaterialThemeConfig {
  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppTokens.primarySeed,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(88, AppTokens.minTouchTargetMaterial),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppTokens.primarySeed,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(88, AppTokens.minTouchTargetMaterial),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

/// Cupertino (Apple HIG) Theme configuration
class CupertinoThemeConfig {
  static CupertinoThemeData themeData(Brightness brightness) {
    return CupertinoThemeData(
      brightness: brightness,
      primaryColor: AppTokens.cupertinoPrimary,
      barBackgroundColor: brightness == Brightness.dark
          ? const Color(0xCC1E1E1E)
          : const Color(0xCCF8F8F8),
      scaffoldBackgroundColor: brightness == Brightness.dark
          ? CupertinoColors.black
          : CupertinoColors.systemGroupedBackground,
      textTheme: const CupertinoTextThemeData(
        primaryColor: AppTokens.cupertinoPrimary,
      ),
    );
  }
}
