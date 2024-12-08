import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'Screens/home_page.dart';
import 'Themes/dark_theme.dart';
import 'Themes/light_theme.dart';
import 'Themes/theme_provider.dart';

Future<void> main() async {
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider()..initialize(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String version = '0.0.0';
  final String appName = 'Note App';

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, provider, __) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: provider.themeMode,
          debugShowCheckedModeBanner: false,
          
          home: HomePage(appName: appName, version: version),
        );
      },
    );
  }
}
