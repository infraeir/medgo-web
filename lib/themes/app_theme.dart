import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF004155);
  static const Color secondary = Color(0xFF39D2C0);
  static const Color tertiary = Color(0xFFEE8B60);
  static const Color alternate = Color(0xFFE0E3E7);
  static const Color lightTheme = Color(0xFFDAEAEF);

  static const Color themeAccent = Color.fromRGBO(
    0,
    65,
    85,
    0.30,
  );

  // Utility Colors
  static const Color primaryText = Color(0xFF001F2A);
  static const Color secondaryText = Color(0xFF57636C);
  static const Color primaryBackground = Color(0xFFF1F4F8);
  static const Color secondaryBackground = Color(0xFFFCFDFF);
  static const Color lightprimaryBackground = Color(0xFF006684);
  static const Color lightSurfaceBright = Color(0xFFF8F9FB);
  static const Color lightOutline = Color(0xFF70787D);
  static const Color lightBackground = Color(0xffDFEEFF);
  static const Color lightSemiTransparent = Color(0xffd9e9f3);
  static const Color textPrimary = Color(0xFF004D64);

  // Accent Colors
  static const Color primaryAccent = Color(0xFF326789);
  static const Color semitrans = Color(0xFFDFEEFF);
  static const Color accent1 = Color(0xFF4C004155);
  static const Color accent2 = Color(0xFF4D39D2C0);
  static const Color accent3 = Color(0xFF4DEE8B60);
  static const Color accent4 = Color(0xFFCCFFFFFF);

  // Semantic Colors
  static const Color success = Color(0xFF249689);
  static const Color error = Color(0xFFFF5963);
  static const Color warning = Color(0xFFF9CF58);
  static const Color info = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // Custom Colors
  static const Color light = Color(0xFFD5F5FF);
  static const Color blueLight = Color(0xFF77A5C7);
  static const Color blueDark = Color(0xFF316789);
  static const Color softBlue = Color(0xFFDFEEFF);
  static const Color salmon = Color(0xFFE67F75);

  // ThemeData
  static ThemeData theme = ThemeData(
    primaryColor: primary,
    primaryColorDark: primary,
    primaryColorLight: secondary,
    scaffoldBackgroundColor: primaryBackground,
    fontFamily: 'AtkinsonHyperlegible',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      displayMedium: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      displaySmall: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      headlineLarge: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      headlineMedium: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      headlineSmall: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      titleLarge: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      titleMedium: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      titleSmall: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      bodyLarge: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      bodyMedium: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      bodySmall: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      labelLarge: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      labelMedium: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
      labelSmall: TextStyle(fontFamily: 'AtkinsonHyperlegible'),
    ),
  );

  static List<BoxShadow> iconShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  // Typography
  static TextStyle h1(
          {required Color color,
          required FontWeight fontWeight,
          TextDecoration? decoration,
          double? opacity}) =>
      _textStyle(28, color, fontWeight, decoration, opacity);

  static TextStyle h2(
          {required Color color,
          required FontWeight fontWeight,
          TextDecoration? decoration,
          double? opacity}) =>
      _textStyle(24, color, fontWeight, decoration, opacity);

  static TextStyle h3(
          {required Color color,
          required FontWeight fontWeight,
          TextDecoration? decoration,
          double? opacity}) =>
      _textStyle(20, color, fontWeight, decoration, opacity);

  static TextStyle h4(
          {required Color color,
          required FontWeight fontWeight,
          TextDecoration? decoration,
          double? opacity}) =>
      _textStyle(18, color, fontWeight, decoration, opacity);

  static TextStyle h5(
          {required Color color,
          required FontWeight fontWeight,
          TextDecoration? decoration,
          double? opacity}) =>
      _textStyle(14, color, fontWeight, decoration, opacity);

  static TextStyle h6(
          {required Color color,
          required FontWeight fontWeight,
          TextDecoration? decoration,
          double? opacity}) =>
      _textStyle(12, color, fontWeight, decoration, opacity);

  static TextStyle p(
          {required Color color,
          required FontWeight fontWeight,
          TextDecoration? decoration,
          double? opacity}) =>
      _textStyle(16, color, fontWeight, decoration, opacity);

  static TextStyle _textStyle(double size, Color color, FontWeight fontWeight,
      TextDecoration? decoration, double? opacity) {
    return TextStyle(
      fontFamily: 'AtkinsonHyperlegible',
      fontSize: size,
      fontWeight: fontWeight,
      decoration: decoration,
      color: opacity != null ? color.withOpacity(opacity) : color,
    );
  }
}
