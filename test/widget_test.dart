import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:note_app/Themes/light_theme.dart';
import 'package:note_app/Themes/dark_theme.dart';
import 'package:note_app/Themes/theme_provider.dart';
import 'package:note_app/Screens/settings_page.dart';

void main() {
  test('Light and Dark M3 themes initialize properly', () {
    final light = buildLightTheme(null);
    final dark = buildDarkTheme(null);

    expect(light.useMaterial3, isTrue);
    expect(dark.useMaterial3, isTrue);
    expect(light.colorScheme.brightness, Brightness.light);
    expect(dark.colorScheme.brightness, Brightness.dark);
  });

  testWidgets('SettingsPage renders with Material You styling', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(),
        child: MaterialApp(
          theme: buildLightTheme(null),
          home: const SettingsPage(appName: 'Note App', version: '1.0.0'),
        ),
      ),
    );

    expect(find.text('Settings'), findsAtLeastNWidgets(1));
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Theme Mode'), findsOneWidget);
    expect(find.text('About & Support'), findsOneWidget);
    expect(find.text('About App'), findsOneWidget);
  });
}


