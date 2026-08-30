import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'Screens/home_page.dart';
import 'Themes/dark_theme.dart';
import 'Themes/light_theme.dart';
import 'Themes/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  String version = '1.0.0';
  final String appName = 'Note App';

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return Consumer<ThemeProvider>(
          builder: (_, provider, __) {
            return MaterialApp(
              theme: buildLightTheme(lightDynamic),
              darkTheme: buildDarkTheme(darkDynamic),
              themeMode: provider.themeMode,
              debugShowCheckedModeBanner: false,
              home: HomePage(appName: appName, version: version),
            );
          },
        );
      },
    );
  }
}

