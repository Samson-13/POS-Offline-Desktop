import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        secondary: Color(0xFFD32F2F),
        primary: Color.fromARGB(255, 129, 129, 224),
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        surfaceTint: Color(0xFF7D7D7D),
        surfaceDim: Color(0xFFF3F3F3),
      ),
      appBarTheme: getAppBarTheme(isDark: false),
      scaffoldBackgroundColor: Colors.white,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF00D7C6),
        unselectedItemColor: Colors.grey,
      ),
      elevatedButtonTheme: getElevatedButtonTheme(isDark: false),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        secondary: Color(0xFFD32F2F),
        primary: Color.fromARGB(255, 129, 129, 224),
        surface: Color(0xFF1E1E1E),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        surfaceTint: Color(0xFF7D7D7D),
        surfaceDim: Color(0xFF2D2D2D),
      ),
      appBarTheme: getAppBarTheme(isDark: true),
      scaffoldBackgroundColor: const Color(0xFF121212),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Color(0xFF00D7C6),
        unselectedItemColor: Colors.grey,
      ),
      elevatedButtonTheme: getElevatedButtonTheme(isDark: true),
    );
  }

  static ElevatedButtonThemeData getElevatedButtonTheme({
    required bool isDark,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
    );
  }

  static AppBarTheme getAppBarTheme({required bool isDark}) {
    return AppBarTheme(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      foregroundColor: isDark ? Colors.white : Colors.black,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }
}
