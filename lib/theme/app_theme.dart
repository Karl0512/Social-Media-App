import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const background = Color(0xFFF5F7FF);
  static const primary = Color(0xFF4F46E5);
  static const secondary = Color(0xFF9333EA);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorSchemeSeed: primary,
      textTheme: GoogleFonts.poppinsTextTheme(),
    );
  }
}