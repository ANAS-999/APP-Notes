import 'package:flutter/material.dart';

//! Dark
Color card = const Color(0xFF2A2A3D);
Color primary = Colors.blue.shade300;
Color secondary = const Color(0xFFE4E5E9);
Color background = const Color(0xFF22222F);

ThemeData darkTheme = ThemeData(
  cardColor: card,
  useMaterial3: true,
  fontFamily: 'TiltNeon',
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: primary,
    secondary: secondary,
    surface: background,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Color(0x7AFFFFFF), fontSize: 15),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  dividerTheme: const DividerThemeData(color: Color(0x21FFFFFF)),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white),
);
