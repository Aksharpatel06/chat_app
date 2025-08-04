import 'package:flutter/material.dart';

class CustomColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFFF1F0E4);
  static const Color secondaryColor = Color(0xFFBCA88D);
  static const Color backgroundColor = Color(0xFF7D8D86);
  static const Color textColor = Color(0xFF3E3F29);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Status Colors
  static const Color onlineColor = Color(0xFF4CAF50);
  static const Color unreadColor = Color(0xFF2196F3);

  // Additional UI Colors
  static const Color errorColor = Color(0xFFE57373);
  static const Color warningColor = Color(0xFFFFB74D);
  static const Color successColor = Color(0xFF81C784);
  static const Color infoColor = Color(0xFF64B5F6);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    primaryColor,
    secondaryColor,
  ];

  static const List<Color> backgroundGradient = [
    backgroundColor,
    textColor,
  ];

  // Shadow Colors
  static Color primaryShadow = primaryColor.withOpacity(0.2);
  static Color secondaryShadow = secondaryColor.withOpacity(0.15);
  static Color cardShadow = Colors.black.withOpacity(0.08);

  // Text Colors
  static Color primaryText = primaryColor;
  static Color secondaryText = secondaryColor;
  static Color hintText = primaryColor.withOpacity(0.5);
  static Color disabledText = primaryColor.withOpacity(0.3);

  // Border Colors
  static Color primaryBorder = secondaryColor.withOpacity(0.3);
  static Color focusedBorder = secondaryColor;
  static Color disabledBorder = primaryColor.withOpacity(0.2);

  // Utility Methods
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static LinearGradient getPrimaryGradient({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: primaryGradient,
    );
  }

  static LinearGradient getBackgroundGradient({
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        backgroundColor.withOpacity(0.8),
        textColor.withOpacity(0.3),
      ],
    );
  }

  static BoxShadow getCardShadow({
    double blurRadius = 15,
    Offset offset = const Offset(0, 8),
    double opacity = 0.1,
  }) {
    return BoxShadow(
      color: primaryColor.withOpacity(opacity),
      blurRadius: blurRadius,
      offset: offset,
    );
  }

  static BoxShadow getButtonShadow({
    double blurRadius = 15,
    Offset offset = const Offset(0, 8),
    double opacity = 0.3,
  }) {
    return BoxShadow(
      color: primaryColor.withOpacity(opacity),
      blurRadius: blurRadius,
      offset: offset,
    );
  }
}
