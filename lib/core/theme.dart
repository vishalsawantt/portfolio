import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // background colors
  static const Color bgDark = Color(0xFF0A0A0A);       // main background
  static const Color bgCard = Color(0xFF111111);        // card background
  static const Color bgSection = Color(0xFF0D0D0D);     // alternate section bg

  // accent colors
  static const Color primary = Color(0xFF00D4FF);       // cyan blue accent
  static const Color primaryDark = Color(0xFF0099BB);   // darker accent

  // text colors
  static const Color textPrimary = Color(0xFFFFFFFF);   // white
  static const Color textSecondary = Color(0xFFAAAAAA); // grey
  static const Color textMuted = Color(0xFF666666);     // muted grey

  // border
  static const Color border = Color(0xFF222222);
}

// ----------------------------------------------------------
// AppTheme — MaterialApp theme setup
// ----------------------------------------------------------
class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,

      // using google fonts — Syne for display, Inter for body
      textTheme: GoogleFonts.syneTextTheme().copyWith(
        // display large = your name (big heading)
        displayLarge: GoogleFonts.syne(
          fontSize: 56,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -1.5,
        ),
        // display medium = section titles
        displayMedium: GoogleFonts.poppins(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        // title large = card titles
        titleLarge: GoogleFonts.syne(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        // body large = normal text
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.textSecondary,
          height: 1.7,
        ),
        // body medium = smaller text
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.bgCard,
      ),
    );
  }
}