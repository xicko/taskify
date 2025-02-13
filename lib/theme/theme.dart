import 'package:fleather/fleather.dart';
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
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.transparent,
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
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.transparent,
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

// Used in editor
FleatherThemeData lightFleather = FleatherThemeData(
  bold: TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.black,
    fontWeight: FontWeight.bold,
  ),
  italic: TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.black,
    fontStyle: FontStyle.italic,
  ),
  underline: TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.black,
    decoration: TextDecoration.underline,
  ),
  strikethrough: TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.black,
    decoration: TextDecoration.lineThrough,
  ),
  inlineCode: InlineCodeThemeData(
    style: TextStyle(
      fontFamily: 'DM Mono',
      color: Colors.black,
    ),
    backgroundColor: Colors.grey[200],
  ),
  link: TextStyle(
    fontFamily: 'DM Sans',
    color: const Color.fromARGB(255, 14, 68, 112),
    decoration: TextDecoration.underline,
  ),
  paragraph: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      color: Colors.black,
      fontSize: 14,
    ),
    spacing: VerticalSpacing(),
  ),
  heading1: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 36,
      color: Colors.black,
    ),
    spacing: VerticalSpacing(),
  ),
  heading2: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 30,
      color: Colors.black,
    ),
    spacing: VerticalSpacing(),
  ),
  heading3: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 24,
      color: Colors.black,
    ),
    spacing: VerticalSpacing(),
  ),
  heading4: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 20,
      color: Colors.black,
    ),
    spacing: VerticalSpacing(),
  ),
  heading5: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 18,
      color: Colors.black,
    ),
    spacing: VerticalSpacing(),
  ),
  heading6: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 16,
      color: Colors.black,
    ),
    spacing: VerticalSpacing(),
  ),
  lists: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      color: Colors.black,
    ),
    spacing: VerticalSpacing(),
  ),
  quote: TextBlockTheme(
      style: TextStyle(
        fontFamily: 'DM Sans',
        color: Colors.black,
        fontStyle: FontStyle.italic,
      ),
      spacing: VerticalSpacing()),
  code: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Mono',
      color: Colors.black,
    ),
    spacing: VerticalSpacing(),
  ),
  horizontalRule: HorizontalRuleThemeData(
    height: 3.0,
    thickness: 3.0,
    color: Colors.black,
  ),
);

// Used in listDetailPage
FleatherThemeData darkFleather = FleatherThemeData(
  bold: TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
  italic: TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.white,
    fontStyle: FontStyle.italic,
  ),
  underline: TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.white,
    decoration: TextDecoration.underline,
  ),
  strikethrough: TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.white,
    decoration: TextDecoration.lineThrough,
  ),
  inlineCode: InlineCodeThemeData(
    style: TextStyle(
      fontFamily: 'DM Mono',
      color: Colors.white,
    ),
    backgroundColor: Color.fromARGB(255, 33, 59, 76),
  ),
  link: TextStyle(
    fontFamily: 'DM Sans',
    color: const Color.fromARGB(255, 58, 139, 206),
    decoration: TextDecoration.underline,
  ),
  paragraph: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      color: Colors.white,
      fontSize: 14,
    ),
    spacing: VerticalSpacing(),
  ),
  heading1: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 36,
      color: Colors.white,
    ),
    spacing: VerticalSpacing(),
  ),
  heading2: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 30,
      color: Colors.white,
    ),
    spacing: VerticalSpacing(),
  ),
  heading3: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 24,
      color: Colors.white,
    ),
    spacing: VerticalSpacing(),
  ),
  heading4: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 20,
      color: Colors.white,
    ),
    spacing: VerticalSpacing(),
  ),
  heading5: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 18,
      color: Colors.white,
    ),
    spacing: VerticalSpacing(),
  ),
  heading6: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 16,
      color: Colors.white,
    ),
    spacing: VerticalSpacing(),
  ),
  lists: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Sans',
      color: Colors.white,
    ),
    spacing: VerticalSpacing(),
  ),
  quote: TextBlockTheme(
      style: TextStyle(
        fontFamily: 'DM Sans',
        color: Colors.white,
        fontStyle: FontStyle.italic,
      ),
      spacing: VerticalSpacing()),
  code: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'DM Mono',
      color: Colors.white,
    ),
    spacing: VerticalSpacing(),
  ),
  horizontalRule: HorizontalRuleThemeData(
    height: 3.0,
    thickness: 3.0,
    color: Colors.white,
  ),
);
