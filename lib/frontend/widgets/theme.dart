import 'package:flutter/material.dart';

// Light Theme
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.orange, // Base color for the playful theme
    brightness: Brightness.light,
  ).copyWith(
    primary: const Color(0xFFFF5733), // Vibrant orange for primary actions
    secondary: const Color(0xFF1ABC9C), // Aqua for secondary elements
    surface: Colors.white, // White for surfaces like cards, chat bubbles
    onPrimary: Colors.white, // Text/icon color on primary
    onSecondary: Colors.white, // White text on secondary elements
    onSurface: const Color(0xFF333333), // Dark gray text for surfaces
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF333333)), // Main text color
    bodyMedium: TextStyle(color: Color(0xFF333333)),
    labelLarge: TextStyle(color: Color(0xFFFF5733)), // Accent text
  ),
);

// Dark Theme with Gold Accents
final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple, // Base color for dark theme
    brightness: Brightness.dark,
  ).copyWith(
    primary: const Color(0xFFFFD700), // Gold for primary actions
    secondary: const Color(0xFF8E44AD), // Deep purple for secondary elements
    surface: const Color(0xFF121212), // Very dark gray for surfaces
    onPrimary: const Color(0xFF121212), // Black text/icon color on primary
    onSecondary: Colors.white, // White text on secondary elements
    onSurface: const Color(0xFFBDBDBD), // Light gray text for surfaces
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // Main text color
    bodyMedium: TextStyle(color: Colors.white),
    labelLarge: TextStyle(color: Color(0xFFFFD700)), // Gold accent text
  ),
);
