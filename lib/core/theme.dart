import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Colors.deepOrange;
  static const primaryGreen = Color(0xFF00d4b1);
  static const lightBlue = Color(0xff05baff);
  static const bgWhite = Color(0xFFf7f8f6);
  static const bgBlue = Color(0xff0f1116);
  static const darkerBlue = Color(0xff0d2c43);
  static const cardBlack = Color(0xff1b1d22);
  static const cardWhite = Color(0xfffafbfc);
  static const lighterBlue = Color(0xffbce4ff);
  static const orange = Color(0xffb46b53);
  static const yellow = Color(0xffb9b483);
  static const red = Color(0xFFef4444);
  static const green = Color(0xFF43A047);
  static const white = Color(0xFFffffff);
  static const gray = Color(0xFFe6e7eb);
  static const darkGray = Colors.grey;
  static const lightGreen = Color(0xFF1c2d21);
  static const black = Color(0xFF070909);
}

class AppTheme {
  static final darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    secondaryHeaderColor: AppColors.darkerBlue,
    scaffoldBackgroundColor: AppColors.bgBlue,
    highlightColor: AppColors.darkerBlue,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.primary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF0066FF),
      unselectedItemColor: Colors.grey,
      backgroundColor: AppColors.bgBlue,
    ),
    cardColor: AppColors.cardBlack,
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.bgWhite),
      labelStyle: TextStyle(color: AppColors.bgWhite),
      contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10, right: 10),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.bgWhite),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.bgWhite),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),

      headlineMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),

      titleLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.white,
      ),
      titleSmall: GoogleFonts.inter(fontSize: 12, color: AppColors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgBlue,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.white),
      actionsIconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      centerTitle: false,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    secondaryHeaderColor: AppColors.darkGray,
    highlightColor: AppColors.lighterBlue,
    cardColor: AppColors.gray,
    scaffoldBackgroundColor: AppColors.bgWhite,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF0066FF),
      unselectedItemColor: Colors.grey,
      backgroundColor: AppColors.bgWhite,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.primary,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.bgBlue),
      labelStyle: TextStyle(color: AppColors.bgBlue),
      contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10, right: 10),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.bgBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.bgBlue),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),

      titleLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
      titleSmall: GoogleFonts.inter(fontSize: 12, color: AppColors.black),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgWhite,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.black),
      actionsIconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
