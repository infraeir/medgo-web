import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    primaryColor: const Color(0xff1e5869),
    primaryColorDark: const Color(0xffC7DDEA),
    primaryColorLight: const Color(0XFFF0EEF6),
    hintColor: const Color(0xff1e5869),
    fontFamily: GoogleFonts.atkinsonHyperlegible().fontFamily,
  );

  static Color errorColor = const Color(0xffBA1A1A);
  static Color greyColor = const Color(0xffECEAF4);

  static TextStyle h1({
    required Color color,
    required FontWeight fontWeight,
    TextDecoration? decoration,
    double? opacity,
  }) {
    return TextStyle(
      fontSize: 28,
      fontWeight: fontWeight,
      decoration: decoration,
      color: opacity != null ? color.withOpacity(opacity) : color,
    );
  }

  static TextStyle h2({
    required Color color,
    required FontWeight fontWeight,
    TextDecoration? decoration,
    double? opacity,
  }) {
    return TextStyle(
      fontSize: 24,
      fontWeight: fontWeight,
      decoration: decoration,
      color: opacity != null ? color.withOpacity(opacity) : color,
    );
  }

  static TextStyle h3({
    required Color color,
    required FontWeight fontWeight,
    TextDecoration? decoration,
    double? opacity,
  }) {
    return TextStyle(
      fontSize: 20,
      fontWeight: fontWeight,
      decoration: decoration,
      color: opacity != null ? color.withOpacity(opacity) : color,
    );
  }

  static TextStyle h4({
    required Color color,
    required FontWeight fontWeight,
    TextDecoration? decoration,
    double? opacity,
  }) {
    return TextStyle(
      fontSize: 18,
      fontWeight: fontWeight,
      decoration: decoration,
      color: opacity != null ? color.withOpacity(opacity) : color,
    );
  }

  static TextStyle h5({
    required Color color,
    required FontWeight fontWeight,
    TextDecoration? decoration,
    double? opacity,
  }) {
    return TextStyle(
      fontSize: 14,
      fontWeight: fontWeight,
      decoration: decoration,
      color: opacity != null ? color.withOpacity(opacity) : color,
    );
  }

  static TextStyle h6({
    required Color color,
    required FontWeight fontWeight,
    TextDecoration? decoration,
    double? opacity,
  }) {
    return TextStyle(
      fontSize: 12,
      fontWeight: fontWeight,
      decoration: decoration,
      color: opacity != null ? color.withOpacity(opacity) : color,
    );
  }
}

