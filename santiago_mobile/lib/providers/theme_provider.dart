import 'package:flutter/material.dart';
import '../constants.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: const MaterialColor(0xFF1877f2, {
        50: Color(0xFFE3F2FD),
        100: Color(0xFFBBDEFB),
        200: Color(0xFF90CAF9),
        300: Color(0xFF64B5F6),
        400: Color(0xFF42A5F5),
        500: FacebookColors.primaryBlue,
        600: FacebookColors.darkBlue,
        700: Color(0xFF1565C0),
        800: Color(0xFF0D47A1),
        900: Color(0xFF01579B),
      }),
      primaryColor: FacebookColors.primaryBlue,
      scaffoldBackgroundColor: FacebookColors.backgroundLight,
      cardColor: FacebookColors.cardLight,
      dividerColor: FacebookColors.dividerLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: FacebookColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
      ),
      cardTheme: CardTheme(
        color: FacebookColors.cardLight,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FacebookColors.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: FacebookColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FacebookColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: FacebookColors.dividerLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: FacebookColors.dividerLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: FacebookColors.primaryBlue, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: FacebookColors.textPrimaryLight),
        bodyMedium: TextStyle(color: FacebookColors.textSecondaryLight),
        bodySmall: TextStyle(color: FacebookColors.textTertiaryLight),
        headlineLarge: TextStyle(color: FacebookColors.textPrimaryLight, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: FacebookColors.textPrimaryLight, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: FacebookColors.textPrimaryLight, fontWeight: FontWeight.w500),
      ),
      iconTheme: const IconThemeData(
        color: FacebookColors.textSecondaryLight,
      ),
    );
  }
  
  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: const MaterialColor(0xFF1877f2, {
        50:  Color(0xFFE3F2FD),
        100:  Color(0xFFBBDEFB),
        200:  Color(0xFF90CAF9),
        300:  Color(0xFF64B5F6),
        400:  Color(0xFF42A5F5),
        500: FacebookColors.primaryBlue,
        600: FacebookColors.darkBlue,
        700:  Color(0xFF1565C0),
        800:  Color(0xFF0D47A1),
        900:  Color(0xFF01579B),
      }),
      primaryColor: FacebookColors.primaryBlue,
      scaffoldBackgroundColor: FacebookColors.backgroundDark,
      cardColor: FacebookColors.cardDark,
      dividerColor: FacebookColors.dividerDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: FacebookColors.surfaceDark,
        foregroundColor: FacebookColors.textPrimaryDark,
        elevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: FacebookColors.textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
      ),
      cardTheme: CardTheme(
        color: FacebookColors.cardDark,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FacebookColors.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: FacebookColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FacebookColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: FacebookColors.dividerDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: FacebookColors.dividerDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: FacebookColors.primaryBlue, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: FacebookColors.textPrimaryDark),
        bodyMedium: TextStyle(color: FacebookColors.textSecondaryDark),
        bodySmall: TextStyle(color: FacebookColors.textTertiaryDark),
        headlineLarge: TextStyle(color: FacebookColors.textPrimaryDark, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: FacebookColors.textPrimaryDark, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: FacebookColors.textPrimaryDark, fontWeight: FontWeight.w500),
      ),
      iconTheme: const IconThemeData(
        color: FacebookColors.textSecondaryDark,
      ),
    );
  }
}