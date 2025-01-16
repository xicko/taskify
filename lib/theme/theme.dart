import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  fontFamily: 'DM Sans',
  scaffoldBackgroundColor: Color.fromARGB(255, 143, 210, 255),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 143, 210, 255), // Main blue theme color
    onPrimary: Colors.black, // Text/icons on primary color
    secondary: Colors.black87, // Secondary black for accents
    onSecondary: Colors.white, // Text/icons on secondary color
    surface: Colors.white, // Card, modal, and surface elements
    onSurface: Colors.black87, // Text/icons on surface
    error: Colors.redAccent, // Error color
    onError: Colors.white, // Text/icons on error color
    tertiary: Colors.black45, // Muted color for less important elements
    outline: Colors.black26, // For borders or outlines
    shadow: Colors.black12, // Subtle shadow effect
    primaryContainer: Color.fromARGB(
        255, 196, 231, 255), // Highlighted container with primary tone
    onPrimaryContainer: Colors.black87, // Text/icons on primary container
    secondaryContainer:
        Colors.black12, // Highlighted container with secondary tone
    onSecondaryContainer: Colors.black87, // Text/icons on secondary container
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Color.fromARGB(255, 38, 38, 38),
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 0,
    shadowColor: Colors.black,
    backgroundColor: Colors.white,
    indicatorColor: Color.fromARGB(255, 196, 231, 255),
    labelTextStyle: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(color: Colors.black);
        } else {
          return TextStyle(color: Colors.black54);
        }
      },
    ),
    iconTheme: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: Colors.black87,
          );
        } else {
          return IconThemeData(
            color: Colors.black45,
          );
        }
      },
    ),
  ),
);

// will do darkmode later
ThemeData darkMode = ThemeData(
  fontFamily: 'DM Sans',
  scaffoldBackgroundColor: Color.fromARGB(255, 20, 40, 53),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary:
        Color.fromARGB(255, 105, 162, 200), // Muted blue for dark backgrounds
    onPrimary: Colors.white, // Text/icons on primary color
    secondary: Colors.white70, // Secondary white for accents
    onSecondary: Colors.black, // Text/icons on secondary color
    surface: Color.fromARGB(255, 24, 24, 24), // Dark surface for cards/modals
    onSurface: Colors.white70, // Text/icons on surface
    error: Colors.redAccent, // Error color (same as light mode for consistency)
    onError: Colors.black, // Text/icons on error color
    tertiary: Colors.white38, // Muted color for less important elements
    outline: Colors.white24, // For borders or outlines
    shadow: Colors.black87, // Subtle shadow effect for dark mode
    primaryContainer: Color.fromARGB(
        255, 52, 89, 111), // Highlighted container with primary tone
    onPrimaryContainer: Colors.white, // Text/icons on primary container
    secondaryContainer: Color.fromARGB(
        255, 40, 40, 40), // Highlighted container with secondary tone
    onSecondaryContainer: Colors.white70, // Text/icons on secondary container
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Color.fromARGB(255, 205, 205, 205),
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 0,
    shadowColor: Colors.black,
    backgroundColor: Color.fromARGB(255, 12, 27, 36),
    indicatorColor: Color.fromARGB(80, 143, 210, 255),
    labelTextStyle: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(color: Colors.white);
        } else {
          return TextStyle(color: Colors.white54);
        }
      },
    ),
    iconTheme: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: Colors.white,
          );
        } else {
          return IconThemeData(
            color: Colors.white54,
          );
        }
      },
    ),
  ),
);
