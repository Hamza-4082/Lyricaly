import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTheme {
  static const Color spotifyGreen = Color(0xFF1DB954);


  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    const surface = Color(0xFF121212);
    const surface2 = Color(0xFF181818);


    final scheme = const ColorScheme.dark(
      primary: spotifyGreen,
      secondary: Color(0xFF1ED760),
      surface: surface,
      background: surface,
      onSurface: Colors.white,
      onBackground: Colors.white,
    );


    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface2,
        selectedItemColor: spotifyGreen,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      cardColor: surface2,
      dividerColor: Colors.white12,
      iconTheme: const IconThemeData(color: Colors.white70),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: surface2,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}