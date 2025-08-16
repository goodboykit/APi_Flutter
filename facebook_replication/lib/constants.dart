import 'package:flutter/material.dart';

class AppConstants {
  static const String baseUrl = 'http://localhost:8080';
  static const Color primaryColor = Color(0xFF1877f2);
}

class FacebookColors {
  // Primary Facebook Colors
  static const Color primaryBlue = Color(0xFF1877f2);
  static const Color darkBlue = Color(0xFF166fe5);
  static const Color lightBlue = Color(0xFF42a5f5);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF0F2F5);
  static const Color backgroundDark = Color(0xFF18191A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF242526);
  
  // Card and Container Colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF242526);
  static const Color dividerLight = Color(0xFFE4E6EA);
  static const Color dividerDark = Color(0xFF3A3B3C);
  
  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1C1E21);
  static const Color textPrimaryDark = Color(0xFFE4E6EA);
  static const Color textSecondaryLight = Color(0xFF65676B);
  static const Color textSecondaryDark = Color(0xFFB0B3B8);
  static const Color textTertiaryLight = Color(0xFF8A8D91);
  static const Color textTertiaryDark = Color(0xFF9C9C9C);
  
  // Action Colors
  static const Color likeColor = Color(0xFF1877f2);
  static const Color loveColor = Color(0xFFED4956);
  static const Color shareColor = Color(0xFF42B883);
  static const Color commentColor = Color(0xFF8E8E93);
  
  // Status Colors
  static const Color successColor = Color(0xFF42B883);
  static const Color errorColor = Color(0xFFED4956);
  static const Color warningColor = Color(0xFFFFB020);
  static const Color infoColor = Color(0xFF1877f2);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, darkBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient storyGradient = LinearGradient(
    colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCB045)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}