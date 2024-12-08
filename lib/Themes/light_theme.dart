import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//! Light
Color card = const Color(0xFFEEF1F3);
Color primary = const Color(0xFF0055F1);
Color secondary = const Color(0xFFD9D9D9);
Color background = const Color(0xFFFFFFFF);
//Color background = const Color(0xFFEEF6FF);

ThemeData lightTheme = ThemeData(
  cardColor: card,
  useMaterial3: true,
  fontFamily: 'TiltNeon',
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: primary,
    secondary: secondary,
    surface: background,
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ),
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Color(0x9F000000), fontSize: 15),
  ),
  //iconTheme: IconThemeData(color: primary),
  listTileTheme: ListTileThemeData(iconColor: primary),
  dividerTheme: const DividerThemeData(color: Color(0x1F000000)),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
);
