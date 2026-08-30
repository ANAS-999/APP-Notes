import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_color/dynamic_color.dart';

// Default seed color for fallback Material 3 palette
const Color defaultSeedColor = Color(0xFF006492);

final ColorScheme defaultLightColorScheme = ColorScheme.fromSeed(
  seedColor: defaultSeedColor,
  brightness: Brightness.light,
);

ThemeData buildLightTheme(ColorScheme? dynamicColorScheme) {
  final colorScheme = (dynamicColorScheme ?? defaultLightColorScheme).harmonized();

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'TiltNeon',
    brightness: Brightness.light,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 3.0,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      foregroundColor: colorScheme.onSurface,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      titleTextStyle: TextStyle(
        fontFamily: 'TiltNeon',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      margin: EdgeInsets.zero,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 2,
      highlightElevation: 4,
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 2,
      backgroundColor: colorScheme.surfaceContainer,
      indicatorColor: colorScheme.secondaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontFamily: 'TiltNeon',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          );
        }
        return TextStyle(
          fontFamily: 'TiltNeon',
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurfaceVariant,
        );
      }),
    ),
    navigationRailTheme: NavigationRailThemeData(
      elevation: 0,
      backgroundColor: colorScheme.surfaceContainer,
      indicatorColor: colorScheme.secondaryContainer,
      selectedIconTheme: IconThemeData(color: colorScheme.onSecondaryContainer),
      unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      selectedLabelTextStyle: TextStyle(
        fontFamily: 'TiltNeon',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontFamily: 'TiltNeon',
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurfaceVariant,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colorScheme.surfaceContainerHigh,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      titleTextStyle: TextStyle(
        fontFamily: 'TiltNeon',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colorScheme.surfaceContainerLow,
      elevation: 1,
      showDragHandle: true,
      dragHandleColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
      thickness: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHigh,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}

ThemeData lightTheme = buildLightTheme(null);
